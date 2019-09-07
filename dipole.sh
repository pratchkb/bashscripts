#!/bin/bash

grep -A 12 "geometry" uracil-xms-caspt2-12-9-imag.json | sed -e '/geometry/,+0d' | awk '{print $1, $2, $3, $4, $5, $6, $7}' > geomsyntax1.dat
grep -A 12 "geometry" uracil-xms-caspt2-12-9-imag.json | sed -e '/geometry/,+0d' | awk '{print $11, $12, $13}' > geomsyntax2.dat


for i in $(seq 1 18)
do
     cd IC-$i
     awk 'BEGIN {OFS="," FS} { print $3, $4, $5 }' geom$i.dat > tmpgeom$i-tmp.dat
     paste ../geomsyntax1.dat tmpgeom$i-tmp.dat ../geomsyntax2.dat > tmpgeom$i.dat
     cat ../1.dat tmpgeom$i.dat ../dipole.dat > dipolegeom$i.json
     sed -i "s/newgeombohr-dipole/$i-dipole/g" dipolegeom$i.json
     sed -i "s/newgeom$i/dipolegeom$i/g" run-$i.slurm
     rm tmpge* 
     cd ..
done

for i in 20
do
     cd IC-$i
     awk 'BEGIN {OFS="," FS} { print $3, $4, $5 }' geom$i.dat > tmpgeom$i-tmp.dat
     paste ../geomsyntax1.dat tmpgeom$i-tmp.dat ../geomsyntax2.dat > tmpgeom$i.dat
     cat ../1.dat tmpgeom$i.dat ../dipole.dat > dipolegeom$i.json
     sed -i "s/newgeombohr-dipole/$i-dipole/g" dipolegeom$i.json
     sed -i "s/newgeom$i/dipolegeom$i/g" run-$i.slurm
     rm tmpge*
     cd ..
done

for i in $(seq 22 24)
do
     cd IC-$i
     awk 'BEGIN {OFS="," FS} { print $3, $4, $5 }' geom$i.dat > tmpgeom$i-tmp.dat
     paste ../geomsyntax1.dat tmpgeom$i-tmp.dat ../geomsyntax2.dat > tmpgeom$i.dat
     cat ../1.dat tmpgeom$i.dat ../dipole.dat > dipolegeom$i.json
     sed -i "s/newgeombohr-dipole/$i-dipole/g" dipolegeom$i.json
     sed -i "s/newgeom$i/dipolegeom$i/g" run-$i.slurm
     rm tmpge*
     cd ..
done

for i in $(seq 26 52)
do
     cd IC-$i
     awk 'BEGIN {OFS="," FS} { print $3, $4, $5 }' geom$i.dat > tmpgeom$i-tmp.dat
     paste ../geomsyntax1.dat tmpgeom$i-tmp.dat ../geomsyntax2.dat > tmpgeom$i.dat
     cat ../1.dat tmpgeom$i.dat ../dipole.dat > dipolegeom$i.json
     sed -i "s/newgeombohr-dipole/$i-dipole/g" dipolegeom$i.json
     sed -i "s/newgeom$i/dipolegeom$i/g" run-$i.slurm
     rm tmpge*
     cd ..
done

for i in $(seq 54 58)
do
     cd IC-$i
     awk 'BEGIN {OFS="," FS} { print $3, $4, $5 }' geom$i.dat > tmpgeom$i-tmp.dat
     paste ../geomsyntax1.dat tmpgeom$i-tmp.dat ../geomsyntax2.dat > tmpgeom$i.dat
     cat ../1.dat tmpgeom$i.dat ../dipole.dat > dipolegeom$i.json
     sed -i "s/newgeombohr-dipole/$i-dipole/g" dipolegeom$i.json
     sed -i "s/newgeom$i/dipolegeom$i/g" run-$i.slurm
     rm tmpge*
     cd ..
done

for i in $(seq 60 81)
do
     cd IC-$i
     awk 'BEGIN {OFS="," FS} { print $3, $4, $5 }' geom$i.dat > tmpgeom$i-tmp.dat
     paste ../geomsyntax1.dat tmpgeom$i-tmp.dat ../geomsyntax2.dat > tmpgeom$i.dat
     cat ../1.dat tmpgeom$i.dat ../dipole.dat > dipolegeom$i.json
     sed -i "s/newgeombohr-dipole/$i-dipole/g" dipolegeom$i.json
     sed -i "s/newgeom$i/dipolegeom$i/g" run-$i.slurm
     rm tmpge*
     cd ..
done

for i in $(seq 83 100)
do
     cd IC-$i
     awk 'BEGIN {OFS="," FS} { print $3, $4, $5 }' geom$i.dat > tmpgeom$i-tmp.dat
     paste ../geomsyntax1.dat tmpgeom$i-tmp.dat ../geomsyntax2.dat > tmpgeom$i.dat
     cat ../1.dat tmpgeom$i.dat ../dipole.dat > dipolegeom$i.json
     sed -i "s/newgeombohr-dipole/$i-dipole/g" dipolegeom$i.json
     sed -i "s/newgeom$i/dipolegeom$i/g" run-$i.slurm
     rm tmpge*
     cd ..
done



rm geoms* 

