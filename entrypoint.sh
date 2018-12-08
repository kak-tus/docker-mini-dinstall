#!/usr/bin/env sh

userdel user 2>/dev/null
groupdel user 2>/dev/null
groupadd -g $USER_GID user
useradd -d /home/user -g user -u $USER_UID user

mkdir -p "$OUT_PATH"
mkdir -p "$IN_PATH"

chown -R user:user "$OUT_PATH"
chown -R user:user "$IN_PATH"

ln -sf /dev/stdout "$OUT_PATH/mini-dinstall.log"
chown user:user "$OUT_PATH/mini-dinstall.log"

rm "$OUT_PATH/unstable.db"

/usr/local/bin/consul-template -config /root/templates/service.hcl &
child=$!

trap "kill -s INT $child" INT TERM
wait "$child"
trap - INT TERM
wait "$child"
