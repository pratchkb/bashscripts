#!/bin/bash

echo "***********************************************************************"
echo "*Adding a blank line between each trajectory data in Prop.3 Data file *"
echo "*    Deleting jumps in torsion angles by converting it through 2*pi   *"
echo "*          Saving the new prop.3 file as final-prop.3                 *"
echo "***********************************************************************"

rm -rf *.dat  *.py final-prop.3



echo -e "Number of Trajectories?    "

read TRAJ

########################################################
#Seperate internal coordinate data from each trajectory#
########################################################

for i in $(seq 1 $TRAJ)

do

    grep " $i " prop.3 > traj-$i.dat

done

##############################################################
#Seperate each trajectory data by column into different files#
##############################################################

for i in $(seq 1 $TRAJ)

do
    awk '{print $1}' traj-$i.dat > trajno-$i.dat
    awk '{print $2}' traj-$i.dat > trajtime-$i.dat	
    awk '{print $11}' traj-$i.dat > 11-$i.dat
    awk '{print $12}' traj-$i.dat > 12-$i.dat
    awk '{print $13}' traj-$i.dat > 13-$i.dat
    awk '{print $14}' traj-$i.dat > 14-$i.dat
    awk '{print $15}' traj-$i.dat > 15-$i.dat
    awk '{print $16}' traj-$i.dat > 16-$i.dat
    awk '{print $17}' traj-$i.dat > 17-$i.dat
    awk '{print $18}' traj-$i.dat > 18-$i.dat
    awk '{print $19}' traj-$i.dat > 19-$i.dat
    awk '{print $20}' traj-$i.dat > 20-$i.dat
    awk '{print $21}' traj-$i.dat > 21-$i.dat
done

#####################################################
#preparing the python script for each and every file#
#   and acting python script on all those files     #
#####################################################

read -p "Starting column no. of internal coordinates (torsion) in the prop.3 file? " START
read -p "Ending column no. of internal coordinatesi(torsion) in the prop.3 file? " STOP

for i in $(seq 1 $TRAJ)

do
   
    cp scriptpython script-$i.py
   
    for j in $(seq $START $STOP)

    do

	cp script-$i.py $j-$i.py
        sed -i "s/test.dat/$j-$i.dat/g" $j-$i.py
        sed -i "s/output.dat/$j-$i-updated.dat/g" $j-$i.py
        python $j-$i.py

    done

done

########################################################
#   Bringing everything back together in final-prop3   #
########################################################

for i in $(seq 1 $TRAJ)

do

    paste trajno-$i.dat trajtime-$i.dat | column -s $'\t' -t > trtime-$i.dat

    paste *-$i-updated.dat | column -s $'\t' -t > tor-$i.dat

done


for i in $(seq 1 $TRAJ)

do
    
    paste trtime-$i.dat tor-$i.dat | column -s $'\t' -t > prop3-$i.dat
     
done

for i in $(seq 1 $TRAJ)

do

    cat prop3-$i.dat <(echo) >> final-prop.3

done

rm -rf *.dat *.py 

