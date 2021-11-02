#!/bin/bash

set -x

kubectl exec -i $(kubectl get -o name pods -l app=rbkraft-console | cut -d/ -f2) -- xvfb-run -a -s '-screen 0 800x600x24' ruby /home/app/diclophis/stl_stdin_blit_vox.rb $1 $2 $3 $4 $5
