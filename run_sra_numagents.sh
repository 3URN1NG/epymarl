#!/bin/bash

alg=(qmix maddpg ippo pmaddpg)
nmbrs=(3 5 7 9)

for n in "${nmbrs[@]}"
do
   for a in "${alg[@]}"
   do
      for i in {0..4}
      do
         python src/main.py --config=$a --env-config=gymma with env_args.key="mpe:SimpleSpread-v0$n" seed=$i
         echo "Running $a on mpe:SimpleSpread-v0 for seed=$i with $n agents"
         sleep 2s
      done
   done
done
