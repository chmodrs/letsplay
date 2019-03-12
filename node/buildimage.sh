#!/bin/bash

CORES=$(nproc)
DIR=/opt/letsplay/node/

docker build -t nodeapp:v1 -f $DIR/Dockerfile $DIR
