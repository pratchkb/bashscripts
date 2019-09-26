#!/bin/bash

echo "********************************************************************************************************"
echo ""
echo " Calculating average and standard deviation from lessthan.dat/greaterthan.dat "
echo "   for internal coordinates(refer to intcfl file to understand which column   "
echo "      represents which internal coordinate) for total simulation window.      "
echo ""
echo "                       Author: Pratip Chakraborty                             "
echo ""
echo " Do not run this script more than once, simultaneously, from different terminals. "
echo ""
echo "********************************************************************************************************"


rm -rf time.dat each_val_*.dat all_diff* sq_diff*

read -p "Maximum time(fs) of a trajectory?    "  timlim

read -p "Which internal coordinate are you interested in?  " intcoord

column=$[ $intcoord + 2 ]

echo -e "We are using column $column" 

read -p "What is the file? lessthan.dat or greaterthan.dat?  " file

echo -e "We are using $file"

echo -e "This may take some time. Your patience is appreciated. :)"

#Make time file

for i in `seq 0.00 0.50 $timlim`; do echo $i >> time.dat; done


#Collect the averages in file av-check-$intcoord-$file and time and average in check-$intcoord-$file

for j in `seq 0.00 0.50 $timlim`

do
		 
		sumtotal_time_j=$(grep " $j "  $file | awk -v column=${column} '{print $column}' | awk '{ sum += $1; } END { print sum; }')

#                echo $sumtotal_time_j  

		no_traj_available_j=$(grep " $j "  $file | awk -v column=${column} '{print $column}' | wc -l)

# 		echo $no_traj_available_j

		echo $sumtotal_time_j $no_traj_available_j | awk '{print $1/$2}' >> av-check-$intcoord-$file

done
                
paste av-check-$intcoord-$file time.dat | column -s $'\t' -t >> check-$intcoord-$file #pasting time.dat as $2 so that $mean_k(line 67) is read properly



#Collect the standard deviations and add it to the avg-stdev-$intcoord-$file file along with time and averages 
#Columns in avg-stdev-$intcoord-$file: $1-Time(fs), $2-Average(Angstrom), $3-Standard Deviation

for k in `seq 0.00 0.50 $timlim`

do
                grep " $k "  $file | awk -v column=${column} '{print $column}' >> each_val_$k.dat
                
		num_k=$(grep " $k " $file | awk -v column=${column} '{print $column}' | wc -l)

#		echo $num_k
                
                mean_k=$(grep " $k" check-$intcoord-$file | awk '{print $1}')

#		echo $mean_k
               	
		for l in `cat each_val_$k.dat`
 			
		do		
	 		
			all_diff_k=$(echo "$l-$mean_k" | bc)

			echo $all_diff_k >> all_diff_$k.dat

			sq_diff_k=$(echo "scale=8; $all_diff_k*$all_diff_k" | bc)

			echo $sq_diff_k >> sq_diff_$k.dat
		
			var_k=$(awk '{ sum += $1; } END { print sum; }' sq_diff_$k.dat)
	                	
		done			

		stan_dev_k=$(echo "scale=8; $var_k/$num_k" | bc)

		echo $stan_dev_k >> standev-$intcoord-$file
	
done 

paste check-$intcoord-$file standev-$intcoord-$file | column -s $'\t' -t > avg-stdev-$intcoord-$file.chk

awk '{print $2, $1, $3}' avg-stdev-$intcoord-$file.chk | column -s $'\t' -t > avg-stdev-$intcoord-$file

rm all_diff*.dat sq_diff_*.dat each_val_*.dat 
rm av-check* standev-$intcoord*	avg-stdev-$intcoord-$file.chk		


