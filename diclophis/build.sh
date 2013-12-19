#!/bin/sh

set -e

pgrep -f minecraft_server.1.7.2 > /dev/null

AIR=minecraft:air
LEAF=minecraft:leaves
WOOD=minecraft:log
SAND=minecraft:sand
STONE=minecraft:stonebrick
TORCH=minecraft:torch
CURSOR=0
STEP=0
OX=10010
OY=70
OZ=10010
NX=$OX
NY=$OY
NZ=$OZ
LX=$OX
LY=$OY
LZ=$OZ

sleep 2

blit() {
  echo sh place.sh $1 $2 $3 $AIR 0 replace
  #echo sh place.sh $1 $2 $3 $4 0 replace

  LX=$1
  LY=$2
  LZ=$3
}

torch_near() {
  TZ=$(( $LZ - 1 ))
  if [ $LZ = "10010" ];
  then
    blit $LX $LY $TZ $TORCH 0 destroy
  fi;
}

core_pillars() {
  for I in `seq -20 10 200`;
  do
    for H in `seq -10 0` #TODO: fix depth
    do
      NX_BEFORE=$(( $OX + $I ))
      NX=$(( $NX_BEFORE + $STEP ))
      NY=$(( $OY + $H))
      NZ=$(( $OZ + $CURSOR ))

      blit $NX $NY $NZ $SAND
    done;

    stone_base
  done;
}

stone_base() {
  for I in `seq 1 2`
  do
    SX=$NX
    SY=$(( $NY + $I ))
    SZ=$NZ
    blit $SX $SY $SZ $STONE
  done;

  FX=$(( $SX + 1 ))
  FY=$SY
  FZ=$SZ

  BX=$(( $SX - 1 ))
  BY=$SY
  BZ=$SZ

  #LX=$SX
  #LY=$SY
  #LZ=$(( $SZ + 1 ))

  RX=$SX
  RY=$SY
  #RZ=$(( $SZ - 1 ))

  blit $FX $FY $FZ $STONE
  blit $BX $BY $BZ $STONE
  #blit $LX $LY $LZ $STONE
  #blit $RX $RY $RZ $TORCH

  OLD_FX=$FX
  OLD_FY=$FY
  OLD_FZ=$FZ
  OLD_BX=$BX
  OLD_BY=$BY
  OLD_BZ=$BZ
  #OLD_LX=$LX
  #OLD_LY=$LY
  #OLD_LZ=$LZ
  #OLD_RX=$RX
  #OLD_RY=$RY
  #OLD_RZ=$RZ

  for O in `seq -1 1`
  do

    for R in `seq 0 4`
    do
      FX=$(( $FX + $O ))
      BX=$(( $BX + $O ))
      #LX=$(( $LX + $O ))
      #RX=$(( $RX + $O ))

      FY=$(( $FY + 1 ))
      BY=$(( $BY + 1 ))
      #LY=$(( $LY + 1 ))
      #RY=$(( $RY + 1 ))

      blit $FX $FY $FZ $STONE
      blit $BX $BY $BZ $STONE
      #blit $LX $LY $LZ $STONE
      #blit $RX $RY $RZ $TORCH
    done;

    FX=$OLD_FX
    FY=$OLD_FY
    FZ=$OLD_FZ
    BX=$OLD_BX
    BY=$OLD_BY
    BZ=$OLD_BZ
    #LX=$OLD_LX
    #LY=$OLD_LY
    #LZ=$OLD_LZ
    #RX=$OLD_RX
    #RY=$OLD_RY
    #RZ=$OLD_RZ
  done;
}

reset() {
  CURSOR=0
}

next_to() {
  CURSOR=$(( $CURSOR + 1 ))
}

step() {
  STEP=$(( $STEP + 1 ))
}

for S in `seq 0 1`;
do
  for I in `seq 0 10`;
  do
    reset
    core_pillars
    next_to
    core_pillars
    next_to
    core_pillars
    next_to
  done;
  step
done;
