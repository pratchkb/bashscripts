#!/bin/bash

echo "**********************************************************************"
echo ""
echo " Adding a blank line between each trajectory data in Prop.3 Data file "
echo ""
echo "***********************************************************************"

rm -rf TRAJ-*

rm -rf int-coord*

echo -n "Number of Trajectories?    "

read TRAJ

for i in $(seq 1 $TRAJ)

do

  grep " $i " prop.3 > traj-$i.dat

done


for j in $(seq 1 $TRAJ)

do

  cat traj-$j.dat <(echo) >> final-prop3.dat

done


rm -rf traj-*.dat



