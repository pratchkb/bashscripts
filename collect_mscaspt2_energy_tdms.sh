#!/bin/bash

rm TDM* energetic* OSC*

#############################################################################################################
#                                                                                                           #
#   Collecting MS-CASPT2 Energies in "energetics.dat" and Transition Dipole Moments in "TDM-x.dat",         #
#   "TDM-y.dat" and "TDM-z.dat" for BAGEL                                                                   #
#                                      									    #
#############################################################################################################

echo -e "How many initial condition?"
read init

echo -e "How many states?"
read nstates

#ENERGIES#

for i in $(seq 1 $init)
do
        for (( j=0; j<nstates; j++ ))
        do
        	if [[ ! -d "IC-$i" ]]; then
			continue
		fi	
		cd IC-$i
		grep "MS-CASPT2 energy : state  $j" dipolegeom$i.*.out | awk '{print $7}' >> ../energetics_s$j.dat
		cd ..
	done
done

paste energetics_s*.dat | column -s $'\t' -t > energetics.dat
awk '{print NR  " " $s}' energetics.dat > energetics-number.dat

#TDMS#

for i in $(seq 1 $init)
do
        for (( j=1; j<nstates; j++ ))
        do
                if [[ ! -d "IC-$i" ]]; then
                        continue
                fi
                cd IC-$i
                grep " Transition    $j - 0" dipolegeom$i.*.out | awk '{print $8}' | sed -e 's/,//g' >> ../TDM-x-tmp-0$j.dat
                grep " Transition    $j - 0" dipolegeom$i.*.out | awk '{print $9}' | sed -e 's/,//g' >> ../TDM-y-tmp-0$j.dat
                grep " Transition    $j - 0" dipolegeom$i.*.out | awk '{print $10}' | sed -e 's/)//g' >> ../TDM-z-tmp-0$j.dat
                grep -A 1 " Transition    $j - 0" dipolegeom$i.*.out |  sed -e '2,/ Transition    $j - 0/!d' | awk '{print $5}' >> ../OSC-0$j-tmp.dat
		cd ..
        done
done


paste TDM-x-tmp-0*.dat | column -s $'\t' -t > TDMs-x.dat
paste TDM-y-tmp-0*.dat | column -s $'\t' -t > TDMs-y.dat
paste TDM-z-tmp-0*.dat | column -s $'\t' -t > TDMs-z.dat
paste OSC-0*-tmp.dat | column -s $'\t' -t > OSC.dat

awk '{print NR  " " $s}' TDMs-x.dat > TDM-x-number.dat
awk '{print NR  " " $s}' TDMs-y.dat > TDM-y-number.dat
awk '{print NR  " " $s}' TDMs-z.dat > TDM-z-number.dat
awk '{print NR  " " $s}' OSC.dat > OSC-number.dat



rm energetics_s* TDM-*-tmp* OSC-0*-tmp*
