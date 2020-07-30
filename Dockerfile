FROM alpine:3.12.0 as builder

RUN apk --no-cache add --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    git \
    build-base \
    libusb-dev \
    libftdi1-dev \
    automake \
    autoconf \
    libtool

RUN git clone --depth 1 git://git.code.sf.net/p/openocd/code /openocd

WORKDIR /openocd

RUN ./bootstrap
RUN ./configure --prefix=/opt/openocd
RUN make
RUN make install

FROM alpine:3.12.0

RUN apk --no-cache add --virtual runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \      
    libusb \
    libftdi1

COPY --from=builder /opt/openocd/ /opt/openocd/

ENV PATH $PATH:/opt/openocd/bin/

