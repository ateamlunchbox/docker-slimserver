#!/bin/bash

# Read configuration file, if it exists
FILENAME=`basename $0`
CONFIG=/etc/default/${FILENAME}
[ -e ${CONFIG} ] && . ${CONFIG}

SLIMSERVER_IMAGE_USERNAME=${DOCKER_SLIMSERVER_IMAGE_USERNAME:-$USER}

SLIMSERVER_UID=${DOCKER_SLIMSERVER_UID:-1001}
SLIMSERVER_GID=${DOCKER_SLIMSERVER_GID:-1001}

DOCKER_RESTART=" --restart=unless-stopped "
#DOCKER_RESTART=" --restart=no "
SLIMSERVER_ARGS=${DOCKER_SLIMSERVER_ARGS:-$DOCKER_RESTART}

SLIMSERVER_IP=${DOCKER_SLIMSERVER_IP}

SLIMSERVER_MEDIA_DIR=${DOCKER_SLIMSERVER_MEDIA_DIR:-/var/lib/squeezeboxserver/media}

SLIMSERVER_NAME=lms

DOCKER_COUNT=`docker ps -a -f name=${SLIMSERVER_NAME} | grep -v IMAGE | wc | awk '{print($1)}'`

if [ "${DOCKER_COUNT}" != "0" ]; then
  docker stop ${SLIMSERVER_NAME}
  docker rm ${SLIMSERVER_NAME}
fi

DOCKER_ARGS="
  -p ${SLIMSERVER_IP}9000:9000 
  -p ${SLIMSERVER_IP}3483:3483 
  -p ${SLIMSERVER_IP}3483:3483/udp 
  --hostname=\"$HOSTNAME-docker-slimserver\" 
  -v /etc/localtime:/etc/localtime:ro 
  -v /var/lib/squeezeboxserver:/var/lib/squeezeboxserver 
  -v /var/log/squeezeboxserver:/var/log/squeezeboxserver 
  -v $SLIMSERVER_MEDIA_DIR:/media:ro
  -e SLIMSERVER_UID=$SLIMSERVER_UID 
  -e SLIMSERVER_GID=$SLIMSERVER_GID
  --name=$SLIMSERVER_NAME
  ${SLIMSERVER_IMAGE_USERNAME}/slimserver"

if [ $# == 0 ]; then
  echo 'Running as daemon; --restart=unless-stopped will restart the container on reboot'
  docker run -d ${SLIMSERVER_ARGS} $DOCKER_ARGS
else
  echo 'Running interactively'
  docker run --entrypoint /bin/bash -it --rm $DOCKER_ARGS
fi
