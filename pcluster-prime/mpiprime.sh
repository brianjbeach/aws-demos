#!/bin/sh
#$ -cwd
#$ -N mpiprime
#$ -pe mpi 4
#$ -j y
/usr/lib64/openmpi/bin/mpirun /shared/mpiprime.o > mpiprime.txt
