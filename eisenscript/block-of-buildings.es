//1 * { x -100 z 100 } 5 * { x 40 color #e0e0e0 } 5 * { z -40 } block

{ z -40 color #e0e0e0 } block

rule block {
{ x -20 z -20 } building
{ x -10 z -20 } building
{ x -0 z -20 } building
{ x -20 z -10 } building
{ x -10 z -10 } building
{ x -0 z -10 } building
{ x -15 z 0 } building1x2
{ x -0 z 0 } building
}

rule block {
{ x -20 z -20 } building
{ x -10 z -20 } building
{ x -0 z -20 } building
{ x -20 z -10 } building
{ x -10 z -10 ry 90 } building
{ x -0 z -10 } building
{ x -20 z 0 } building
{ x -10 z 0 ry 90 } building
{ x -0 z 0 } building
}

rule block {
{ x -10 z -20 } building
{ x -0 z -20 } building
{ x -20 z -10 } building
{ x -0 z -10 } building
{ x -15 z 0 } building1x2
{ x -0 z 0 } building
}

rule block {
{ x -20 z -20 } building
{ x -10 z -20 } building
{ x -20 z -10 } building
{ x -10 z -10 ry 90 } building
{ x -0 z -10 } building
{ x -10 z 0 ry 90 } building
{ x -0 z 0 } building
}

rule building {
1 * { x -4 z -6 y 10.5 s 1 21 1 } 5 * { z 2 } box
1 * { x 4 z -6 y 10.5 s 1 21 1 } 5 * { z 2 } box
{ y 10.5 s 7 21 9 } box
1 * { y -3 s 9 1 9 } 8 * { y 3 } box
{ y 22 s 8 1 8 } box
}

rule building {
1 * { x -4 z -6 y 11 s 1 22 1 } 5 * { z 2 } box
1 * { x 4 z -6 y 11 s 1 22 1 } 5 * { z 2 } box
{ y 10.5 s 7 22 9 } box
1 * { y -2 s 9 1 9 } 12 * { y 2 } box
{ y 23 s 8 2 8 } box
{ y 24 s 6 1 6 } box
{ x 2 z 2 y 25 s 2 2 2 } box
}

rule building {
1 * { y -2 s 9 1 9 } 9 * { y 2 } box
1 * { x -5 z -5 y -1 } 8 * { y 2 } 9 * { x 1 } 9 * { z 1 } 1 * { s 0.95 } box
1 * { y 18 s 7 3 3 } box
}

rule building {
1 * { y -2 s 9 1 9 } 8 * { y 2 } box
1 * { x -5 z -5 y -1 } 7 * { y 2 } 9 * { x 1 } 9 * { z 1 } 1 * { s 0.95 } box
1 * { y 14 s 7 1 7 } 6 * { y 2 } box
1 * { x -4 z -4 y 13 } 6 * { y 2 } 7 * { x 1 } 7 * { z 1 } 1 * { s 0.95 } box
1 * { y 27 s 5 1 5 } box
}

//rule building {
//}

rule building1x2 {
1 * { y -2 z -0.5 s 19 1 8 } 8 * { y 2 } box
1 * { x -10 z -5 y -1 } 7 * { y 2 } 19 * { x 1 } 8 * { z 1 } 1 * { s 0.95 } box
{ s 6 2 1 z 4 y 0.25 } box
}

//// 白色の地面
