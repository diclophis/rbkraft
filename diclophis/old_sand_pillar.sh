#!/bin/sh

set -e

pgrep -f minecraft_server.1.7.2 > /dev/null

sleep 2

AIR=minecraft:air
SAND=minecraft:sand
CURSOR=0
STEP=0
TOTAL_BLOCKS=5000

OX=10000
OY=70
OZ=10030

MAX_RADIUS=10.0
NOW_RADIUS=0.0

LX=$OX
LY=$OY
LZ=$OZ

R=0
SEED=0.`grep -m1 -ao '[0-9]' /dev/urandom | while read line; do echo -n "$line"; done`
RAND=$(echo | awk "BEGIN { srand(); print rand(); }")

random() {
  #echo | awk 'srand() {print rand()}'
  #SEED=$(grep -m1 -ao '[0-9]' /dev/urandom | sed s/0/10/ | head -n1)
  #SEED=0.`grep -m1 -ao '[0-9]' /dev/urandom | while read line; do echo -n "$line"; done`
  #SEED=0.`grep -m1 -ao '[0-9]' /dev/urandom | while read line; do echo -n "$line"; done`
  #echo $SEED
  #echo 'echo | awk "BEGIN { srand(); print rand(); }"'
  R=$(( $R + 1 ))
  echo "(s($RAND * $R) + 1.0) * 0.5" | bc -l
}

blit() {
  #echo sh place.sh $1 $2 $3 $AIR 0 replace
  echo sh place.sh $1 $2 $3 $4 0 replace

  LX=$1
  LY=$2
  LZ=$3
}

PI=$(echo "4*a(1)" | bc -l) 

for I in `seq 1 10`;
do
  random
  echo $(random)
done;

exit

for I in `seq 1 $TOTAL_BLOCKS`;
do
  echo $(random)
  NOW_RADIUS=$(echo "(((($I * 1.0) / $TOTAL_BLOCKS)) * $MAX_RADIUS) + 1.0" | bc -l)
  #echo $NOW_RADIUS 1>&2
  RANDOM_MULT=$(echo "$(random) * 10.0" | bc -l)
  #var angle = Math.random()*Math.PI*2;
  ANGLE=$(echo "$RANDOM_MULT * $PI * 2.0" | bc -l)
  #ANGLE=$(echo ${ANGLE%.*})
  RADIUS_MULT=$(echo "scale=10.0;$(random) * $NOW_RADIUS" | bc -l | awk '{printf "%f", $0}')
  RADIUS=$(echo ${RADIUS_MULT%.*})

  #RADIUS_INVERT_NORM=$(echo "((($MAX_RADIUS * $MAX_RADIUS) - (${RADIUS} * ${RADIUS})) / ($MAX_RADIUS * $MAX_RADIUS)) * 100.0" | bc -l | awk '{printf "%f", $0}')
  RADIUS_INVERT_NORM=$(echo "(1.0 - ((($NOW_RADIUS * $NOW_RADIUS) - (${RADIUS} * ${RADIUS})) / ($NOW_RADIUS * $NOW_RADIUS))) * 100.0" | bc -l | awk '{printf "%f", $0}')
  RADIUS_INVERT_NORM=$(echo ${RADIUS_INVERT_NORM%.*})
  PLACE_RANDOM=$(echo "$(random) * 100.0 * (($I * $I) / ($TOTAL_BLOCKS * $TOTAL_BLOCKS))" | bc -l | awk '{printf "%f", $0}')
  PLACE_RANDOM=$(echo ${PLACE_RANDOM%.*})

  #Then x = Math.cos(angle)*radius and y = Math.sin(angle)*radius
  X=$(echo "c($ANGLE) * $RADIUS" | bc -l | awk '{printf "%f", $0}')
  Z=$(echo "s($ANGLE) * $RADIUS" | bc -l | awk '{printf "%f", $0}')
  X=$(echo ${X%.*})
  Z=$(echo ${Z%.*})

  echo rand $RAND $RANDOM_MULT angle:$ANGLE radius:$RADIUS rinvert:$RADIUS_INVERT_NORM place:$PLACE_RANDOM x:$X z:$Z 1>&2

  if [ "$PLACE_RANDOM" -lt "$RADIUS_INVERT_NORM" ]; # if RADIUS_INVERT_NORM is large, more likely to drop
  then
    SX=$(( $OX + $X ))
    SY=$(( $OY + 0 ))
    SZ=$(( $OZ + $Z ))

    #echo dropped 1>&2

    #echo $X $Y $SX $SY $SZ
    blit $SX $SY $SZ $SAND
  fi;
done;
