#!/bin/bash


#docker stop $(docker ps -a -q)
#docker rm $(docker ps -a -q)

docker build -t streaming .
docker run --restart=always -d -p 1935:1935 -p 80:80 -p 443:443 streaming
