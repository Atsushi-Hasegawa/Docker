#!/bin/sh

container=$1

build_name=`sudo docker ps | grep $container`

if [ "$build_name" = "" ]; then
    port=`sudo docker ps -q | xargs sudo docker inspect --format='{{ if index .NetworkSettings.Ports "22/tcp" }}{{(index (index .NetworkSettings.Ports "22/tcp") 0).HostPort}}{{ end }}' | sed '/^$/d' | head -n 1`
    sudo docker build -t $container .
    if [ "$port" = "" ]; then
        port=2222
    else
        port=`expr $port + 1`
    fi
    sudo docker run -d -p $port:22 -i -t $container
fi

container_id=`sudo docker ps | grep ${container} | awk -F ' ' '{print $1}'`
if [ "$container_id" != "" ]; then
    host=`sudo docker inspect --format="{{ .NetworkSettings.IPAddress }}" $container_id`
    echo "host:$host"
    ssh root@$host
fi
