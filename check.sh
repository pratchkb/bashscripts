#!/bin/bash

echo -e "How many states?"
read nstates

for (( j=0; j<nstates; j++ ))
do
   echo -e "$j"
done
