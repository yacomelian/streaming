#!/bin/bash


#docker stop $(docker ps -a -q)
#docker rm $(docker ps -a -q)
#VERSION=$(date +%Y%m%d%H%M%S)
VERSION=$(date +%Y%m%d%H%M)

docker build -t ymelian/streaming:$VERSION -t ymelian/streaming:latest .
#docker run --restart=always -d -p 1935:1935 -p 80:80 -p 443:443 ymelian/streaming
