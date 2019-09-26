#!/bin/bash

echo "**************************************************************************** "
echo ""
echo "  Calculating ensemble average from lessthan.dat and greaterthan.dat  "
echo "              file for the total simulation window                    "
echo "                 Author: Pratip Chakraborty                           "
echo "Check out standard-dev.sh. It calculates both average and standard deviation."
echo "*****************************************************************************"

rm -rf TRAJ-*

rm -rf int-coord*

rm -rf new.dat av.dat time.dat

#rm -rf lessthan*.dat greaterthan*.dat

read -p "Number of Trajectories?    " TRAJ

read -p "Maximum time(fs) of a trajectory?    " timelim

read -p "Which internal coordinate are you interested in?  " intcoord

column=$[ $intcoord + 2 ]

echo -e "We are using column $column" 

awk '{print $1}' mean_value.3 > time.dat

for j in `seq 0.00 0.50 $timelim`

do
		 
		sumtotal_time_j=$(grep " $j "  lessthan.dat | awk '{print $8}' | awk '{ sum += $1; } END { print sum; }')

		no_traj_available_j=$(grep " $j "  lessthan.dat | awk '{print $8}' | wc -l)

		echo $sumtotal_time_j $no_traj_available_j | awk '{print $1/$2}' >> av1.dat

done
                
paste time.dat av1.dat | column -s $'\t' -t >> ltc5c6.dat

for i in `seq 0.00 0.50 $timelim`

do

                sumtotal_time_i=$(grep " $i "  greaterthan.dat | awk '{print $8}' | awk '{ sum += $1; } END { print sum; }')

                no_traj_available_i=$(grep " $i "  greaterthan.dat | awk '{print $8}' | wc -l)

                echo $sumtotal_time_i $no_traj_available_i | awk '{print $1/$2}' >> avg1.dat

done

paste time.dat avg1.dat | column -s $'\t' -t >> gtc5c6.dat

rm -rf av*.dat

