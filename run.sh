#!/usr/bin/env bash
help="run.sh <tag> [-o <outputFile>] [-k <devKey>]"

echo "Building the Docker image..."

docker build -t translations-tools:latest . > /dev/null 2>&1

if [[ $? -eq 0 ]]; then
    echo $'Built.\n\n'

    if [[ -z $1 ]]; then
        echo $'You must specify the lang tag\n'
        echo "${help}"
        exit 1
    fi

    devKey=""
    outputFile=""
    tag=""

    while [[ ${#} -ge 1 ]]; do
        key="$1"

        case $key in
            -o|--outputfile)
            outputFile="$2"
            shift
            ;;
            -k|--devKey)
            devKey="$2"
            shift
            ;;
            *)
            tag=$key
            ;;
        esac
        shift
    done

    if [[ (-z ${tag}) ]]; then
        echo $'Please specify a lang tag.\n'
        echo "${help}"
        exit 1
    fi

    if [[ (-z ${devKey}) ]]; then
        if [[ (-n "${DEVELOPER_KEY}") ]]; then
            devKey="${DEVELOPER_KEY}"
        else
            echo $'You must specify a DEVELOPER_KEY environmental var, or the -k argument must be the a valid google developer key. The flag takes precedence.\n'
            echo "${help}"
            exit 1
        fi
    fi

    optDocker="-e developerKey=${devKey}"
    optApp=""

    if [[ -n ${outputFile} ]]; then
        optApp+="-o ${outputFile} "
    fi

    optApp+="${tag}"

    echo "Running Postgres..."
    docker run -d --name translations-tools-postgres --rm -e POSTGRES_PASSWORD=mysecretpassword -d postgres postgres > /dev/null 2>&1

    TIMEOUT=10
    until docker run -e PGPASSWORD=mysecretpassword --link translations-tools-postgres:pg postgres /usr/bin/psql -h pg -U postgres -d postgres -c "select 1" > /dev/null 2>&1 || [ $TIMEOUT -eq 0 ]; do
      echo "Waiting for postgres server, $((TIMEOUT--)) remaining attempts..."
      sleep 1
    done

    docker run -it --rm --name translations-tools -v "$PWD":/usr/src/myapp --link translations-tools-postgres:pg ${optDocker} -w /usr/src/myapp translations-tools python xliffTimeZone.py ${optApp}
fi

