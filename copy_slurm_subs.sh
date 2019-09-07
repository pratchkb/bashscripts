#!/bin/bash

for i in $(seq 1 19)
do
        cd TRAJ$i
        cp ../run.slurm .
        sed -i "s/21/$i/g" run.slurm
        cd ..
done

