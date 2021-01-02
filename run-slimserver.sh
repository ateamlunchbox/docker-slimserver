#!/bin/bash

# Read squeezeboxserver user ID from env vars and update the ID so
# the permissions will align w/ the volumes mounted in from the
# host OS.
/usr/sbin/usermod -u $SLIMSERVER_UID squeezeboxserver

/bin/chown -R squeezeboxserver \
  /var/lib/squeezeboxserver \
  /var/log/squeezeboxserver

/usr/sbin/squeezeboxserver_safe /usr/sbin/squeezeboxserver \
  --cliport 0 \
  --user squeezeboxserver \
  --prefsdir /var/lib/squeezeboxserver/prefs \
  --logdir /var/log/squeezeboxserver/ \
  --cachedir /var/lib/squeezeboxserver/cache \
  --charset=utf8
