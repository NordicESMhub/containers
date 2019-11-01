# Create a use case from generic docker container

1. We start from a base docker container and generate a configuration
2. Publish our newly container so we can reproduce our results on any machines

# Annex

## Work done to create Dockerfile for [CESM](http://cesm.ucar.edu)

Some relevant information [here](http://www.cesm.ucar.edu/models/cesm1.3/linux_cluster/).

It was compiled and run on a VM with Ubuntu 18.04 LTS

## Native package installation

~~~`bash`
sudo apt-get update
sudo apt-get dist-upgrade

sudo apt-get install gcc-6 g++-6 gfortran-6 -y
sudo apt install subversion -y
sudo apt install cmake -y
sudo apt-get install liblapack-dev -y
sudo apt-get install libxml2-dev libxml2-utils -y
sudo apt-get install libxml-libxml-perl -y
sudo apt-get install m4
sudo apt-get install python -y
~~~

## Compilation of libraries with GNU-6

All additional packages were installed on a different filesystem (with more storage):

~~~`bash`
export PREFIX=/opt/uio/modules/packages
~~~

### szip-2.1.1

~~~`bash`
cd szip-2.1.1
export SZIP_HOME=$PREFIX/szip/2.1.1
./configure --prefix=$SZIP_HOME
make
make install
cd ..
~~~

### mpich-3.3

~~~`bash`
cd mpich-3.3
export MPICH_HOME=$PREFIX/mpich/3.3
./configure CC=gcc-6 CXX=g++-6 F77=gfortran-6 FC=gfortran-6 --prefix=$MPICH_HOME
make
make install
cd ..
~~~

### hdf5-1.10.5

~~~`bash`
cd hdf5-1.10.5
export HDF5_HOME=$PREFIX/hdf5/1.10.5
./configure CC=$MPICH_HOME/bin/mpicc CXX=$MPICH_HOME/bin/mpic++ F77=$MPICH_HOME/bin/mpifort FC=$MPICH_HOME/bin/mpifort --with-szlib=$SZIP_HOME --enable-fortran --prefix=$HDF5_HOME --enable-parallel
make
make install
cd ..
~~~

### netcdf-c-4.6.3

~~~`bash`
cd netcdf-c-4.6.3
export NETCDF_HOME=$PREFIX/netcdf/4.6.3
CPPFLAGS="-I$HDF5_HOME/include -I$MPICH_HOME/include" LDFLAGS=-L$HDF5_HOME/lib ./configure --prefix=$NETCDF_HOME --enable-netcdf4 --disable-dap
make
make install
cd ..
~~~

### netcdf-fortran-4.4.5

~~~`bash`
cd netcdf-fortran-4.4.5
CPPFLAGS=-I$NETCDF_HOME/include LDFLAGS=-L$NETCDF_HOME/lib ./configure FC=$MPICH_HOME/bin/mpifort --prefix=$NETCDF_HOME
make
make install
~~~

## Add in the .profile:

~~~`bash`
# set PATH for netcdf
if [ -d "/opt/uio/modules/packages/netcdf/4.6.3/bin/" ]; then
    export PATH=/opt/uio/modules/packages/netcdf/4.6.3/bin${PATH:+:${PATH}}
    export LD_LIBRARY_PATH=/opt/uio/modules/packages/netcdf/4.6.3/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
fi

# set PATH for mpich
if [ -d "/opt/uio/modules/packages/mpich/3.3/bin/" ]; then
    export PATH=/opt/uio/modules/packages/mpich/3.3/bin${PATH:+:${PATH}}
    export LD_LIBRARY_PATH=/opt/uio/modules/packages/mpich/3.3/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
fi
~~~

## Compile CESM

### Get CESM source

Documentation available at [https://escomp.github.io/cesm/release-cesm2/downloading_cesm.html](https://escomp.github.io/cesm/release-cesm2/downloading_cesm.html) or [http://www.cesm.ucar.edu/models/cesm2/release_download.html](http://www.cesm.ucar.edu/models/cesm2/release_download.html).

Always take a release, as the master branch is usually not working properly:

~~~`bash`
git clone -b release-cesm2.1.0 https://github.com/ESCOMP/cesm.git
~~~


### CESM configuration files

These configuration files contain information on the compilers and machine (number of processors, memory, etc.) used for running CESM. 
They are used for creating, building and running new cases (i.e. running a climate experiment). We need to be able to set some paths at runtime for instance for the input directory (where input files will be downloaded for running your case), working directory (where your climate experiment will be run), archiving directory (where to store climate model outputs once your run is finished).

~~~`bash`
cp ./config_files/config_machines.xml /opt/uio/cesm/beta.cesm2.2/cime/config/cesm/machines/config_machines.xml
cp ./config_files/config_compilers.xml /opt/uio/cesm/beta.cesm2.2/cime/config/cesm/machines/config_compilers.xml

cp ./config_files/config_pes.xml_in_cime_config /opt/uio/cesm/beta.cesm2.2/cime_config/ncar_config_pes.xml
cp ./config_files/config_pes.xml_in_components_cam_cime_config /opt/uio/cesm/beta.cesm2.2/components/cam/cime_config/config_pes.xml
~~~

These configuration files can also be in `$HOME/.cime` as explained [here](http://www.cesm.ucar.edu/events/tutorials/2017/porting-edwards.pdf). It needs to be tested as it could be a good way to run CESM from Galaxy.

### Create a new case 


Depending on the case chosen by the user (case, res, compset). For instance these options will be given by galaxy tools.

~~~`bash`
./create_newcase --case /opt/uio/cesm/cases/use_gf19f --res f19_g17 --compset F1850 --machine espresso --run-unsupported
~~~

### Case setup

~~~`bash`
./case.setup
~~~

### Build the case

~~~`bash`
./case.build
~~~

### Update dates and run duration

Depending in what the user wants (here run from January 1850 and run for one month):

~~~`bash`
./xmlchange RUN_STARTDATE=1850-01-01
./xmlchange STOP_OPTION=nmonths
./xmlchange STOP_N=1
~~~

### Submit/run case

~~~`bash`
./case.submit
~~~

With a VM with 32 processors and 64 GB, it takes 490 pe-hrs / simulated year i.e 1.56 simulated_years / day.

