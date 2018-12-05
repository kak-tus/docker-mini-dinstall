#!/usr/bin/env sh

gosu user mini-dinstall -c /etc/mini-dinstall
sleep 5
child1=$( cat "$OUT_PATH/mini-dinstall/mini-dinstall.lock" )

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
