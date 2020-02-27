# Docker containers

Containers for running ESM related tools.

**Citation**: Containers for running NorESM and CESM, Anne Fouilloux and Jean Iaquinta, 2019, 
<a href="https://zenodo.org/badge/latestdoi/181903456"><img src="https://zenodo.org/badge/181903456.svg" alt="DOI"></a>

## Approach

1. Create a conda recipe for your tool. We usually add it either in [conda-forge](https://conda-forge.org/) or [bioconda](https://bioconda.github.io/).
2. When using bioconda, you will get a Docker container out-of-the-box which you can use as a starting point for running a specific configuration
3. Publish your docker. We use [dockerhub](https://hub.docker.com/) and [quay.io](https://quay.io).

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![DOI](https://zenodo.org/badge/181903456.svg)](https://zenodo.org/badge/latestdoi/181903456)

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
- [NorESM-CAM](https://github.com/NorESMhub/NorESMCAM_docker)
- [B1850 GNU compilers](https://github.com/NordicESMhub/B1850_docker)
- [B1850 intel compilers](https://github.com/NordicESMhub/B1850_docker_intel)
- [NorESM fully coupled N1850 compset and f19_tn14 resolution](https://github.com/NorESMhub/i16N1850_docker)

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

Then change default folder to `/opt/uio/docker`:

```
sudo mkdir /opt/uio/docker
```

You should have:

```
ls -lrt 

drwx--x--x. 14 root   root         4096 Nov  2 10:25 docker
```

And then change the default location to this new folder:

```
sudo systemctl stop docker
```

Then edit (with sudo) `sudo vi /etc/docker/daemon.json` and add:

```
{
  "data-root": "/opt/uio/docker"
}
```

Finally restart docker:

```
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

# A few docker commands

## Get info on docker service

```
docker info
```

It should return something like:

```
Client:
 Debug Mode: false

Server:
 Containers: 1
  Running: 1
  Paused: 0
  Stopped: 0
 Images: 21
 Server Version: 19.03.4
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: true
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: b34a5c8af56e510852c35414db4c1f4fa6172339
 runc version: 3e425f80a8c931f88e6d94a8c831b9d5aa481657
 init version: fec3683
 Security Options:
  seccomp
   Profile: default
 Kernel Version: 3.10.0-1062.4.1.el7.x86_64
 Operating System: CentOS Linux 7 (Core)
 OSType: linux
 Architecture: x86_64
 CPUs: 32
 Total Memory: 117.9GiB
 Name: hpc32.novalocal
 ID: XNRD:EARM:KHVU:ZH47:QS32:NBE2:FHYX:MGW7:GMLK:RNIK:KT36:2J4D
 Docker Root Dir: /opt/uio/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
 ```
## If you container exited abnormally

```
docker ps --filter "status=exited"
```

## Stop and remove your docker instance

Then stop and rm your container id:

```
docker stop <container_id>
```

and

```
docker rm <container_id>
```

## Remove your docker images

```
docker images
```

The command above allows you to get the image identifier. Now you can remove your image with the following command:

```
docker rmi <image_id>
```


