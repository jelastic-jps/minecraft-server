#!/bin/bash

JAVA_OPTS=$JVM_OPTS

source /data/memoryConfig.sh

GC_PERIOD=${GC_PERIOD:-300}
GC_DEBUG=${GC_DEBUG:-0}

[ "$VERT_SCALING" != "false" -a "$VERT_SCALING" != "0" ] && JAVA_OPTS="$JAVA_OPTS -javaagent:/data/jelastic-gc-agent.jar=period=$GC_PERIOD,debug=$GC_DEBUG"

JVM_OPTS=$JAVA_OPTS

apk add screen

VANILLA_VERSION=$(ls /data/minecraft_server* |  awk -F "." '{ print $2"."$3"."$4 }');

[ ! -z $VANILLA_VERSION ] && sed -i "s/VANILLA_VERSION/$VANILLA_VERSION/g" /data/web/index.html
pushd /data/web; screen -md python -m SimpleHTTPServer 8080 ; popd;

source /start
