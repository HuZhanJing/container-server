#put turnImage.tar.gz  under same folder then run this script

#!/bin/bash
docker ps |grep turn> turnrun
turnrun=`cat turnrun`
if [ -z "$turnrun" ];then
  if [ $# = 4 ];then
    ip=$1
    port=$2
    user=$3
    passwd=$4
    process="1"
    if [ -n $ip ] && [ -n $port ] && [ -n $user ] && [ -n $passwd ] && [ $process = "1" ];then
      docker run -d --name turn --net=host synctree/coturn turnserver -n -a -v -r aoturn -E $ip -p $port -u $user:$passwd --log-file stdout -L $ip
      sleep 3
      docker ps|grep turn
      exit 0
    else
      echo "Run turn failed"
      exit 1
    fi
  else
    echo "Please run as: sh turn.sh ip port user password"
    echo "Please supply all params for turn, use ip which is listed in 'ip a', if both of public and private ips can be binded, use public ip for high priority"
    exit 1
  fi
else
  echo "There is a running turn container, please remove it"
  exit 1
fi
