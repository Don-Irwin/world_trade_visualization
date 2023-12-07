#!/bin/bash

IMAGE_NAME=w209_proj_don_irwin
APP_NAME=w209_proj_don_irwin
DOCKER_FILE=Dockerfile.209proj

#docker rmi $(docker images --filter "dangling=true" -q --no-trunc)

echo "docker stop ${APP_NAME}"
docker stop ${APP_NAME}
echo "docker rm ${APP_NAME}"
docker rm ${APP_NAME}

#*****************
#Kill all processes running ports.
#*****************

#array of ports used by fastapi or dasboard
server_ports_used=("8888")
server_ports_used+=("5001")


    #If yess, kill all the processes running fastapi / guinicorn
    for m_port in "${server_ports_used[@]}"
    do

        pid_to_kill=$(lsof -t -i :$m_port -s TCP:LISTEN)

        echo "pid_to_kill=$pid_to_kill"

        #Check if the variable is defined and if it has values
        #and if it has values in it.
        if [[ $pid_to_kill && ${pid_to_kill-_} ]]; then
        for ptk in "${pid_to_kill[@]}" ; do
            sudo kill -9 ${ptk}
        done
        fi

    done



docker pull donirwinberkeley/w209_proj_don_irwin:x86_latest
docker run --name w209_proj_don_irwin -p  8888:8888 -p 5001:5000  donirwinberkeley/w209_proj_don_irwin:x86_latest > /dev/null &

finished=false
while ! $finished; do
    health_status=$(curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://127.0.0.1:5001")
    if [ $health_status == "200" ]; then
        finished=true
        echo "*********************************"
        echo "*                               *"
        echo "*        Flask is ready         *"
        echo "*                               *"
        echo "*********************************"
    else
        finished=false
    fi
done

google-chrome "http://127.0.0.1:5001" &

echo "***********************************"
echo "*                                 *"
echo "* Access Flask at the following   *"
echo "* Address                         *"
echo "* http://127.0.0.1:5001           *"
echo "*                                 *"
echo "***********************************"
finished=false
while ! $finished; do
    health_status=$(curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://127.0.0.1:8888/tree?")
    if [ $health_status == "200" ]; then
        finished=true
        echo "*********************************"
        echo "*                               *"
        echo "*      Jyputer is ready         *"
        echo "*                               *"
        echo "*********************************"
    else
        finished=false
    fi
done

google-chrome "http://127.0.0.1:8888/tree?" &

echo "***********************************"
echo "*                                 *"
echo "* Access Jupyter at the following *"
echo "* Address                         *"
echo "* http://127.0.0.1:8888/tree?     *"
echo "*                                 *"
echo "***********************************"
