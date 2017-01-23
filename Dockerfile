FROM python:2
MAINTAINER Matteo Bertamini <matteo@belka.us>
RUN /bin/bash -c 'pip install language-tags'
RUN /bin/bash -c 'pip install --upgrade google-api-python-client'
RUN /bin/bash -c 'pip install psycopg2'
RUN /bin/bash -c 'pip install prettify'