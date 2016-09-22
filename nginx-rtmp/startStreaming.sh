#!/bin/bash

docker pull streaming
docker run --restart=always -d -p 1935:1935 -p 80:80 -p 443:443 streaming
