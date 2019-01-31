FROM fixel/zeek-cluster:zeek-ssh-node

COPY config/node.cfg /zeek/etc/node.cfg
COPY config/networks.cfg /zeek/etc/networks.cfg
COPY config/init_cluster_broctl.sh /zeek/etc/cluster_config/start-command.sh
RUN chmod a+x /zeek/etc/cluster_config/start-command.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
