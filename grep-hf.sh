#!/bin/bash


#rm -r geo* newgeom* run-* IC-*


###########################################################################################
#  Reading all the initial geometries from a previously calculated Wigner distribution    #
#  No. of spaces b/w Initial condition" and the "#" is different                          #
###########################################################################################




#for i in $(seq 1 9)
#do
#	grep -A 13 "Initial condition =     $i" final_output.1.3 | sed -e '/Initial condition =/,+1d' > geom$i.dat
#        awk '{print $3}' geom$i.dat > geom$i-x.dat; awk '{print $4}' geom$i.dat > geom$i-y.dat; awk '{print $5}' geom$i.dat > geom$i-z.dat
#        grep -A 26 "Initial condition =     $i" final_output.1.3 | sed -e '/Initial condition =/,+14d' > vel-$i.dat
#done

#for i in $(seq 10 50)
#do
#        grep -A 13 "Initial condition =    $i" final_output.1.3 | sed -e '/Initial condition =/,+1d' > geom$i.dat
#        awk '{print $3}' geom$i.dat > geom$i-x.dat; awk '{print $4}' geom$i.dat > geom$i-y.dat; awk '{print $5}' geom$i.dat > geom$i-z.dat
#        grep -A 26 "Initial condition =    $i" final_output.1.3 | sed -e '/Initial condition =/,+14d' > vel-$i.dat
#done




for i in $(seq 51 99)
do
        grep -A 13 "Initial condition =    $i" final_output.1.3 | sed -e '/Initial condition =/,+1d' > geom$i.dat
        awk '{print $3}' geom$i.dat > geom$i-x.dat; awk '{print $4}' geom$i.dat > geom$i-y.dat; awk '{print $5}' geom$i.dat > geom$i-z.dat
        grep -A 26 "Initial condition =    $i" final_output.1.3 | sed -e '/Initial condition =/,+14d' > vel-$i.dat
done


for i in $(seq 100 100)
do
        grep -A 13 "Initial condition =   $i" final_output.1.3 | sed -e '/Initial condition =/,+1d' > geom$i.dat
        awk '{print $3}' geom$i.dat > geom$i-x.dat; awk '{print $4}' geom$i.dat > geom$i-y.dat; awk '{print $5}' geom$i.dat > geom$i-z.dat
        grep -A 26 "Initial condition = $i" final_output.1.3 | sed -e '/Initial condition =/,+14d' > vel-$i.dat
done


#######################################################################################





#############################################################################################
#  formatting of BAGEL geometry files and saving them in geomsyntax1.dat & geomsyntax2.dat  #
#  need a BAGEL input (*.json) file in advance in the directory                             #
#############################################################################################



grep -A 12 "geometry" uracil-xms-caspt2-12-9-imag.json | sed -e '/geometry/,+0d' | awk '{print $1, $2, $3, $4, $5, $6, $7}' > geomsyntax1.dat
grep -A 12 "geometry" uracil-xms-caspt2-12-9-imag.json | sed -e '/geometry/,+0d' | awk '{print $11, $12, $13}' > geomsyntax2.dat




#############################################################################################




#############################################################################################
#  Creating input file for BAGEL to calculate vertical excitation energies                  #
#############################################################################################




for i in $(seq 51 100)
do
     mkdir IC-$i
     paste geom$i-x.dat geom$i-y.dat geom$i-z.dat | awk 'BEGIN {OFS="," FS} { print $1, $2, $3 }' > newgeom$i-tmp.dat
     paste geomsyntax1.dat newgeom$i-tmp.dat geomsyntax2.dat > newgeom$i.dat
     cat 1.dat newgeom$i.dat 2.dat > IC-$i/newgeom$i.json
     sed -i "s/uracil-xms-caspt2-12-9-imag/$i/g" IC-$i/newgeom$i.json
done

#############################################################################################




#############################################################################################
#    Creating slurm input files for all the BAGEL jobs                                      #
#############################################################################################


for i in $(seq 51 100)
do
	
	cp run.slurm IC-$i/run-$i.slurm
        cd IC-$i
        cp ../geom$i.dat .
        cp ../vel-$i.dat .
        sed -i "s/newgeom/newgeom$i/g" run-$i.slurm
	sed -i "s/testing/IC-$i/g" run-$i.slurm
        sed -i "s/test/$i/g" run-$i.slurm
        cd ..        	
done

rm newgeom* geom* vel-*
