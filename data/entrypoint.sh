#!/bin/bash
set -e

WORKDIR=/develop/go/src/work
PROTOFILE=$WORKDIR/$1
SERVICENAME=$2
OPTSFILE=/proto/$3

if [ -z "${1}" ]; then
    echo "Please specify proto filename as first argument"
    exit
fi

if [ -z "${2}" ]; then
    echo "Please specify Service name (e.g. 'YourService') as second argument"
    exit
fi

mkdir $WORKDIR
cp /proto/$1 $WORKDIR

cd $WORKDIR
echo "Generating stub"
protoc -I/usr/local/include -I. -I$GOPATH/src -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis --go_out=plugins=grpc:. $PROTOFILE

echo "Generating proxy" 
protoc -I/usr/local/include -I. -I$GOPATH/src -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis --grpc-gateway_out=logtostderr=true:. $PROTOFILE

echo "Packaging"
cd $WORKDIR/work
echo "--> Getting dependencies"
go get .
echo "--> Preparing files"
sed -i -E 's/package ([a-zA-Z0-9_]+)/package main/g' *.go
cp /wrap/*.go .

sed -i -E 's/changeMe/Register'$SERVICENAME'HandlerFromEndpoint/' opts.go 

if [ -n "${3}" ]; then
    echo "--> Detected custom options file"
    rm opts.go 
    cp $OPTSFILE .
fi

echo "Building plugin"
echo "--> Compiling"
go build --buildmode=plugin -o=plugin.so
cp plugin.so /proto/plugin.so

echo "Done, the file plugin.so can now be used in a Tyk plugin bundle"
