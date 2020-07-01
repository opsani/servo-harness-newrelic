FROM python:3.6-slim
WORKDIR /servo
# Install dependencies
RUN apt update && apt -y install curl jq
RUN pip3 install requests PyYAML python-dateutil

# add agg driver
RUN mkdir -p adjust.d
ADD https://raw.githubusercontent.com/opsani/servo-agg/master/adjust \
    https://raw.githubusercontent.com/opsani/servo-agg/master/util.py \
    /servo/

ADD https://raw.githubusercontent.com/opsani/servo/master/adjust.py /servo/
ADD https://raw.githubusercontent.com/opsani/servo-harness/promote/adjust /servo/adjust.d/canary
ADD https://raw.githubusercontent.com/opsani/servo-harness/promote/adjust /servo/adjust.d/mainline

ADD https://raw.githubusercontent.com/opsani/servo/master/servo \
    https://raw.githubusercontent.com/opsani/servo/master/measure.py \
    https://raw.githubusercontent.com/opsani/servo-newrelic/monitoring-instance-ids/measure \
    ./get-newrelic-instance-ids \
    /servo/

# RUN ln -s /servo/adjust.d/adjust.py /servo/adjust.py
RUN chmod a+rwx /servo/get-newrelic-instance-ids /servo/adjust.py
RUN chmod a+rwx /servo/adjust /servo/measure /servo/servo
RUN chmod a+rx /servo/adjust.d/canary
RUN chmod a+rx /servo/adjust.d/mainline
RUN chmod a+rw /servo/measure.py /servo/adjust.py
ENV PYTHONUNBUFFERED=1
ENV OPTUNE_USE_DRIVER_NAME=1
ENTRYPOINT [ "python3", "servo", "--verbose" ]
