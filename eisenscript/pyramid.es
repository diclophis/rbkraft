#define dis 1
#define off 0.866

//1 * { z -0.05 s 50 50 0.1 } box
r1

rule r1 md 5 {
  { x dis z dis s 0.5 h 72 } r1
  { x dis z 0 s 0.5 h 72 } r1
  { x 0 z dis s 0.5 h 72 } r1
  { x 0 z 0 s 0.5 h 72 } r1
  { x 0.5 z 0.5 y off s 0.5 h 72 } r1
  { x 1 z 1 y 0.5 } box
}

rule p2 {
  { h 0 } prmd
}

rule prmd { 
   triangle[0.5,0.5,0 ;0,0,off;1,0,off] 
   triangle[0.5,0.5,0 ;1,0,off;1,1,off] 
   triangle[0.5,0.5,0 ;1,1,off;0,1,off] 
   triangle[0.5,0.5,0 ;0,1,off;0,0,off] 
   triangle[0,0,off;1,0,off;1,1,off] 
   triangle[1,1,off;0,1,off;0,0,off] 
} 
