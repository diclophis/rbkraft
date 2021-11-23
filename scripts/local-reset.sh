#!/bin/bash

polly build &

kubectl delete -Rf kubernetes/common; kubectl delete -Rf kubernetes/local; rm -Rf /var/tmp/rbkraft/*

wait

kubectl apply -Rf kubernetes/local && kubectl apply -Rf kubernetes/common
