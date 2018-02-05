FROM centos:7

MAINTAINER Jonas Nordell <jonas@redhat.com>

ENV FLB_VERSION 0.12.12

ENV FLB_TARBALL http://github.com/fluent/fluent-bit/archive/v$FLB_VERSION.zip

RUN mkdir -p /fluent-bit/bin /fluent-bit/etc /fluent-bit/log

RUN yum -y update && \
    yum install -y curl ca-certificates gcc gcc-c++ cmake make bash wget unzip systemd-devel && \
    cd /tmp && \
    wget -O "/tmp/fluent-bit-${FLB_VERSION}.zip" ${FLB_TARBALL} && \
    unzip "fluent-bit-$FLB_VERSION.zip" && \
    cd "/tmp/fluent-bit-${FLB_VERSION}/build" && \
    cmake -DFLB_DEBUG=On -DFLB_TRACE=On \
          -DCMAKE_INSTALL_PREFIX=/fluent-bit/ -DFLB_BUFFERING=On -DFLB_SQLDB=On ../&& \
    make && \
    make install && \
    rm -rf /tmp/* /fluent-bit/include /fluent-bit/lib*

COPY conf/fluent-bit.conf /fluent-bit/etc/
COPY conf/parsers.conf /fluent-bit/etc/

CMD ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf"]

