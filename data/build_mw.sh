#!/bin/bash
set -e

ln -s /tyk/vendor /go/src 
mkdir -p /go/src/github.com/TykTechnologies
ln -s /tyk /go/src/github.com/TykTechnologies/tyk

NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
WORKDIR=/go/src/tykmw-$NEW_UUID

mkdir $WORKDIR
cp /proto/*.* $WORKDIR

cd $WORKDIR

echo "Building plugin"
echo "--> Compiling"
go build --buildmode=plugin -o=mw.so
cp mw.so /proto/mw.so
rm -rf $WORKDIR

echo "Done, the file mw.so can now be used in a Tyk plugin bundle"
