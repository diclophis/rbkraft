#!/bin/bash

kubectl delete -Rf kubernetes/common; kubectl delete -Rf kubernetes/local; rm -Rf /var/tmp/mavencraft/*

kubectl apply -Rf kubernetes/local && kubectl apply -Rf kubernetes/common
