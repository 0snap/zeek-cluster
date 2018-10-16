FROM debian:stretch as install

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


# "production" image will hold supervisor -> bro and ssh
FROM debian:stretch

RUN apt-get update && apt-get -y install \
    libpcap0.8 \
    libssl1.0.2 \
    libmaxminddb0 \
    python2.7-minimal \
    librocksdb4.5 \
    libjemalloc1 \
    curl \
    openssh-server \
    supervisor \
    rsync \
    net-tools \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=install /usr/local/bro /usr/local/bro
RUN ln -s /usr/local/bro /bro
COPY --from=install /usr/share/GeoIP /usr/share/GeoIP/

ENV PATH=/bro/bin:$PATH
ENV BROPATH=.:/usr/local/bro/share/bro:/usr/local/bro/share/bro/policy:/usr/local/bro/share/bro/site

RUN echo bronode > /etc/hostname

# ssh keys + config
COPY ssh/id_rsa.pub /root/.ssh/authorized_keys2
COPY ssh/id_rsa /root/.ssh/id_rsa
COPY ssh/config /root/.ssh/config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir /run/sshd && \
    sed "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config  > /etc/ssh/sshd_config && \
    chmod 0600 /root/.ssh/config && \
    chmod 0600 /root/.ssh/id_rsa

# broker listen on port 9999
EXPOSE 9999

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]