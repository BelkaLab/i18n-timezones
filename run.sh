#!/usr/bin/env bash
help="run.sh <tag> [<outputFile>] [<devKey>]"

docker build -t translations-tools:latest .

if [[ $? -eq 0 ]]; then
    if [[ -z $1 ]]; then
        echo "You must specify the lang tag"
        echo "${help}"
        exit 1
    fi

    devKey=""
    outputFile=""

    if [[ ${#} -eq 2 ]]; then
        outputFile=${2}
    elif [[ ${#} -eq 3 ]]; then
        outputFile=${2}
        devKey=${3}
        echo "$devKey"
    fi

    if [[ (-z ${devKey}) ]]; then
        if [[ (-n "${DEVELOPER_KEY}") ]]; then
            devKey="${DEVELOPER_KEY}"
        else
            echo "You must specify a DEVELOPER_KEY environmental var, or the third argument must be the a valid google developer key. The environmental var takes precedence."
            echo "${help}"
            exit 1
        fi
    fi

    optDocker="-e developerKey=${devKey}"
    optApp=""

    if [[ -n ${outputFile} ]]; then
        optApp+="-o ${outputFile} "
    fi

    optApp+="${1}"

    docker run -d --name translations-tools-postgres --rm -e POSTGRES_PASSWORD=mysecretpassword -d postgres postgres

    prova=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}:5432' translations-tools-postgres)
    echo $prova
    inspect_error=${?}

    TIMEOUT=10
    until docker run -e PGPASSWORD=mysecretpassword --link translations-tools-postgres:pg postgres /usr/bin/psql -h pg -U postgres -d postgres -c "select 1" > /dev/null 2>&1 || [ $TIMEOUT -eq 0 ]; do
      echo "Waiting for postgres server, $((TIMEOUT--)) remaining attempts..."
      sleep 1
    done

    docker run -it --rm --name translations-tools -v "$PWD":/usr/src/myapp --link translations-tools-postgres:pg ${optDocker} -w /usr/src/myapp translations-tools python xliffTimeZone.py ${optApp}
fi

