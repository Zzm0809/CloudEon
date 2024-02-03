#!/bin/bash
set -e

mkdir -p /workspace/logs

\cp -f /opt/service-render-output/myid /data/1/
\cp -f /opt/service-render-output/zoo.cfg $ZOOKEEPER_HOME/conf/
\cp -f /opt/service-render-output/zookeeper-env.sh $ZOOKEEPER_HOME/conf/

$ZOOKEEPER_HOME/bin/zkServer.sh start

sleep 5

until find /workspace/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
tail -F /workspace/logs/* &

echo "---------------------------------------------开始----------------------------------------------"
tail -f /dev/null

# 功能测试，不会自动执行
$ZOOKEEPER_HOME/bin/zkCli.sh  -server localhost:$ZK_CLIENT_PORT
ls /
create /tmp1
ls /
delete /tmp1
ls /
quit