#!/bin/bash

echo -e """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
echo -e " Capturing cartesian coordinates corresponding to S1->S0 hops for each  "
echo -e "                   trajectory del-hop21-cartesian.xyz                   "
echo -e """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

rm -rf S1-S0-hops-xyz
rm -rf TRAJ*/RESULTS/hop21_*.dat
rm -rf hop21-cartesian.dat del-hop21-cartesian.xyz

read -p "No. of trajectories? " TRAJ

#grep -A33 " 0.00 " TRAJ1/RESULTS/intec_new | grep -v " 0.00 " | grep -v " internal " | awk NF | awk '{print $1}' > serial_intcoord.dat

echo -e ""
echo -e "EXECUTING PART 1"
echo -e ""
#######################################################################
# Finds the time of S1->S0 hops and saves it to 2 decimal places  #####
#######################################################################


for i in $(seq 1 $TRAJ)
do
        if [ -d "TRAJ$i" ]; then
        	cd TRAJ$i/RESULTS
        	grep -A 1 "Hopping 2 -> 1 occurred:" nx.log | grep -v "Hopping 2 -> 1 occurred:" | awk '{print $6}' | awk NF > hop21_$i.dat
        	for j in `cat hop21_$i.dat`
        	do
                	hop21_del=${j%??}
                	echo -e $hop21_del >> hop21_new_$i.dat
        	done
        	cd ../..
	else
		continue
	fi
done

echo -e ""
echo -e "EXECUTING PART 2"
echo -e ""
################################################################################
# Copying the cartesian coordinates of the S1->S0 hops for all trajectories    #
#                     in del-hop21-cartesian.xyz file.                         #
#                 Change $LUSTRE and $WORK_DIR accordingly                     #
################################################################################

declare -xr LUSTRE="/oasis/scratch/comet/pratip/temp_project"
declare -xr WORK_DIR="${LUSTRE}/ciscisCOD_lowest_casscf_4_3_xsede/DYNAMICS-del/TRAJECTORIES"

for i in $(seq 1 $TRAJ)
do
        if [ -d "TRAJ$i" ]; then
		cd TRAJ$i/RESULTS/
		for j in `cat hop21_new_$i.dat`
        	do
			if [ -f "hop21_new_$i.dat" ]; then
                		echo -e " 20 " >> "${WORK_DIR}"/del-hop21-cartesian.xyz
                		echo -e " TRAJ$i : Time = $j " >> "${WORK_DIR}"/del-hop21-cartesian.xyz
                		grep -A20 " $j " dyn-$i.xyz | grep -v " $j " >> "${WORK_DIR}"/del-hop21-cartesian.xyz
			else
				continue
			fi
        	done
        	cd ../..
	else
		continue
	fi
done


echo -e ""
echo -e "EXECUTING PART 3"
echo -e ""
################################################################################
# Copying the cartesian coordinates of the S1->S0 hops for all trajectories    #
#       in separate xyz files names traj"#"-hop"time".xyz in ${XYZ_DIR}        #
#                 Change $XYZ_DIR accordingly                                  #
################################################################################

mkdir "${WORK_DIR}"/S1-S0-hops-xyz
declare -xr XYZ_DIR="${LUSTRE}/ciscisCOD_lowest_casscf_4_3_xsede/DYNAMICS-del/TRAJECTORIES/S1-S0-hops-xyz"

for i in $(seq 1 $TRAJ)
do
        if [ -d "TRAJ$i" ]; then
                cd TRAJ$i/RESULTS/
                for j in `cat hop21_new_$i.dat`
                do
			if [ -f "hop21_new_$i.dat" ]; then
                        	echo -e " 20 " >> "${XYZ_DIR}"/traj$i-hop$j.xyz
                        	echo -e " TRAJ$i : Time = $j " >> "${XYZ_DIR}"/traj$i-hop$j.xyz
                        	grep -A20 " $j " dyn-$i.xyz | grep -v " $j " >> "${XYZ_DIR}"/traj$i-hop$j.xyz
			else
				continue
			fi
                done
                cd ../..
        else
                continue
        fi
done

