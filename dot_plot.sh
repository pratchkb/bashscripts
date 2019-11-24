#!/bin/bash

declare -xr LUSTRE="/oasis/scratch/comet/pratip/temp_project"
declare -xr WORK_DIR="${LUSTRE}/ciscisCOD_lowest_casscf_4_3_xsede/DYNAMICS-del/TRAJECTORIES/Hops-with-intcoord-analysis"

read -p "Total no. of trajectories? " TRAJ

#read -p "Maximum time(fs) of a trajectory?    "  timlim

read -p "Which internal coordinate are you interested in?  " intcoord

column=$[ $intcoord + 2 ]

echo -e "We are using column $column" 

read -p "What is the file? prop.3 (only for bond lengths) or final-prop3-smothangled.dat?  " file

echo -e "We are using $file"

echo -e "This may take some time. Your patience is appreciated. :)"

for i in `seq 1 $TRAJ`

do
	if [ -d "../TRAJ$i" ]; then

		cd ../TRAJ$i/RESULTS

		if [ -f "hop21_new_$i.dat" ]; then

			for j in `cat hop21_new_$i.dat`

			do

				num=$j
	
				echo -e "$j"

				limit=$(grep -A10 "TRAJECTORY $i:" ../../diag.log | grep "Suggestion:" | awk '{print $7}' | sed '2,$d')

				echo -e "$limit"

				if [ $(bc <<< "$num < $limit") -eq 1 ]; then
			
		 			echo -e "Hop is within energy conservation region"
	
					value=`grep " $num " ${WORK_DIR}/$file | grep " $i " | awk -v column=${column} '{print $column}'`
	
					echo -e " TRAJ$i   $j   $value" >> "${WORK_DIR}"/allhops-traj.dat

				else

					echo -e "TRAJ$i $num fs should be discarded" >> "${WORK_DIR}"/discardhops-traj.dat

					continue

				fi

			done

		else

			echo -e "Can't find the file for TRAJ$i"
			
#			continue

		fi

		cd ${WORK_DIR}

	else

		echo -e "Can't find directory TRAJ$i"

#		continue

	fi

done

