#!/bin/sh

# update btsync.conf with the SECRET KEY
BTSYNC_SEC=$(cat /var/run/secrets/deis/minio/secret/btsync-secret)
sed -i "s|_SECRECT_|$BTSYNC_SEC|" /opt/btsync/btsync.conf

# magically renumber the nobody user
sed -i "s|nobody:x:65534:65534:|nobody:x:$USERID:$GROUPID:|" /etc/passwd
sed -i "s|nobody:x:65534:|nobody:x:$GROUPID:|" /etc/group

# provide a nice nobody
mkdir -p /config/.sync
chown -R nobody:nobody /config/*

exec gosu nobody:nobody \
  /usr/bin/btsync --nodaemon --config /opt/btsync/btsync.conf --log /config/btsync.log
