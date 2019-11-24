#!/bin/bash

echo -e "**********************************************************************************************************************"
echo -e "*                                                                                                                    *"
echo -e "*            This script collects all the trajectories which have S1 -> S0 hops between var min - var max fs         *"
echo -e "*                                                                                                                    *"
echo -e "*                                         Author: Pratip Chakraborty                                                 *"
echo -e "**********************************************************************************************************************"

declare -xr LUSTRE="/oasis/scratch/comet/pratip/temp_project"
declare -xr WORK_DIR="${LUSTRE}/ciscisCOD_lowest_casscf_4_3_xsede/DYNAMICS-del/TRAJECTORIES/ENERGY-PLOTS-S1-S2"

read -p "Minimum Time? " min
echo -e "$min"
read -p "Maximum Time? " max
echo -e "$max"

rm -rf "${WORK_DIR}"/$min-$max-traj.dat

echo -e "# This file contains the information about trajectories which hop from S1 -> S0 b/w $min-$max fs." >> "${WORK_DIR}"/$min-$max-traj.dat

for i in `seq 1 200`

do
	if [ -d "../TRAJ$i" ]; then

		cd ../TRAJ$i/RESULTS

		for j in `cat hop21_new_$i.dat`

		do

			num=$j

			echo -e "$j"

			limit=$(grep -A10 "TRAJECTORY $i:" ../../diag.log | grep "Suggestion:" | awk '{print $7}' | sed '2,$d')

			echo -e "$limit"

			if [ $(bc <<< "$num < $limit") -eq 1 ]; then

				if [ $(bc <<< "$num >= $min") -eq 1 ] && [ $(bc <<< "$num < $max") -eq 1 ]; then

					echo -e "TRAJ$i is between $min and $max fs"
	
					echo -e " TRAJ$i     $j fs" >> "${WORK_DIR}"/$min-$max-traj.dat

				else

					continue

				fi

			else

				echo -e "TRAJ$i $num fs should be discarded" >> "${WORK_DIR}"/discard-$min-$max.dat

				continue

			fi

		done

	        cd ${WORK_DIR}

	else

		continue

	fi

done

