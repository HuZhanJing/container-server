#put zkImage.tar.gz  under same folder then run this script

#!/bin/bash
cd shells
docker ps |grep zk1> zkrun
zkrun=`cat zkrun`
if [ -z "$zkrun" ];then
  if [ $# = 1 ];then
    port=$1
    process="1"
    if [ ! -e /home/dockerzk/db1/zoo.cfg ] && [ $process = "1" ];then
      mkdir -p /home/dockerzk/db1/log
      touch /home/dockerzk/db1/zoo.cfg
      mkdir -p /home/dockerkafka/db1/log
      cat > /home/dockerzk/db1/zoo.cfg << EOF
tickTime=2000
minSessionTimeout=20000
maxSessionTimeout=30000
initLimit=5
syncLimit=2
dataDir=/data
dataLogDir=/datalog
clientPort=$port
4lw.commands.whitelist=*
EOF
      process="2"
      echo "setup config"
    else
      echo "Config file existed"
      exit 1
    fi
    if [ -n $port ] && [ $process = "2" ];then
      docker run --name zk1 -d --network=host -v /home/dockerzk/db1:/data -v /home/dockerzk/db1/log:/datalog -v /home/dockerzk/db1/zoo.cfg:/conf/zoo.cfg docker.io/zookeeper:3.5.5
      sleep 3
      docker ps|grep zk1
      exit 0
    else
      echo "Run zk failed"
      exit 1
    fi
  else
    echo "Please run as: sh zk.sh port"
    echo "Please supply port for zookeeper"
    exit 1
  fi
else
  echo "There is a running zk container, please remove it"
  exit 1
fi
