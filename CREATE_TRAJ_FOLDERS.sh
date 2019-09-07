#!/bin/bash


#for i in `awk '{print $1}' S2-IC-WINDOW.dat`
#do
#		echo -e "$i" 
#	mkdir TRAJ$i
#	cd TRAJ$i
#	cp ../PARAM-TRAJ/* .
#        cd ..
#done


WIN=`awk '{print $2}' S2-IC-WINDOW.dat`

for j in $WIN
do
	mkdir TRAJ$j
	cd TRAJ$j
        cp -r /oasis/scratch/comet/pratip/temp_project/URACIL_XMSCASPT2_BAGEL_DYNAMICS_NX2.2/DYN_S2/DYNAMICS_URACIL_CASPT2_BAGEL_500/* .
	cp /oasis/scratch/comet/pratip/temp_project/ABSORPTION_SPECTRA_URACIL_CASPT2_BAGEL_500/IC-$j/geom$j.dat geom
	cp /oasis/scratch/comet/pratip/temp_project/ABSORPTION_SPECTRA_URACIL_CASPT2_BAGEL_500/IC-$j/vel-$j.dat veloc
	cd ..
done
	

