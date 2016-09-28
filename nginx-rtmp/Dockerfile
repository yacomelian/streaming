# Dockerizing nginx-RTMP: Dockerfile for building nginx-RTMP images
# Based on ubuntu:latest, installs nginx-RTMP

# Format: FROM    repository[:version]
FROM       ubuntu:latest
#FROM       jrottenberg/ffmpeg:latest

# Format: MAINTAINER Name <email@addr.ess>
MAINTAINER Ymelian <@>

# VARIABLES
# ENV nginxVersion nginx-1.9.2
#ENV nginxVersion nginx-1.11.3
ENV nginxVersion nginx-1.11.4 \
	    FFMPEG_VERSION=3.1.3 \
            FAAC_VERSION=1.28    \
            FDKAAC_VERSION=0.1.4 \
            LAME_VERSION=3.99.5  \
            OGG_VERSION=1.3.2    \
            OPUS_VERSION=1.1.1   \
            THEORA_VERSION=1.1.1 \
            YASM_VERSION=1.3.0   \
            VORBIS_VERSION=1.3.5 \
            VPX_VERSION=1.6.0    \
            XVID_VERSION=1.3.4   \
            X265_VERSION=2.0     \
	    X264_VERSION=20160826-2245-stable \
	    SRC=/usr/local


# Installation:
RUN apt-get update;\
        apt-get -y install wget;\
        apt-get -y install unzip;\
        apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev

# Install nginx with RTMP
RUN mkdir /tmp/working && cd /tmp/working;\
        wget http://nginx.org/download/${nginxVersion}.tar.gz;\
        wget https://github.com/arut/nginx-rtmp-module/archive/master.zip;\
        tar -zxvf ${nginxVersion}.tar.gz;\
        unzip master.zip;\
        cd ${nginxVersion};\
        ./configure --with-http_ssl_module --with-http_v2_module --add-module=../nginx-rtmp-module-master;\
        make install clean

RUN rm -r /tmp/working

# Install Let's Encrypt
RUN apt-get -y install git bc;
RUN git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt;

# ADD nginx_sites-available_default /etc/nginx/sites-available/default

RUN openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# Install daemon
RUN wget https://raw.github.com/JasonGiedymin/nginx-init-ubuntu/master/nginx -O /etc/init.d/nginx;\
        chmod +x /etc/init.d/nginx;\
        update-rc.d nginx defaults

# Install additional decoder
#RUN apt-get install -y ffmpeg;
RUN      buildDeps="autoconf \
                    automake \
                    cmake \
                    curl \
                    bzip2 \
                    g++ \
                    gcc \
                    git \
                    libtool \
                    make \
                    nasm \
                    perl \
                    pkg-config \
                    python \
                    libssl-dev \
                    zlib1g-dev" && \
        export MAKEFLAGS="-j$(($(nproc) + 1))" && \
        apt-get -yqq update && \
        apt-get install -yq --no-install-recommends ${buildDeps} ca-certificates && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## yasm http://yasm.tortall.net/
        curl -sL https://github.com/yasm/yasm/archive/v${YASM_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./autogen.sh && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --docdir=${DIR} -mandir=${DIR}&& \
        make && \
        make install && \
        make distclean && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## x264 http://www.videolan.org/developers/x264.html TODO : pin version, at least we use the stable branch
        curl -s ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${X264_VERSION}.tar.bz2 | \
        tar -jx --strip-components=1 && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --enable-static && \
        make && \
        make install && \
        make distclean && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## x265 http://x265.org/
        curl -s https://download.videolan.org/pub/videolan/x265/x265_${X265_VERSION}.tar.gz  | \
        tar -zx && \
        cd x265_${X265_VERSION}/build/linux && \
        sh multilib.sh && \
        make -C 8bit install && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## libogg https://www.xiph.org/ogg/ 
        curl -sL http://downloads.xiph.org/releases/ogg/libogg-${OGG_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-shared --datadir=${DIR} && \
        make && \
        make install && \
        make distclean && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## libopus https://www.opus-codec.org/
        curl -sL http://downloads.xiph.org/releases/opus/opus-${OPUS_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        autoreconf -fiv && \
        ./configure --prefix="${SRC}" --disable-shared --datadir="${DIR}" && \
        make && \
        make install && \
        make distclean && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## libvorbis https://xiph.org/vorbis/
        curl -sL http://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" --with-ogg="${SRC}" --bindir="${SRC}/bin" \
        --disable-shared --datadir="${DIR}" && \
        make && \
        make install && \
        make distclean && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
