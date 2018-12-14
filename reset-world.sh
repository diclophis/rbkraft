#!/bin/bash

set -e
set -x

rm -Rf /var/tmp/mavencraft
mkdir -p /var/tmp/mavencraft/{html,world,logs}
chmod 777 /var/tmp/mavencraft/{html,world,logs}
