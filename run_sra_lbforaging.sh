#!/bin/bash

alg1=(ppo maddpg qmix)
nmbrs=(9 7 5 3)

for n in "${nmbrs[@]}"
do
   for a in "${alg1[@]}"
   do
      for i in {0..4}
      do
         f=$n + 1
         python src/main.py --config=$a --env-config=gymma with env_args.key="lbforaging:Foraging-12x12-${n}p-3f-v1" seed=$i
         echo "Running $a on mpe:SimpleSpread-v0 for seed=$i with $n agents"
         sleep 2s
      done
   done
done

mkdir /home/simon/projects/ma/epymarl/testingresults/0011_lbfor_fo_nocoop_ppo_maddpg_qmix/
mv results /home/simon/projects/ma/epymarl/testingresults/0011_lbfor_fo_nocoop_ppo_maddpg_qmix/

for n in "${nmbrs[@]}"
do
   for a in "${alg1[@]}"
   do
      for i in {0..4}
      do
         python src/main.py --config=$a --env-config=gymma with env_args.key="lbforaging:Foraging-2s-12x12-${n}p-3f-v1" seed=$i
         echo "Running $a on mpe:SimpleSpread-v0 for seed=$i with $n agents"
         sleep 2s
      done
   done
done

mkdir /home/simon/projects/ma/epymarl/testingresults/0012_lbfor_po_nocoop_ppo_maddpg_qmix/
mv results /home/simon/projects/ma/epymarl/testingresults/0012_lbfor_po_nocoop_ppo_maddpg_qmix/

for n in "${nmbrs[@]}"
do
   for a in "${alg1[@]}"
   do
      for i in {0..4}
      do
         python src/main.py --config=$a --env-config=gymma with env_args.key="lbforaging:Foraging-12x12-${n}p-3f-coop-v1" seed=$i
         echo "Running $a on mpe:SimpleSpread-v0 for seed=$i with $n agents"
         sleep 2s
      done
   done
done

mkdir /home/simon/projects/ma/epymarl/testingresults/0013_lbfor_fo_coop_ppo_maddpg_qmix/
mv results /home/simon/projects/ma/epymarl/testingresults/0013_lbfor_fo_coop_ppo_maddpg_qmix/

for n in "${nmbrs[@]}"
do
   for a in "${alg1[@]}"
   do
      for i in {0..4}
      do
         python src/main.py --config=$a --env-config=gymma with env_args.key="lbforaging:Foraging-2s-12x12-${n}p-3f-coop-v1" seed=$i
         echo "Running $a on lbforaging:Foraging for seed=$i with $n agents"
         sleep 2s
      done
   done
done

mkdir /home/simon/projects/ma/epymarl/testingresults/0014_lbfor_po_coop_ppo_maddpg_qmix/
mv results /home/simon/projects/ma/epymarl/testingresults/0014_lbfor_po_coop_ppo_maddpg_qmix/
