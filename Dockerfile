FROM 0x01be/alpine:edge as builder

RUN apk --no-cache add --virtual openocd-build-dependencies \
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

FROM 0x01be/alpine:edge

RUN apk --no-cache add --virtual openocd-runtime-dependencies \
    libusb \
    libftdi1

COPY --from=builder /opt/openocd/ /opt/openocd/

ENV PATH $PATH:/opt/openocd/bin/

