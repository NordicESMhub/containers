---
layout: episode
title: "NorESM/CESM Containers on Norwegian HPCs"
---

In this section, we detail results and performance we get when running CESM/NorESM with and without containers (sarus/singularity) on Norwegian HPCs ([Fram](https://www.sigma2.no/Fram), [Saga](https://documentation.sigma2.no/quick/saga.html) and [abel](https://www.uio.no/english/services/it/research/hpc/abel/)).


## Running containers on Saga with udocker

### Installation of udocker

The main advantage of using [udocker](https://github.com/indigo-dc/udocker) is that it does not require *root* access for installation and usage.

```
mkdir $HOME/udocker

curl https://raw.githubusercontent.com/indigo-dc/udocker/master/udocker.py > udocker
chmod u+rx ./udocker
./udocker install
```

Then you can add `udocker` command in your `PATH`:

```
export PATH=$PATH:$HOME/udocker
```

### Test your installation

#### Pull an existing image

Here we get `busybox` image from dockerhub:

```
udocker pull busybox
```

Then we create a new container from this image:

```
udocker create --name=verybusy busybox
```

Finally run the container:

```
udocker run verybusy
```

#### Clean container

```
# Get container id to remove
udocker ps
udocker rm f74899cf-bc2e-39f4-8e3f-cb35bcf48a52
```

#### Clean image

```
udocker images
udocker rmi busybox:latest
```

### norESM with udocker

```
udocker pull quay.io/nordicesmhub/cesm_libs:latest
udocker create --name=cesm_libs quay.io/nordicesmhub/cesm:latest
```

To run the container:

```
udocker run --volume=/cluster/work/users/annefou/inputdat50_noresm:/root/inputdata \
            --volume=/cluster/work/users/annefou/archive:/root/archive \
	    --volume=/cluster/home/annefou/F1850_docker/config_files:/root/config_files \
	    cesm_libs bash
```

Once in your container:

#### Prepare configuration files

```
cp -R $HOME/config_files $HOME/.cime

# Set number of  MPI processors per node
export CESM_PES=16
sed -i -e "s/\$CESM_PES/$CESM_PES/g" $HOME/.cime/config_machines.xml
```

**Note**: you can always edit `$HOME/.cime/config_machines.xml` to change the number of processors per node.

#### Running norESM 

In this example we will be running a simple norESM case (CAM only):

- Get norESM (you need to have access to this private repository

```
git clone -b featureCESM2.1.0-OsloDevelopment https://github.com/metno/noresm-dev.git
cd noresm-dev/
```


- Create your case

```
./create_newcase --case $HOME/cases/cN1850 --compset       1850_CAM60%NORESM_CLM50%SP_CICE%PRES_DOCN%DOM_MOSART_SGLC_SWAV       --res f19_tn14 --machine espresso --run-unsupported
```

- Customize your case 

```
cd /root/cases/cN1850
NUMNODES=-1
./xmlchange --file env_mach_pes.xml --id NTASKS --val ${NUMNODES}
./xmlchange --file env_mach_pes.xml --id NTASKS_ESP --val 1
./xmlchange --file env_mach_pes.xml --id ROOTPE --val 0
./xmlchange STOP_N=1
./case.setup
cat >> user_nl_cam << EOF
nhtfrq(1) = -24
EOF
./case.build
./case.submit
```

You can exit your container whenever you want and go back to it with the same `udocker run` command.

For instance to continue your run:

```
udocker run --volume=/cluster/work/users/annefou/inputdat50_noresm:/root/inputdata \
            --volume=/cluster/work/users/annefou/archive:/root/archive \
	    --volume=/cluster/home/annefou/F1850_docker/config_files:/root/config_files \
	    cesm_libs bash
```

And then in your container:

```
cd /root/cases/cN1850
./xmlchange CONTINUE_RUN=TRUE
./case.submit
```

Then do not forget to clean once you are done with your simulation.

#### Using slurm with udocker

