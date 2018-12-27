#!/bin/bash

cp diclophis/stl_stdin_blit_vox.rb /var/tmp/mavencraft/backup

kubectl exec -i $(kubectl get -o name pods -l name=text | cut -d/ -f2) -- xvfb-run -a -s "-screen 0 800x600x24" ruby /home/minecraft/backup/stl_stdin_blit_vox.rb $1 $2 $3 $4
