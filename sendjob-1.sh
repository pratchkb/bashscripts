#!/bin/bash

for i in $(seq 1 19)
do
        cd TRAJ$i
        sbatch run.slurm 
        cd ..
done

