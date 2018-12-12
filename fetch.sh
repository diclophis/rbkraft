#!/bin/sh

set -e
set -x

test -e minecraft.jar || curl -o minecraft.jar https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar

test -e minecraft-client.jar || cp ~/.minecraft/versions/1.13.2/1.13.2.jar minecraft-client.jar
