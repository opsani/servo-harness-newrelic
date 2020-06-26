FROM python:3.6-slim
WORKDIR /servo
# Install dependencies
RUN apt update && apt -y install curl
RUN pip3 install requests PyYAML python-dateutil jq
# Install servo:  batch adjust (which uses the servo base adjust.py) and
# batch measure (which uses the servo base measure.py) and
# servo/state_store used by both measure and adjust
ADD https://raw.githubusercontent.com/opsani/servo/master/servo \
    https://raw.githubusercontent.com/opsani/servo/master/adjust.py \
    https://raw.githubusercontent.com/opsani/servo-harness/master/adjust \
    https://raw.githubusercontent.com/opsani/servo-newrelic/monitoring-instance-ids/measure \
    https://raw.githubusercontent.com/opsani/servo/master/measure.py \
    https://raw.githubusercontent.com/opsani/servo-vegeta/master/measure \
    https://raw.githubusercontent.com/opsani/servo-harness-newrelic/master/get-newrelic-instance-ids \
    ./adjust \
    /servo/
RUN chmod a+x /servo/adjust /servo/measure /usr/local/bin/vegeta /usr/local/bin/get-newrelic-instance-ids
RUN chmod a+rw /servo/measure.py /servo/adjust.py
ENV PYTHONUNBUFFERED=1
ENTRYPOINT [ "python3", "servo", "--verbose" ]
