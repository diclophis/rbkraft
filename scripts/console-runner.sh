#!/bin/bash

MAVENCRAFT_CONSOLE_POD=$(kubectl get -o name pods -l app=console | cut -d/ -f2)
if [ -z "${MAVENCRAFT_CONSOLE_POD}" ];
then
  echo no console found
  exit 1
fi

kubectl exec -i ${MAVENCRAFT_CONSOLE_POD} -- xvfb-run -a -s "-screen 0 800x600x24" "$@"
