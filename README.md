# Docker Zeek IDS cluster

[Zeek IDS](https://www.zeek.org/index.html) can be used in a worker cluster setup. Mutliple slave nodes share the workload of traffic analysis and report to a logger node. The cluster is managed in a centralized fashion by a dedicated manager node.

[Official Zeek IDS cluster documentation](https://docs.zeek.org/en/stable/cluster/index.html)

This repo provides a docker wrapper around Zeek that allows for a containerized Zeek IDS cluster.

The base image is a raw Zeek IDS installation with `python3`, `librocksdb` for broker support and geo data available inside the container: [fixel/zeek](https://cloud.docker.com/repository/docker/fixel/zeek) 

## Internals and setup

Zeek uses ssh to manage the nodes. The manager node needs to ssh into all slave nodes it wants to manage. Therefore:

- all slaves have to run `sshd`
- ssh has to be possible with PKI only
- key distribution ?

#### Security disclaimer

I intend to use this setup on an offline demo environment. I do not have to be concerned about access violations whatsoever. Thus it is ok for me to have fixed ssh keys and that is why I put them on github.

*If you want to reuse parts of this project make sure to change the keys and how they are stored + distributed.*

## Docker

Images ship with `supervisord` (nodaemon). It wraps the `sshd` and `bro` processes. Images build against latest Zeek master.

Pre-built images for `x86_64` can be found on [dockerhub](https://cloud.docker.com/u/fixel/repository/docker/fixel/zeek-cluster)

#### ARM 64v8

I plan on rebuilding and providing images for 64bit ARM again. The dockerfiles inherit from the debian `arm64v8` base image. I need to get the appropiate hardware back first. The images will be uploaded the next weeks.

### Network

See the [docker-compose.yml](docker-compose.yml) and [manager/config/node.cfg](manager/config/node.cfg) file. All nodes in the Zeek cluster must be resolvable for the manager (IP or hostname).

## Usage

Run a minimalistic local cluster of `2 workers`, `1 proxy`  and `1 master` (without dedicated `logger`) with `docker-compose`

    $ docker-compose up             # start the whole thing. daemonize with -d
    $ docker-compose down           # (in same directory) tear down cluster, throw away containers

Toy around with it, for example `docker inspect zeek-cluster_worker1_1`, find the IP and request some port there (locally!). When you now exec into the `manager` container you should see your request to the worker in the manager logs (`current/conn.log`)

### Custom Scripts

[Zeek can be scripted](https://docs.zeek.org/en/stable/examples/scripting/index.html). Per default, it will load the script at `$ZEEK_HOME/share/bro/site/local.bro`. See also the [broctl#bro-scripts](https://github.com/zeek/broctl#bro-scripts) documentation.

To add custom scripts just mount a volume into the manager container. See the [docker-compose.yml](docker-compose.yml) for an example. The manager will populate the scripts to all workers.