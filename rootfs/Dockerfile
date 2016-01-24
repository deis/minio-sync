FROM alpine:3.3
#

# Download and install glibc
RUN apk add --update curl && \
  curl -o glibc-2.21-r2.apk "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/8/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" && \
  apk add --allow-untrusted glibc-2.21-r2.apk && \
  curl -o glibc-bin-2.21-r2.apk "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/8/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" && \
  apk add --allow-untrusted glibc-bin-2.21-r2.apk && \
  /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  rm -f glibc-2.21-r2.apk glibc-bin-2.21-r2.apk && \
  rm -rf /var/cache/apk/*

# Download and install btsync and all required components
RUN apk add --update tar && \
    curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64" && \
    chmod +x /usr/bin/gosu && \
    curl -s -k -L "https://download-cdn.getsyncapp.com/stable/linux-x64/BitTorrent-Sync_x64.tar.gz" | tar -xzf - -C /usr/bin && \
    chmod +x /usr/bin/btsync && \
    mkdir -p /opt/btsync && \
    apk del tar && \
    rm -rf /var/cache/apk/*

COPY . /

# must match minio user's IDs
ENV USERID 1000
ENV GROUPID 1000

EXPOSE 55555 55555/udp 8888

CMD ["/bin/boot.sh"]
