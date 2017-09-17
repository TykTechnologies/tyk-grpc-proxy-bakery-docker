#!/bin/bash
set -e

if [ $1 == "mw" ]
    then
        echo "Executing middleware plugin build"
        ./build_mw.sh $2 $3
        exit
fi

if [ $1 == "grpc" ]
    then
        echo "Executing grpc proxy plugin build"
        ./build_grpc.sh $2 $3
        exit
fi