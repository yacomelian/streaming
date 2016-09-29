# Dockerizing nginx-RTMP: Dockerfile for building nginx-RTMP images
# Based on ubuntu:latest, installs nginx-RTMP

# Format: FROM    repository[:version]
FROM       ubuntu:16.04
FROM       jrottenberg/ffmpeg:latest

# Format: MAINTAINER Name <email@addr.ess>
MAINTAINER YacoMelian <@> github.com

ENTRYPOINT ["/bin/sh", "-c", "/postInstall.sh"]

WORKDIR /tmp/workdir

# VARIABLES
# ENV NGINX_VERSION=nginx-1.9.2
#ENV NGINX_VERSION=nginx-1.11.3
ENV NGINX_VERSION=nginx-1.11.4 \
    DEBIAN_FRONTEND=noninteractive
#ENV DEBIAN_FRONTEND=noninteractive \
#            NGINX_VERSION=nginx-1.11.4 \
#	    FFMPEG_VERSION=3.1.3 \
#            FAAC_VERSION=1.28    \
#            FDKAAC_VERSION=0.1.4 \
#            LAME_VERSION=3.99.5  \
#            OGG_VERSION=1.3.2    \
#            OPUS_VERSION=1.1.1   \
#            THEORA_VERSION=1.1.1 \
#            YASM_VERSION=1.3.0   \
#            VORBIS_VERSION=1.3.5 \
#            VPX_VERSION=1.6.0    \
#            XVID_VERSION=1.3.4   \
#            X265_VERSION=2.0     \
#	    X264_VERSION=20160826-2245-stable \
#	    SRC=/usr/local


# Installation:
  
RUN apt-get -yqq update;
RUN apt-get install -yqq apt-utils;
#\
RUN apt-get install -yqq wget unzip

RUN buildDeps="build-essential \
               libpcre3 \
               libpcre3-dev \
               libssl-dev" && \
        apt-get install -yq --no-install-recommends ${buildDeps} ca-certificates && \
        DIR=$(mktemp -d) && cd ${DIR}

# Install nginx with RTMP
RUN mkdir /tmp/working && cd /tmp/working;\
        wget http://nginx.org/download/${NGINX_VERSION}.tar.gz;\
        wget https://github.com/arut/nginx-rtmp-module/archive/master.zip;\
        tar -zxvf ${NGINX_VERSION}.tar.gz;\
        unzip master.zip;\
        cd ${NGINX_VERSION};\
        ./configure --with-http_ssl_module --with-http_v2_module --add-module=../nginx-rtmp-module-master;\
        make install clean

RUN rm -r /tmp/working
RUN apt-get -y purge ${buildDeps}

# Install Let's Encrypt
RUN apt-get -yqq install git bc;
RUN git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt;

# ADD nginx_sites-available_default /etc/nginx/sites-available/default

RUN openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# Install daemon
RUN wget https://raw.github.com/JasonGiedymin/nginx-init-ubuntu/master/nginx -O /etc/init.d/nginx;\
        chmod +x /etc/init.d/nginx;\
        update-rc.d nginx defaults

# Install additional decoder
#RUN apt-get install -y ffmpeg;

#nginx config
ADD nginx.conf /usr/local/nginx/conf/nginx.conf.new
RUN rm /usr/local/nginx/conf/mime.types
ADD mime.types /usr/local/nginx/conf/mime.types

RUN mkdir -p /var/log/nginx/
RUN ln -s /usr/local/nginx/html /var/www
RUN mkdir -p /var/www/HLS/
ADD stat.xsl /var/www/HLS/stat.xsl
ADD html/* /var/www/

RUN mkdir /streams
RUN chmod 0777 /streams

ADD postInstall.sh /postInstall.sh
RUN chmod +x /postInstall.sh

# expose HTTP
EXPOSE 80
EXPOSE 443
EXPOSE 1935

# run as daemon

# CMD /opt/letsencrypt/letsencrypt-auto certonly --agree-tos --text --non-interactive --register-unsafely-without-email -a webroot --webroot-path=/var/www/ -d stream.demokratielive.org; service nginx start
# CMD /opt/letsencrypt/letsencrypt-auto renew; service nginx start
CMD /postInstall.sh

## run interactive
# CMD service nginx start & /bin/bash
# CMD /bin/bash



# Clean // TODO: NOT WORKING
RUN apt-get -yqq purge ${buildDeps}
RUN apt-get -yqq purge wget unzip
RUN apt-get -yqq clean && apt-get -yqq autoclean

# RUN apt-get -y purge wget unzip build-essential libpcre3 libpcre3-dev libssl-dev software-properties-common
