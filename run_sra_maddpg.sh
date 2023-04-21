#!/bin/bash

alg=(maddpg_optim1 maddpg_optim2 maddpg_optim3 maddpg_optim4)
nmbrs=(7 5 3)

for n in "${nmbrs[@]}"
do
   for a in "${alg[@]}"
   do
      for i in {0..2}
      do
         python src/main.py --config=$a --env-config=gymma with env_args.key="mpe:SimpleSpread-v0$n" seed=$i
         echo "Running $a on mpe:SimpleSpread-v0 for seed=$i with $n agents"
         sleep 2s
      done
   done
done
