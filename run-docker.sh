#!/bin/bash

# When calling this, may want to provide 
SLIMSERVER_UID=${DOCKER_SLIMSERVER_UID:-1001}
SLIMSERVER_GID=${DOCKER_SLIMSERVER_GID:-1001}

SLIMSERVER_MEDIA_DIR=${DOCKER_SLIMSERVER_MEDIA_DIR:-/var/lib/squeezeboxserver/media}

DOCKER_ARGS="
  -p 9000:9000 
  -p 3483:3483 
  -p 3483:3483/udp 
  --hostname=\"$HOSTNAME-docker-slimserver\" 
  -v /etc/localtime:/etc/localtime:ro 
  -v /var/lib/squeezeboxserver:/var/lib/squeezeboxserver 
  -v /var/log/squeezeboxserver:/var/log/squeezeboxserver 
  -v $SLIMSERVER_MEDIA_DIR:/media:ro
  -e SLIMSERVER_UID=$SLIMSERVER_UID 
  -e SLIMSERVER_GID=$SLIMSERVER_GID
  --name=lms  
  $USER/slimserver"

if [ $# != 0 ]; then
  echo 'Running as daemon'
  docker run -d $DOCKER_ARGS
else
  echo 'Running interactively'
  docker run --entrypoint /bin/bash -it --rm $DOCKER_ARGS
fi
