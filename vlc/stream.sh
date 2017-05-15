cvlc "rtmp://x.x.x.x/media_server/*********" --sout '#transcode{vcodec=theo,vb=800,scale=Automático,acodec=vorb,ab=64}:standard{access=http,mux=ogg,dst=:8080/}' --sout-keep
