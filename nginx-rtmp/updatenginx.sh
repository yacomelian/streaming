#!/bin/bash

docker cp ./nginx.conf d16f07be172e:/usr/local/nginx/conf/nginx.conf
docker exec d16f07be172e service nginx restart

