#!/bin/bash

kubectl delete -Rf kubernetes/common -f kubernetes/local; rm -Rf /var/tmp/mavencraft/{world,map}

kubectl apply -Rf kubernetes/common -f kubernetes/local
