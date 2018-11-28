FROM arm64v8/debian:stretch

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    bison \
    flex \
    gawk \
    cmake \
    swig \
    libssl1.0-dev \
    libgeoip-dev \
    libpcap-dev \
    python-dev \
    libcurl4-openssl-dev \
    wget \
    libncurses5-dev \
    ca-certificates \
    zlib1g-dev \
    librocksdb-dev \
    libjemalloc-dev \
    libmaxminddb-dev \
    python-pip \
    --no-install-recommends

# get latest bro from source
WORKDIR /opt
RUN git clone --recursive https://github.com/bro/bro /opt/bro-git
WORKDIR /opt/bro-git

RUN ./configure --with-jemalloc=/usr/lib/x86_64-linux-gnu
RUN make -j8 install

WORKDIR /usr/share/GeoIP
RUN wget -N http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
RUN wget -N http://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz
RUN tar xvzf GeoLite2-City.tar.gz
RUN tar xvzf GeoLite2-ASN.tar.gz
RUN rm GeoLite2-City.tar.gz
RUN rm GeoLite2-ASN.tar.gz

ENV PATH=/usr/local/bro/bin:$PATH

RUN pip install setuptools wheel

RUN pip install bro-pkg && \
    bro-pkg autoconfig

COPY bro-pkg.conf /root/.bro-pkg/config
COPY bro-pkg.conf /usr/local/bro/bro-pkg/config

EXPOSE 9999

CMD /bin/bash -l
