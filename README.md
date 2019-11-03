# Docker containers

Containers for running ESM related tools.

## Approach

1. Create a conda recipe for your tool. We usually add it either in [conda-forge](https://conda-forge.org/) or [bioconda](https://bioconda.github.io/).
2. When using bioconda, you will get a Docker container out-of-the-box which you can use to as a starting point for running a specific configuration
3. Publish your docker. We use [dockerhub](https://hub.docker.com/).

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)


## Tested

- [FKESSLER](https://github.com/NordicESMhub/fkessler_docker)
- [F1850](https://github.com/NordicESMhub/F1850_docker)

## Work In Progress

- [B1850](https://github.com/NordicESMhub/B1850_docker)
- [VR-CESM](https://github.com/NordicESMhub/VR-CESM_docker)
- [CESM historic with CAM6 and CLM5 (no ocean)](https://github.com/NordicESMhub/hc6l5_docker)

