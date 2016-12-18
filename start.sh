#!/usr/bin/env sh

userdel user 2>/dev/null
groupdel user 2>/dev/null
groupadd -g $USER_GID user
useradd -d /home/user -g user -u $USER_UID user

mkdir -p /alloc/data/deb
mkdir -p /alloc/data/essi

chown -R user:user /alloc/data/deb
chown -R user:user /alloc/data/essi

gosu user mini-dinstall -c /etc/mini-dinstall

gosu user /bin/check >/proc/1/fd/1 2>/proc/1/fd/2 &
child=$!

trap "gosu user mini-dinstall -c /etc/mini-dinstall -k ; kill $child" TERM
wait "$child"
