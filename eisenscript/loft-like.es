set background white
set maxdepth 500

#define mainP 6


//mainP -1
#define secondP  4

//secondP -1
#define thirdP 3

// 3 * mainP
#define fourthP 20

{ rx 90 } loft

rule loft {
rFloors
thirdP * {z 3} rFloors
mainP * {y 3 }  rLine
rFront
mainP * {y 3} rFront
rSideY
3 * {z 3 }  rSideY
}



rule rFloors {
     {x 9 y 9 s fourthP fourthP 0.1} box
}

rule rFront {
      rSideX
      3 * {z 3 }  rSideX
}

rule rLine {
      mainP * {x 3 }  rod
}

rule rSideX {
      plane
      secondP * {x 3 }  plane
}

rule rSideY {
      rSideY1
      mainP * {x 3 }  rSideY1
}

rule rSideY1 {
      { rz 90 }  rSideX
}

rule plane w 2 {
      { x 1.5  z 1.5 s 3 0.1 3} box
}

rule plane w 1 {
      { x 3 z 1.5 s 6 0.5 3} box
}

rule plane w 2  {
      { x 1 z 1.5 s 2 1 3} box
}

rule plane w 1 {
      { x 1.5  z 1.5 s 0.5 0.1 3} box
}

rule plane w 1 {
       { x 1.5  z 5 s 0.3 0.3 10} box
}

rule plane w 5 {
       // nothing
}


rule plane w 2 {
      { x 1.5 z 1.5 ry -45 s 0.1 0.1 4.24} box
      { x 1.5 z 1.5 ry  45 s 0.1 0.1 4.24} box
      {x 1.5 z 3 ry 90 s 0.1 0.1 3} box
}

//Scaffolding
rule rod {
       {z 7.5 s 0.1 0.1 15 } box
}

rule rod {
       {z 10 s 0.1 0.1 20  } box
}

rule rod {
        {z 6.5 s 0.1 0.1 13  } box
}

rule rod {
       // nothing
}
