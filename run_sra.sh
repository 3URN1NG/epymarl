#!/bin/bash

alg=(qmix maddpg ippo)

for a in "${alg[@]}"
do
   for i in {0..9}
   do
      python src/main.py --config=$a --env-config=gymma with env_args.key="mpe:SimpleSpread-v0" seed=$i
      echo "Running $a on mpe:SimpleSpread-v0 for seed=$i"
      sleep 2s
   done
done
