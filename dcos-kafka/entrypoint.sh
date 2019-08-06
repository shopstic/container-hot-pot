#!/usr/bin/env bash

set -euo pipefail

PORT_BROKER=${PORT_BROKER:?"PORT_BROKER is missing"}
KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://${HOST}:${PORT_BROKER}"
KAFKA_JVM_PERFORMANCE_OPTS=${KAFKA_JVM_PERFORMANCE_OPTS}
KAFKA_JVM_PERFORMANCE_OPTS="${KAFKA_JVM_PERFORMANCE_OPTS} -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=$PORT_JMX -Dcom.sun.management.jmxremote.rmi.port=$PORT_JMX -Dcom.sun.management.jmxremote.host=0.0.0.0 -Djava.rmi.server.hostname=$HOST -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
echo "KAFKA_JVM_PERFORMANCE_OPTS=${KAFKA_JVM_PERFORMANCE_OPTS}"

exec /etc/confluent/docker/run