#@ libtheora http://www.theora.org/
        curl -sL http://downloads.xiph.org/releases/theora/libtheora-${THEORA_VERSION}.tar.bz2 | \
        tar -jx --strip-components=1 && \
        ./configure --prefix="${SRC}" --with-ogg="${SRC}" --bindir="${SRC}/bin" \
        --disable-shared --datadir="${DIR}" && \
        make && \
        make install && \
        make distclean && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## libvpx https://www.webmproject.org/code/
        curl -sL https://codeload.github.com/webmproject/libvpx/tar.gz/v${VPX_VERSION} | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" --enable-vp8 --enable-vp9 --disable-examples --disable-docs && \
        make && \
        make install && \
        make clean && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## libmp3lame http://lame.sourceforge.net/
        curl -Ls https://downloads.sf.net/project/lame/lame/${LAME_VERSION%.*}/lame-${LAME_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-shared --enable-nasm --datadir="${DIR}" && \
        make && \
        make install && \
        make distclean&& \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## faac https://sourceforge.net/projects/faac/ +  http://stackoverflow.com/a/4320377
        curl -L https://downloads.sf.net/faac/faac-${FAAC_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        sed -i '126d' common/mp4v2/mpeg4ip.h && \
        ./bootstrap && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --datadir="${DIR}" && \
        make && \
        make install && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## xvid https://www.xvid.com/
        curl -sL http://downloads.xvid.org/downloads/xvidcore-${XVID_VERSION}.tar.gz | \
        tar -zx && \
        cd xvidcore/build/generic && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --datadir="${DIR}" && \
        make && \
        make install && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## fdk-aac https://github.com/mstorsjo/fdk-aac
        curl -sL https://github.com/mstorsjo/fdk-aac/archive/v${FDKAAC_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        autoreconf -fiv && \
        ./configure --prefix="${SRC}" --disable-shared --datadir="${DIR}" && \
        make && \
        make install && \
        make distclean && \
        rm -rf ${DIR} && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## ffmpeg https://ffmpeg.org/
        curl -sL http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" \
        --extra-cflags="-I${SRC}/include" \
        --extra-ldflags="-L${SRC}/lib" \
        --bindir="${SRC}/bin" \
        --disable-doc \
        --extra-libs=-ldl \
        --enable-version3 \
        --enable-libfaac \
        --enable-libfdk_aac \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-libtheora \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libx264 \
        --enable-libx265 \
        --enable-libxvid \
        --enable-gpl \
        --enable-avresample \
        --enable-postproc \
        --enable-nonfree \
        --disable-debug \
        --enable-small \
        --enable-openssl && \
        make && \
        make install && \
        make distclean && \
        hash -r && \
        cd tools && \
        make qt-faststart && \
        cp qt-faststart ${SRC}/bin && \
        rm -rf ${DIR} && \
	ffmpeg -buildconf


#nginx config
ADD nginx.conf /usr/local/nginx/conf/nginx.conf.new
RUN rm /usr/local/nginx/conf/mime.types
ADD mime.types /usr/local/nginx/conf/mime.types

RUN mkdir -p /var/log/nginx/
RUN ln -s /usr/local/nginx/html /var/www
RUN mkdir -p /var/www/HLS/
ADD stat.xsl /var/www/HLS/stat.xsl
ADD html/* /var/www/

# expose HTTP
EXPOSE 80
EXPOSE 443
EXPOSE 1935

# Pre-Install dependencies to run letsencrypt-auto
RUN apt-get install -y augeas-lenses dh-python dialog libaugeas0 libexpat1-dev libffi-dev libmpdec2 libpython-dev libpython-stdlib libpython2.7 libpython2.7-dev libpython2.7-minimal libpython2.7-stdlib libpython3-stdlib libpython3.5-minimal libpython3.5-stdlib mime-support python python-dev python-minimal python-pip-whl python-pkg-resources python-virtualenv python2.7 python2.7-dev python2.7-minimal python3 python3-minimal python3-pkg-resources python3-virtualenv python3.5 python3.5-minimal virtualenv

ADD postInstall.sh postInstall.sh
RUN chmod +x postInstall.sh
RUN mkdir /streams
RUN chmod 0777 /streams
## run as daemon

# CMD /opt/letsencrypt/letsencrypt-auto certonly --agree-tos --text --non-interactive --register-unsafely-without-email -a webroot --webroot-path=/var/www/ -d stream.demokratielive.org; service nginx start
# CMD /opt/letsencrypt/letsencrypt-auto renew; service nginx start
CMD ./postInstall.sh


## run interactive
# CMD service nginx start & /bin/bash
# CMD /bin/bash


 ## cleanup
RUN     cd && \
        echo "purge" && \
        apt-get purge -y ${buildDeps} && \
        apt-get autoremove -y && \
        apt-get clean -y && \
        rm -rf /var/lib/apt/lists 



# Clean // TODO: NOT WORKING
# RUN apt-get -y purge wget unzip build-essential libpcre3 libpcre3-dev libssl-dev software-properties-common
