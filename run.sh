#!/bin/sh

set -e
JAVA_DIR="/usr/share/java"
LIB_DIR=/opt/agent/dependencies
CLASSPATH="$LIB_DIR/*"

set +e

JAVA_START_HEAP=${JAVA_START_HEAP:-32m}
JAVA_MAX_HEAP=${JAVA_MAX_HEAP:-512m}

OOME_ARGS="-XX:OnOutOfMemoryError=\"/bin/kill -9 %p\""
JVM_ARGS="-server -Xms${JAVA_START_HEAP} -Xmx${JAVA_MAX_HEAP} $JVM_ARGS"

MAIN_CLASS="com.amazon.kinesis.streaming.agent.Agent"
JAVA_CMD=/usr/bin/java

# TODO: remove buid and ANT dirs

exec $JAVA_CMD $JVM_ARGS "$OOME_ARGS" \
  -cp "$CLASSPATH" \
  $MAIN_CLASS "$@"
