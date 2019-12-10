set background white

{ hue 20 sat 0.8  } r2

rule r2 maxdepth 50 {
{ s 0.66  rz 33  b 0.999   }  r2
frame
}

rule frame  {
{ s 0.01 1 0.01 x 50  z 50 } box
{ s 0.01 1 0.01 x 50  z -50 } box
{ s 0.01 1 0.01 x -50  z 50 } box
{ s 0.01 1 0.01 x -50  z -50 } box

{ s 1 0.01 0.01 y 50  z 50 } box
{ s 1 0.01 0.01 y 50  z -50 } box
{ s 1 0.01 0.01 y -50  z 50 } box
{ s 1 0.01 0.01 y -50  z -50 } box

{ s 0.01 0.01 1 y 50  x 50 } box
{ s 0.01 0.01 1 y 50  x -50 } box
{ s 0.01 0.01 1 y -50  x 50 } box
{ s 0.01 0.01 1 y -50  x -50 } box
}

