FROM fixel/bro-ssh-node

EXPOSE 9999

COPY config/node.cfg /bro/etc/node.cfg
COPY config/networks.cfg /bro/etc/networks.cfg
COPY config/init_cluster_broctl.sh /bro/bin/init_cluster_broctl.sh
RUN chmod a+x /bro/bin/init_cluster_broctl.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
