#!/bin/bash

for i in 20
do
	cd IC-$i
	sbatch run-$i.slurm
	cd ..
done
