FROM fixel/bro-cluster:arm64v8-base as install

# "production" image will hold supervisor -> bro and ssh
FROM debian:stretch

RUN apt-get update && apt-get -y install \
    curl \
    git \
    libjemalloc1 \
    libmaxminddb0 \
    libpcap0.8 \
    librocksdb4.5 \
    libssl1.0.2 \
    net-tools \
    openssh-server \
    python2.7-minimal \
    rsync \
    supervisor \
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
