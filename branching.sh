#!/bin/bash

echo "**********************************************************************"
echo ""
echo " Reading the last line of data in Prop.3 Data file for each trajectory"
echo " to discrimate between reactants and products"
echo ""
echo "***********************************************************************"

rm -rf TRAJ-*

rm -rf int-coord*

rm -rf lessthan*.dat greaterthan*.dat

echo -n "Number of Trajectories?    "

read TRAJ

echo -n "Threshold bond distance?(in Angstrom)    "

read Thres

echo "Set threshold: $Thres"

CHD=0

HT=0

for i in $(seq 1 $TRAJ)

do

	grep " $i " prop.3 | awk '{print $1, $2, $3, $4, $5, $6, $7, $8}' > traj-$i.dat
  
	num=$(awk 'END{print $NF}' traj-$i.dat)
	
	if [[ $num < $Thres ]] ; then

#		echo "It is CHD" 

		CHD=$((CHD+1))

		cat traj-$i.dat <(echo) >> lessthan.dat

	else 

#		echo "It is HT"

		HT=$((HT+1))

		cat traj-$i.dat <(echo) >> greaterthan.dat

	fi
		   
done

echo -n "No. of trajectories ended up in CHD: $CHD"

echo -e ""

echo -n "No. of trajectories ended up in HT: $HT"

echo -e ""

rm -rf traj-*.dat



