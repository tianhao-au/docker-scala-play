FROM anapsix/alpine-java:jdk8
MAINTAINER Tianhao Li <ysihaoy@gmail.com>

ENV SBT_VERSION 0.13.16
ENV CHECKSUM e94d95ff2d64247b754782ea85e99187ea890dc4c918a7ba7dcb6091fdb5968c

# Install sbt
RUN apk add --update bash curl openssl ca-certificates && \
  curl -L -o /tmp/sbt.zip \
    https://cocl.us/sbt-${SBT_VERSION}.zip && \
  openssl dgst -sha256 /tmp/sbt.zip \
    | grep ${CHECKSUM} \
    || (echo 'shasum mismatch' && false) && \
  mkdir -p /opt/sbt && \
  unzip /tmp/sbt.zip -d /opt/sbt && \
  rm /tmp/sbt.zip && \
  chmod +x /opt/sbt/sbt/bin/sbt && \
  ln -s /opt/sbt/sbt/bin/sbt /usr/bin/sbt && \
  rm -rf /tmp/* /var/cache/apk/*

# Prebuild with sbt
COPY . /tmp/build/

# sbt sometimes failed because of network. retry 3 times.
RUN cd /tmp/build && \
  (sbt compile || sbt compile || sbt compile) && \
  (sbt test:compile || sbt test:compile || sbt test:compile) && \
  rm -rf /tmp/build

CMD ["sbt"]
