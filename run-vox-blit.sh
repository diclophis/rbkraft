#!/bin/bash

kubectl exec --namespace=mavencraft -i $(kubectl get --namespace=mavencraft -o name pods -l name=text | cut -d/ -f2) -- xvfb-run -a -s "-screen 0 800x600x24" ruby /home/minecraft/diclophis/stl_stdin_blit_vox.rb $1 $2 $3 $4 $5
