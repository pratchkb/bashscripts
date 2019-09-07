#!/bin/bash

for i in $(seq 1 100)
do
	if [[ ! -d "IC-$i" ]]; then
                continue
        fi
	cd IC-$i
	$COLUMBUS/geom2xyz.pl geom$i.dat	
	cd ..
done
