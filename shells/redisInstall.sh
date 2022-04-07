#put redisImage.tar.gz  under same folder then run this script

#!/bin/bash
cd shells
docker ps |grep redis> redisrun
redisrun=`cat redisrun`
if [ -z "$redisrun" ];then
  if [ $# = 3 ];then
    ip=$1
    port=$2
    port2=$3
    process="1"
    if [ ! -e /home/dockerredis/db1/redis.conf ] && [ ! -e /home/dockerredis/db2/redis.conf ] && [ $process = "1" ];then
      mkdir -p /home/dockerredis/db1/log
      touch /home/dockerredis/db1/log/redis-server.log
      touch /home/dockerredis/db1/redis.conf
      mkdir -p /home/dockerredis/db2/log
      touch /home/dockerredis/db2/log/redis-server.log
      touch /home/dockerredis/db2/redis.conf
      cat > /home/dockerredis/db1/redis.conf << EOF
port $port
bind $ip
daemonize no
logfile "/var/log/redis/redis-server.log"
cluster-enabled yes
cluster-config-file nodes-7001.conf
cluster-node-timeout 15000
appendonly yes
appendfsync everysec
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-use-rdb-preamble yes
EOF
      cat > /home/dockerredis/db2/redis.conf << EOF
port $port2
bind $ip
daemonize no
logfile "/var/log/redis/redis-server.log"
cluster-enabled yes
cluster-config-file nodes-7002.conf
cluster-node-timeout 15000
appendonly yes
appendfsync everysec
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-use-rdb-preamble yes
EOF
      process="2"
    else
      exit 1
    fi
    if [ -n $ip ] && [ -n $port ] && [ -n $port2 ] && [ $process = "2" ];then
      docker run -d --name redis1 --network=host -v /home/dockerredis/db1:/data -v /home/dockerredis/db1/redis.conf:/usr/local/etc/redis/redis.conf -v /home/dockerredis/db1/log/:/var/log/redis/ docker.io/redis:4.0 redis-server /usr/local/etc/redis/redis.conf
      sleep 1
      docker run -d --name redis2 --network=host -v /home/dockerredis/db2:/data -v /home/dockerredis/db2/redis.conf:/usr/local/etc/redis/redis.conf -v /home/dockerredis/db2/log/:/var/log/redis/ docker.io/redis:4.0 redis-server /usr/local/etc/redis/redis.conf
      sleep 3
      process="3"
      echo $process
      if [ -e redis-5.0.0.tar.gz ];then
        tar -zxf redis-5.0.0.tar.gz -C ./
        echo "unzip redis-5.0.0.tar.gz finished"
      fi
      if [ -d redis-5.0.0 ] && [ $process = "3" ];then
        echo "yes" | redis-5.0.0/src/redis-cli --cluster fix $ip:$port >/dev/null
#add slave node
        redis-5.0.0/src/redis-cli --cluster add-node $ip:$port2 $ip:$port --cluster-slave
#add master node
#extend: redis-5.0.0/src/redis-cli --cluster add-node $newip:$newport $oldip:$oldport
#extend: redis-5.0.0/src/redis-cli --cluster rebalance $newip:$newport --cluster-threshold 1 --cluster-use-empty-masters
        docker ps|grep redis
        exit 0
      else
        exit 1
      fi
    else
      exit 1
    fi
  else
    echo "Please run as: sh redis.sh ip port1 port2"
    echo "Please use intranet ip, one port is for master, the other port is for slave"
    exit 1
  fi
else
  echo "There are(is) running redis container(s), please remove them(it)"
  exit 1
fi
