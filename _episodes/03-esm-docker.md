---
layout: episode
title: "NorESM/CESM docker"
---


# Docker containers

Containers for running ESM related tools.

## Approach

1. Create a conda recipe for your tool. We usually add it either in [conda-forge](https://conda-forge.org/) or [bioconda](https://bioconda.github.io/).
2. When using bioconda, you will get a Docker container out-of-the-box which you can use as a starting point for running a specific configuration
3. Publish your docker. We use [dockerhub](https://hub.docker.com/) and [quay.io](https://quay.io).

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)


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

