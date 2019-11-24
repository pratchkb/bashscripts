#!/bin/bash

read -p "Maximum time of the trajectory (fs)? " timlim

read -p "Which state are you interested in?(S0=1, S1 = 2, S2 = 3) " state

column=$[ $state + 1 ] 

echo -e "Using column $column"

for i in `seq 0.00 0.50 $timlim`; do echo $i >> time.dat; done

for j in `seq 0.00 0.50 $timlim`

do
		 
		sumtotal_time_j=$(grep " $j " energy-ev-100-500.dat | awk -v column=${column} '{print $column}' | awk '{ sum += $1; } END { print sum; }')

#                echo $sumtotal_time_j  

		no_traj_available_j=$(grep " $j " energy-ev-100-500.dat | awk -v column=${column} '{print $column}' | wc -l)

# 		echo $no_traj_available_j

		echo $sumtotal_time_j $no_traj_available_j | awk '{print $1/$2}' >> av$state.dat

done
                
paste time.dat av$state.dat | column -s $'\t' -t >> av-ev-$state-energy.dat

rm time.dat av$state.dat

