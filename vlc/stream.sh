cvlc "rtmp://10.1.1.167/media_server/salajuntasa" --sout '#transcode{vcodec=theo,vb=800,scale=Automático,acodec=vorb,ab=64}:standard{access=http,mux=ogg,dst=:8080/}' --sout-keep
