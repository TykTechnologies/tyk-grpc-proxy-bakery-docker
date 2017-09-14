#!/bin/bash
set -e

if [ $1 == "mw" ]
    then
        echo "Executing middleware plugin build"
        exit
fi

if [ $1 == "grpc" ]
    then
        echo "Executing grpc proxy plugin build"
        echo $2 $3
        ./build_grpc.sh $2 $3
        exit
fi