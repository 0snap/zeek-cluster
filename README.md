# Docker Bro IDS cluster

[Bro IDS](https://www.bro.org/index.html) can be used in a worker cluster setup. Mutliple slave nodes share the workload of traffic analysis and report to a logger node. The cluster is managed in a centralized fashion by a dedicated manager node.

[Official Bro IDS cluster documentation](https://www.bro.org/sphinx/cluster/index.html)

## Internals and setup

Bro uses ssh to manage the nodes. The manager node needs to ssh into all slave nodes it wants to manage. Therefore:

- all slaves have to run `sshd`
- ssh has to be possible with PKI only
- key distribution ?

#### Security disclaimer

I intend to use this setup on an offline demo environment. I do not have to be concerned about access violations whatsoever. Thus it is ok for me to have fixed ssh keys and that is why I put them on github.

*If you want to reuse parts of this project make sure to change the keys and how they are stored + distributed.*

## Docker

Images ship with `supervisord` (nodaemon). It wraps the `sshd` and `bro` processes. Images build against latest bro master.

### Network

See the [docker-compose.yml](docker-compose.yml) and [manager/config/node.cfg](manager/config/node.cfg) file. All nodes in the bro cluster must be resolvable for the manager (IP or hostname). 