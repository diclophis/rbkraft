#!/bin/bash

kubectl exec --namespace=mavencraft -i $(kubectl get --namespace=mavencraft -o name pods -l name=text | cut -d/ -f2) -- xvfb-run -a -s "-screen 0 800x600x24" ruby diclophis/text.rb "$1"
#> /var/tmp/txt.stl
