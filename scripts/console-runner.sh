#!/bin/bash

RBKRAFT_CONSOLE_POD=$(kubectl get -o name pods -l app=rbkraft-console | cut -d/ -f2)
if [ -z "${RBKRAFT_CONSOLE_POD}" ];
then
  echo no console found
  exit 1
fi

kubectl exec -i ${RBKRAFT_CONSOLE_POD} -- xvfb-run -a -s "-screen 0 800x600x24" "$@"
