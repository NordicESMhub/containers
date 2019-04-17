FROM ubuntu:18.04

#####EXTRA LABELS#####
LABEL autogen="no" \ 
    software="CESM" \ 
    version="2" \
    software.version="2.1.0" \ 
    about.summary="Community Earth System Model" \ 
    base_image="ubuntu:18.04" \
    about.home="http://www.cesm.ucar.edu/" \
    about.license="Copyright (c) 2017, University Corporation for Atmospheric Research (UCAR). All rights reserved." 
      
MAINTAINER Anne Fouilloux <annefou@geo.uio.no>

RUN apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get install -y curl wget gcc-6 g++-6 gfortran-6 cmake subversion m4 && \
    apt-get install -y liblapack-dev libxml2-dev libxml2-utils libxml-libxml-perl && \
    apt-get install -y python && \
    apt-get clean

RUN wget https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz && \
    tar zxvf szip-2.1.1.tar.gz && \
    cd szip-2.1.1 && \
    ./configure  && \
    make && make install && \
    cd .. && rm -rf szip-2.1.1 

RUN wget http://www.mpich.org/static/downloads/3.3/mpich-3.3.tar.gz && \
    tar zxvf mpich-3.3.tar.gz && cd mpich-3.3 && \
    ./configure CC=gcc-6 CXX=g++-6 F77=gfortran-6 FC=gfortran-6 && \
    make && make install && \
    cd .. && rm -rf mpich-3.3

RUN wget -O hdf5-1.10.5.tar.gz https://www.hdfgroup.org/package/hdf5-1-10-5-tar-gz/?wpdmdl=13571&refresh=5cb739d6d3ef21555511766 &&  \
  tar zxvf hdf5-1.10.5.tar.gz && cd hdf5-1.10.5 && \
  ./configure CC=mpicc CXX=mpic++ F77=mpifort FC=mpifort --enable-fortran --enable-parallel && \
  make && make install && cd .. && rm -rf hdf5.1.10.5

RUN wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.6.3.tar.gz && \
   tar zxvf netcdf-c-4.6.3.tar.gz && cd netcdf-c-4.6.3 && \
   ./configure --enable-netcdf4 --disable-dap && \
   make && make install && cd .. && rm -rf netcdf-c-4.6.3

RUN wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.4.5.tar.gz \
    tar zxvf netcdf-fortran-4.4.5.tar.gz && cd netcdf-fortran-4.4.5 \
    ./configure FC=mpifort F77=mpifort && make && make install 

RUN useradd -m -U cesm -G users

USER cesm

RUN cd /data/ && \
    git clone -b release-cesm2.1.0 https://github.com/ESCOMP/cesm.git && \
    cd cesm && ./manage_externals/checkout_externals

WORKDIR /data/


