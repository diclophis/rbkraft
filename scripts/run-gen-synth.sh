#!/bin/bash

kubectl exec --namespace=mavencraft -i $(kubectl get --namespace=mavencraft -o name pods -l app=mavencraft-console | cut -d/ -f2) -- xvfb-run -a -s "-screen 0 800x600x24" ruby diclophis/structure_synth_inline.rb $1 $2 2> /dev/null
