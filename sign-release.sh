#!/bin/bash

set -e

PASSPHRASE=$(cat "/etc/passphrase")

gpg --help 1>/dev/null 2>&1 || true

rm -f Release.gpg.tmp InRelease.tmp
echo "$PASSPHRASE" | gpg --no-tty --batch --passphrase-fd=0 -abs -o Release.gpg.tmp "$1"
mv Release.gpg.tmp Release.gpg
echo "$PASSPHRASE" | gpg --no-tty --batch --passphrase-fd=0 --clearsign --digest-algo SHA512 -o InRelease.tmp "$1"
mv InRelease.tmp InRelease
