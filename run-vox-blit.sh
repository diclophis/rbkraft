#!/bin/bash

set -x

#while ! kubectl describe --namespace=mavencraft pod -l name=text --field-selector=status.phase=Running
##| grep ContainersReady | grep True
##kubectl get -o name pods -l name=text
#do
#  echo -n .
#done

#kubectl exec -i $(kubectl get -o name pods -l name=text | cut -d/ -f2) -- xvfb-run -a -s "-screen 0 800x600x24" ruby /home/minecraft/diclophis/stl_stdin_blit_vox.rb $1 $2 $3 $4 $5

kubectl exec --namespace=mavencraft -i $(kubectl get --namespace=mavencraft -o name pods -l name=text | cut -d/ -f2) -- xvfb-run -a -s '-screen 0 800x600x24' ruby /home/minecraft/diclophis/stl_stdin_blit_vox.rb $1 $2 $3 $4 $5
