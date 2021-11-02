#!/bin/bash

kubectl exec -i $(kubectl get -o name pods -l app=rbkraft-console | cut -d/ -f2) -- xvfb-run -a -s "-screen 0 800x600x24" ruby diclophis/structure_synth_inline.rb $1 $2 2> /dev/null
