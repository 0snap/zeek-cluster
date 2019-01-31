FROM debian:stretch

RUN apt-get update && apt-get install -y \
    bison \
    build-essential \
    ca-certificates \
    cmake \
    flex \
    gawk \
    git \
    libcurl4-openssl-dev \
    libgeoip-dev \
    libjemalloc-dev \
    libmaxminddb-dev \
    libncurses5-dev \
    libpcap-dev \
    librocksdb-dev \
    libssl1.0-dev \
    python3-dev \
    python3-pip \
    swig \
    wget \
    zlib1g-dev \
    --no-install-recommends

# get latest zeek from source
WORKDIR /opt
RUN git clone --recursive https://github.com/zeek/zeek /opt/zeek-git
WORKDIR /opt/zeek-git

RUN ./configure --with-jemalloc=/usr/lib/x86_64-linux-gnu
RUN make -j4 install

WORKDIR /usr/share/GeoIP
RUN wget -N http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
RUN wget -N http://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz
RUN tar xvzf GeoLite2-City.tar.gz
RUN tar xvzf GeoLite2-ASN.tar.gz
RUN rm GeoLite2-City.tar.gz
RUN rm GeoLite2-ASN.tar.gz

ENV PATH=/usr/local/bro/bin:$PATH

VOLUME /usr/local/bro/logs

RUN pip3 install setuptools wheel

RUN pip3 install bro-pkg && \
    bro-pkg autoconfig

COPY zeek-pkg.conf /root/.bro-pkg/config
COPY zeek-pkg.conf /usr/local/bro/bro-pkg/config

EXPOSE 9999

WORKDIR /opt/zeek
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]