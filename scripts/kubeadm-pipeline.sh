#!/bin/bash

#TODO: build out local tooling/reset/bootstrap cli

kubectl delete -Rf kubernetes/common -f kubernetes/local; rm -Rf /var/tmp/rbkraft/{world,map}

kubectl apply -Rf kubernetes/common -f kubernetes/local
