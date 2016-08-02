FROM anapsix/alpine-java:jdk8

# Install activator
ENV ACTIVATOR_VERSION 1.3.10
RUN apk add --update bash curl openssl ca-certificates && \
  curl -L -o /tmp/activator.zip \
    https://downloads.typesafe.com/typesafe-activator/$ACTIVATOR_VERSION/typesafe-activator-$ACTIVATOR_VERSION-minimal.zip && \
  openssl dgst -sha256 /tmp/activator.zip \
    | grep '15352ce253aa804f707ef8be86390ee1ee91da4b78dbb2729ab1e9cae01d8937' \
    || (echo 'shasum mismatch' && false) && \
  mkdir -p /opt/activator && \
  unzip /tmp/activator.zip -d /opt/activator && \
  rm /tmp/activator.zip && \
  chmod +x /opt/activator/activator-$ACTIVATOR_VERSION-minimal/bin/activator && \
  ln -s /opt/activator/activator-$ACTIVATOR_VERSION-minimal/bin/activator /usr/bin/activator && \
  rm -rf /tmp/* /var/cache/apk/*

# Prebuild with activator
COPY . /tmp/build/

# activator sometimes failed because of network. retry 3 times.
RUN cd /tmp/build && \
  (activator compile || activator compile || activator compile) && \
  (activator test:compile || activator test:compile || activator test:compile) && \
  rm -rf /tmp/build
