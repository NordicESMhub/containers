#!/bin/bash

# Created by Kean Mariotti, CSCS Lugano, December 2019

#SBATCH --constraint=gpu
#SBATCH --job-name="B1850-benchmark"
#SBATCH --nodes=42
##SBATCH --nodes=4
#SBATCH --time=300
#SBATCH --output=slurm.out
#SBATCH --reservation=esiwace_2

module unload xalt
module load sarus

function run_test_case {
    local compiler=${1}; shift
    local case=${1}; shift
    local nodes=${1}; shift
    local processors=${1}; shift

    starttime=$(date +%s)

    echo "    # Running B1850 (${compiler} case #${case})"
    srun -N ${nodes} -n ${processors} -t 360 sarus run --mpi \
       --mount=src=${SCRATCH}/container-hackaton-for-modelers/run/${compiler}/B1850case${case},dst=/root/work/B1850case${case}/run,type=bind \
       --mount=src=/project/csstaff/mkean/container-hackaton-for-modelers/data/inputdata_B1850,dst=/root/inputdata,type=bind \
       load/library/nordicesmhub_b1850:${compiler} \
       bash -c "source /opt/intel/parallel_studio_xe_2018.1.038/psxevars.sh; cd /root/work/B1850case${case}/run && /root/work/B1850case${case}/bld/cesm.exe; if [ \${SLURM_PROCID} = 0 ]; then cp -R /root/cases/B1850case${case} /root/work/B1850case${case}/run/.; fi"

    endtime=$(date +%s)
    elapsed=$(($endtime - $starttime))

    echo "    # Executed B1850 (${compiler} case #${case}) in ${elapsed} seconds"
}

repetitions=10

for i in $(seq 1 ${repetitions}); do

    echo "    # Repetition ${i}/${repetitions}"
#    run_test_case intel 1 4 48
    run_test_case gnu 4 42 504

#    run_test_case intel 2 8 96
    run_test_case gnu 2 8 96

#    run_test_case intel 3 16 192
    run_test_case gnu 3 16 192

#    run_test_case intel 4 42 504
    run_test_case gnu 1 4 48

    #run_test_case intel 5 84 1008
    #run_test_case gnu 5 84 1008

done

