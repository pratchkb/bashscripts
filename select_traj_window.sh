#!/bin/bash

rm S1-w* S2-w* win*

awk '{print $1, ((($3)-($2))*27.2114), ((($4)-($2))*27.2114)}' energetics-number.dat > eV-energy-s1-s2.dat
paste eV-energy-s1-s2.dat OSC.dat > en-osc-tmp.dat
awk '{print $1, $2, $4, $3, $5}' en-osc-tmp.dat > EN-OSC.dat


#awk  '{print $2}' EN-OSC.dat > S1.dat
#awk  '{print $4}' EN-OSC.dat > S2.dat

echo -e "Energy Center (eV)?"
read energy_center

echo -e "Center: $energy_center"

echo -e "Window on both sides?"
read window

echo -e "Window: $window"

Emin=$(echo "scale=2; ${energy_center} - ${window}" | bc)

Emax=$(echo "scale=2; ${energy_center} + ${window}" | bc)

echo -e "Range: $Emin - $Emax"


for i in `awk  '{print $2}' EN-OSC.dat`
do
	if [ $(bc <<< "$i >= $Emin") -eq 1 ] && [ $(bc <<< "$i <= $Emax") -eq 1 ]; then
 		grep " $i " EN-OSC.dat | awk '{print $1, $2, $3, $4, $5}' >> S1-window.dat
	fi
done

for j in `awk  '{print $4}' EN-OSC.dat`
do
        if [ $(bc <<< "$j >= $Emin") -eq 1 ] && [ $(bc <<< "$j <= $Emax") -eq 1 ]; then
                grep " $j " EN-OSC.dat | awk '{print $1, $2, $3, $4, $5}' >> S2-window.dat
        fi
done

for i in `awk  '{print $2}' S1-window.dat && awk '{print $4}' S2-window.dat`
do
        if [ $(bc <<< "$i >= $Emin") -eq 1 ] && [ $(bc <<< "$i <= $Emax") -eq 1 ]; then
                grep " $i " EN-OSC.dat | awk '{print $1, $2, $3, $4, $5}' >> window.dat
        fi
done

