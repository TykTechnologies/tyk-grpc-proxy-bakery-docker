#!/bin/bash
set -e

NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
WORKDIR=/go/src/$NEW_UUID
PROTOFILE=$WORKDIR/$1
SERVICENAME=$2
OPTSFILE=/proto/$3

mkdir $WORKDIR
cp /proto/$1 $WORKDIR

cd $WORKDIR

echo "Generating stub"
protoc -I/usr/local/include -I. -I$GOPATH/src -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis --go_out=plugins=grpc:. $PROTOFILE

echo "Generating proxy" 
protoc -I/usr/local/include -I. -I$GOPATH/src -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis --grpc-gateway_out=logtostderr=true:. $PROTOFILE

echo "Packaging"
cd $WORKDIR/$NEW_UUID
echo "--> Getting dependencies"
go get .
echo "--> Preparing files"
sed -i -E 's/package ([a-zA-Z0-9_]+)/package main/g' *.go
cp /wrap/*.go .

sed -i -E 's/entryPointFunction/Register'$SERVICENAME'HandlerFromEndpoint/' opts.go 

if [ -n "${3}" ]; then
    echo "--> Detected custom options file"
    rm opts.go 
    cp $OPTSFILE .
fi

echo "Building plugin"
echo "--> Compiling"
go build --buildmode=plugin -o=plugin.so
cp plugin.so /proto/plugin.so
rm -rf $WORKDIR

echo "Done, the file plugin.so can now be used in a Tyk plugin bundle"
