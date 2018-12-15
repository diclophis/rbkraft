#!/bin/bash

set -e
set -x

VOLUMES=$(echo /var/tmp/mavencraft/{html,world,logs,backup})

rm -Rf /var/tmp/mavencraft
mkdir -p ${VOLUMES}
chmod 777 ${VOLUMES}
