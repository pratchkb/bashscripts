#!/bin/bash

for i in $(seq 1 19)
do
	cd TRAJ$i/RESULTS/
	cp ../../plot.gpi .
	gnuplot plot.gpi
	ps2pdf plot.ps plot.pdf
	cd ../../
done
	
