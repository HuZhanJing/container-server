#put mongoImage.tar.gz and mongodata.tar.gz under same folder then run this script

#!/bin/bash
cd shells
docker ps |grep mongodb1 > mongorun
mongorun=`cat mongorun`
if [ -z "$mongorun" ];then
  if [ $# = 2 ];then
    ip=$1
    port=$2
    process="1"
    if [ -e mongodata.tar.gz ] && [ $process = "1" ];then
      mkdir -p /home/dockermongo/db1
      tar -zxvf mongodata.tar.gz -C /home/dockermongo/db1
      echo "mongo data unzip to /home/dockermongo/db1"
      process="2"
    else
      exit 1
    fi
    if [ -n $ip ] && [ -n $port ] && [ $process = "2" ];then
      hostname $ip
      echo "change hostname into:$ip"
      docker run --name mongodb1 -v /home/dockermongo/db1:/data/db:z --network=host -d docker.io/mongo:4.0.10 --port $port --smallfiles --replSet tc
      sleep 3
      docker ps
      docker exec mongodb1 mongo --port $port WordPress --eval "rs.initiate()"
      docker exec mongodb1 mongo --port $port WordPress --eval "rs.reconfig({_id:'tc', members: [{_id: 0,host:'$ip:$port'}],protocolVersion:1},{force:true})"
      echo "mongo cluster inited"
      exit 0
    else
      exit 1
    fi
  else
    echo "Please run as: sh mongo.sh ip port"
    exit 1
  fi
else
  echo "There is a running mongo container, please remove it"
  exit 1
fi
