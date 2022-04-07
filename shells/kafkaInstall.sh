#put kafkaImage.tar.gz  under same folder then run this script, make sure zookeeper is working before run this script

#!/bin/bash
cd shells
docker ps |grep zk1> zkrun
zkrun=`cat zkrun`
docker ps |grep kafka> kafkarun
kafkarun=`cat kafkarun`
if [ -z "$kafkarun" ] && [ ! -z "$zkrun" ];then
  if [ $# = 3 ];then
    ip=$1
    port=$2
    port2=$3
    process="1"
    if [ -n $port ] && [ $process = "1" ];then
      docker run -d --name=kafka1 --network=host --privileged=true  -v /etc/hosts:/etc/hosts -v /home/dockerkafka/db:/kafka/kafka-logs-localhost.localdomain -v /home/dockerkafka/db1/log:/opt/kafka/logs -e KAFKA_ADVERTISED_HOST_NAME=$ip -e JMX_PORT=9991 -e HOST_IP=127.0.0.1 -e KAFKA_ADVERTISED_PORT=$port  -e KAFKA_BROKER_ID=0 -e KAFKA_HEAP_OPTS="-Xmx1024M -Xms512M" -e KAFKA_ZOOKEEPER_CONNECT=$ip:$port2 -e KAFKA_NUM_PARTITIONS=1 -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 -e KAFKA_TRANSATION_STATE_LOG_REPLICATION_FACTOR=1 -e KAFKA_TRANSATION_STATE_LOG_MIN_ISR=1 -e KAFKA_LISTENERS=PLAINTEXT://$ip:$port -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://$ip:$port docker.io/wurstmeister/kafka:2.12-2.1.1
      sleep 3
      docker ps|grep kafka1
      echo "kafka1 is running"
      exit 0
    else
      echo "Run kafka failed"
      exit 1
    fi
  else
    echo "Please run as: sh kafka.sh port zkport"
    echo "Please supply port for kafka and port of zookeeper, make sure zookeeper is working before run this script"
    exit 1
  fi
else
  echo "There is a running kafka container, please remove it or there is no running zookeeper container, please run it"
  exit 1
fi
