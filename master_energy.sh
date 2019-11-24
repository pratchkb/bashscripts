#!/bin/bash

declare -xr LUSTRE="/oasis/scratch/comet/pratip/temp_project"
declare -xr WORK_DIR="${LUSTRE}/ciscisCOD_lowest_casscf_4_3_xsede/DYNAMICS-del/TRAJECTORIES/ENERGY-EV-NEW"

cd ${WORK_DIR}

rm ploten.gpi

read -p "No. of Trajectories? " TRAJ

#read -p "Total Simulation Window? " timlim

read -p "Minimum time (fs)? " min

read -p "Maximum time (fs)? " max

echo -e "Collecting energy information..."

for i in `cat $min-$max-traj-updated.dat |  grep -o -E '[0-9]+'`

do
        	
	cd ../TRAJ$i

	num=$(grep -A10 "TRAJECTORY $i:" ../diag.log | grep "Suggestion:" | awk '{print $7}' | sed '2,$d')

        sed "1,/ $num /!d" RESULTS/en.dat >> ${WORK_DIR}/en-$i-$min-$max.dat

	cd ${WORK_DIR}

done

cd ${WORK_DIR}

echo -e "Concatenating energy (in a.u. and eV) information in a single file for plotting..."

for i in `seq 1 $TRAJ`

do

	if  [ -f "en-$i-$min-$max.dat" ]; then

                echo -e "# TRAJ$i:" >> energy-$min-$max.dat

		cat en-$i-$min-$max.dat >> energy-$min-$max.dat

		echo -e "" >> energy-$min-$max.dat

		ref=`grep " 0.00 " en-$i-$min-$max.dat | awk '{print $2}' | sed '2,$d'`

		last=`awk 'END{print}' en-$i-$min-$max.dat | awk '{print $1}'`

		echo -e "# TRAJ$i:" >> energy-ev-$min-$max.dat

		for j in `seq 0.00 0.50 $last`

		do

			s0=`grep " $j " en-$i-$min-$max.dat | awk '{print $2}' | sed '2,$d'`			

			s1=`grep " $j " en-$i-$min-$max.dat | awk '{print $3}' | sed '2,$d'`

			s2=`grep " $j " en-$i-$min-$max.dat | awk '{print $4}' | sed '2,$d'`

			echo $j $s0 $s1 $s2 $ref | awk {'print" "$1"  " ($2-$5)*27.2114"  " ($3-$5)*27.2114"  " ($4-$5)*27.2114 }' >> energy-ev-$min-$max.dat

		done

      	        echo -e "" >> energy-ev-$min-$max.dat
	
	else

		continue

	fi

done

rm en-*

echo -e "Generating template gnuplot file for plotting..."
echo -e "Please modify ploten.gpi as you wish..."
echo -e "" >> ploten.gpi
echo -e "set terminal pngcairo color enhanced" >> ploten.gpi
echo -e "set output 'energy.png'" >> ploten.gpi		
echo -e ""
echo -e "set xlabel 'Time (fs)' font 'Times-Roman,20'" >> ploten.gpi
echo -e "set ylabel 'Energy (a.u.)' font 'Times-Roman,20'" >> ploten.gpi
echo -e "set tics font 'Times-Roman,20'" >> ploten.gpi
echo -e "set key font 'Times-Roman,20'" >> ploten.gpi
echo -e "" >> ploten.gpi
echo -e 'pl "energy.dat" u 1:3 t "S_{1}" w l lc rgb "gray", "" u 1:4 t "S_{2}" w l lc rgb "orange"' >> ploten.gpi

