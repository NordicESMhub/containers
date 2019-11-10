# Docker containers

Containers for running ESM related tools.

## Approach

1. Create a conda recipe for your tool. We usually add it either in [conda-forge](https://conda-forge.org/) or [bioconda](https://bioconda.github.io/).
2. When using bioconda, you will get a Docker container out-of-the-box which you can use as a starting point for running a specific configuration
3. Publish your docker. We use [dockerhub](https://hub.docker.com/).

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Installation of docker on centos 7

To test and run our docker containers, we use [IaaS](http://docs.uh-iaas.no/en/latest/) and create a virtual machine with centos-7. Then we install docker using the following instructions:

```
sudo yum check-update


curl -fsSL https://get.docker.com/ | sh

sudo usermod -aG docker centos

sudo systemctl start docker
```

## Check status

```
sudo systemctl status docker
```

## Enable docker 

It allows to start docker automatically when the machine is rebooted

```
sudo systemctl enable docker
```

## Change default location

The default disk on our Virtual Machine is about 20GB e.g. too small for our docker images so we create a new volume `/opt/uio/` (500GB).

First [create a new volume](http://docs.uh-iaas.no/en/latest/manage-volumes.html#create-a-volume) and [attach it to your Virtual Machine](http://docs.uh-iaas.no/en/latest/manage-volumes.html#attach-a-volume-to-a-virtual-machine).

Then change default folder to `/opt/uio/docker` (make sure to create this folder):

```
sudo systemctl stop docker
sudo mkdir /etc/systemd/system/docker.service.d
sudo touch /etc/systemd/system/docker.service.d/docker.conf 
```

Then edit (with sudo) `/etc/systemd/system/docker.service.d/docker.conf` and add:

```
[Service]
ExecStart=/usr/bin/dockerd --graph="/opt/uio/docker" --storage-driver=devicemapper
```

Finally restart docker:

```
sudo systemctl daemon-reload
sudo systemctl start docker
```
## Test your installation

Logout and login again (to make sure `centos` username is part of docker group).

```
docker ps
```
This command should return:

```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
0
```

# How to get inputdata

You will need `wget` to download the corresponding inputdata for each each you will be running.

```
sudo yum install wget -y
```

# Docker for Community Earth System Models (CESM) 

[Community Earth System Model (CESM)](http://www.cesm.ucar.edu/models/) supports several configurations. We provide examples on how to run CESM with docker containers. Several compset and resolutions have been tested and input data stored in [zenodo](https://zenodo.org/) to facilitate the usage and deployment of these docker containers.

## Tested

- [FKESSLER](https://github.com/NordicESMhub/fkessler_docker)
- [F1850](https://github.com/NordicESMhub/F1850_docker)
- [CESM historic with CAM6 and CLM5 (no ocean)](https://github.com/NordicESMhub/hc6l5_docker)
- [VR-CESM historic with CAM6 and CLM5 (no ocean) and variable resolution](https://github.com/NordicESMhub/VR-CESM_docker)

## Work In Progress

- [B1850](https://github.com/NordicESMhub/B1850_docker)
