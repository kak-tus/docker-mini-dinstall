#!/usr/bin/env sh

rm -rf /home/user/.gnupg
gosu user gpg --import /etc/private_key.gpg
key=$(gosu user gpg --list-secret-keys --with-colon | fgrep sec | awk -F : '{print $5}')

cp /etc/public_key "$OUT_PATH/unstable/public_key"
chown user "$OUT_PATH/unstable/public_key"

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
