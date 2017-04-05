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
sleep 5
child1=$( cat /alloc/data/deb/mini-dinstall/mini-dinstall.lock )

gosu user /bin/check &
child2=$!

trap "kill $child1 ; kill $child2" TERM INT

while true; do
  kill -0 "$child1"
  if [ "$?" = "0" ]; then
    sleep 5
  else
    echo "Exited mini-dinstall"
    exit
  fi

  kill -0 "$child2"
  if [ "$?" = "0" ]; then
    sleep 5
  else
    echo "Exited check"
    exit
  fi
done
