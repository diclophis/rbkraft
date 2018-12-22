// maze parts

//outer_size * 0.05;
//shape = 17;

//outer_size * 0.125;
//shape = 16;
//shape = 17;
//shape = 0;
module skew(dims) {
matrix = [
	[ 1, tan(dims[0]), tan(dims[1]), 0 ],
	[ tan(dims[2]), 1, tan(dims[3]), 0 ],
	[ tan(dims[4]), tan(dims[5]), 1, 0 ],
	[ 0, 0, 0, 1 ]
];
multmatrix(matrix)
children();
}

module pathway(direction, pscale) {
    outer_size = 1.0;
    cut_size = outer_size * 0.33;
    inner_size = outer_size * 1.0;
    core_size = outer_size / 1.015;
    path_size = outer_size * 0.33 * pscale;
    path_size_h = outer_size * 0.35;
    //path_size = outer_size * 0.125;
    inner_path_size = path_size * 0.97;
    fudge = 0.05 * outer_size;
    inner_intersection_size = 0.65;
    quarter_slice_size = 0.2343;
    quarter_slice_size_l = 0.34;
    outer_fudge_smidge = (outer_size+fudge)*0.99;
    half_smidge = 0.33;
      
    scale([1, 1.0, 0.33]) {
        intersection() {
            if (direction == 5) {
                translate([-cut_size*inner_intersection_size,0,0]) {
                    cube(size=[inner_size, path_size, inner_size], center=true);
                }
            }
    
            if (direction == 6) {
                translate([cut_size*inner_intersection_size,0,0]) {
                    cube(size=[inner_size, path_size, inner_size], center=true);
                }
            }
    
            if (direction == 7) {
                translate([0,-cut_size*inner_intersection_size,0]) {
                    cube(size=[path_size, inner_size, inner_size], center=true);
                }
            }
    
            if (direction == 8) {
                translate([0,cut_size*inner_intersection_size,0]) {
                    cube(size=[path_size, inner_size, inner_size], center=true);
                }
            }
    
            if (direction == 9) {
                cube(size=[path_size, inner_size, inner_size], center=true);
            }
    
            if (direction == 10) {
                cube(size=[inner_size, path_size, inner_size], center=true);
            }
    
            if (direction == 11) {
                union() {
                    translate([cut_size*inner_intersection_size,0,0]) {
                        cube(size=[inner_size, path_size, inner_size], center=true);
                    }
    
                    translate([0,-cut_size*inner_intersection_size,0]) {
                        cube(size=[path_size, inner_size, inner_size], center=true);
                    }
                }
            }
            
            if (direction == 12) {
                union() {
                    translate([cut_size*inner_intersection_size,0,0]) {
                        cube(size=[inner_size, path_size, inner_size], center=true);
                    }
                    
                    translate([0,cut_size*inner_intersection_size,0]) {
                        cube(size=[path_size, inner_size, inner_size], center=true);
                    }
                }
            }
    
            if (direction == 13) {
                union() {
                    translate([-cut_size*inner_intersection_size,0,0]) {
                        cube(size=[inner_size, path_size, inner_size], center=true);
                    }
    
                    translate([0,cut_size*inner_intersection_size,0]) {
                        cube(size=[path_size, inner_size, inner_size], center=true);
                    }
                }
            }
    
            if (direction == 14) {
                union() {
                    translate([-cut_size*inner_intersection_size,0,0]) {
                        cube(size=[inner_size, path_size, inner_size], center=true);
                    }
    
                    translate([0,-cut_size*inner_intersection_size,0]) {
                        cube(size=[path_size, inner_size, inner_size], center=true);
                    }
                }
            }
    
            difference() {
                union() {
                    cube(size=[path_size, outer_size, path_size_h], center=true);
                    cube(size=[outer_size, path_size, path_size_h], center=true);
                }
    
                translate([0,0,path_size * half_smidge]) {
                    if (direction == 0) {
                        cube(size=[inner_path_size, outer_size+fudge, inner_path_size], center=true);
                        cube(size=[outer_size+fudge, inner_path_size, inner_path_size], center=true);
                    }
    
                    if (direction == 1) {
                        translate([0,outer_size*half_smidge,0]) {
                            cube(size=[inner_path_size, outer_size+fudge, inner_path_size], center=true);
                        }
                        cube(size=[outer_size+fudge, inner_path_size, inner_path_size], center=true);
                    }
    
                    if (direction == 2) {
                        translate([0,-outer_size*half_smidge,0]) {
                            cube(size=[inner_path_size, outer_size+fudge, inner_path_size], center=true);
                        }
                        cube(size=[outer_size+fudge, inner_path_size, inner_path_size], center=true);
                    }
    
                    if (direction == 3) {
                        cube(size=[inner_path_size, outer_size+fudge, inner_path_size], center=true);
                        translate([outer_size*half_smidge,0,0]) {
                           cube(size=[outer_size+fudge, inner_path_size, inner_path_size], center=true);
                        }
                    }
    
                    if (direction == 4) {
                        cube(size=[inner_path_size, outer_size+fudge, inner_path_size], center=true);
                        translate([-outer_size*half_smidge,0,0]) {
                            cube(size=[outer_size+fudge, inner_path_size, inner_path_size], center=true);
                        }
                    }
    
                    if (direction == 5) {
                        translate([-outer_size*quarter_slice_size,0,0]) {
                            cube(size=[outer_size+fudge-(fudge * 0.25), inner_path_size, inner_path_size], center=true);
                        }
                    }
    
                    if (direction == 6) {
                        translate([outer_size*quarter_slice_size,0,0]) {
                            cube(size=[outer_size+fudge-(fudge * 0.25), inner_path_size, inner_path_size], center=true);
                        }
                    }
    
                    if (direction == 7) {
                        translate([0,-outer_size*quarter_slice_size,0]) {
                            cube(size=[inner_path_size, outer_size+fudge-(fudge * 0.25), inner_path_size], center=true);
                        }
                    }
    
                    if (direction == 8) {
                        translate([0, outer_size*quarter_slice_size,0]) {
                            cube(size=[inner_path_size, outer_size+fudge-(fudge * 0.25), inner_path_size], center=true);
                        }
                    }
    
                    if (direction == 9) {
                        cube(size=[inner_path_size, outer_size+fudge, inner_path_size], center=true);
                    }
    
                    if (direction == 10) {
                        cube(size=[outer_size+fudge, inner_path_size, inner_path_size], center=true);
                    }
    
                    if (direction == 11) {
                        union() {
                            translate([outer_size*quarter_slice_size,0,0]) {
                                cube(size=[outer_fudge_smidge, inner_path_size, inner_path_size], center=true);
                            }
    
                            translate([0,-outer_size*quarter_slice_size,0]) {
                                cube(size=[inner_path_size, outer_fudge_smidge, inner_path_size], center=true);
                            }
                        }
                    }
    
                    if (direction == 12) {
                        union() {
                            translate([outer_size*quarter_slice_size,0,0]) {
                                cube(size=[outer_fudge_smidge, inner_path_size, inner_path_size], center=true);
                            }
    
                            translate([0, outer_size*quarter_slice_size,0]) {
                                cube(size=[inner_path_size, outer_fudge_smidge, inner_path_size], center=true);
                            }
                        }
                    }
    
                    if (direction == 13) {
                        union() {
                            translate([-outer_size*quarter_slice_size,0,0]) {
                                cube(size=[outer_fudge_smidge, inner_path_size, inner_path_size], center=true);
                            }
    
                            translate([0, outer_size*quarter_slice_size,0]) {
                                cube(size=[inner_path_size, outer_fudge_smidge, inner_path_size], center=true);
                            }
                        }
                    }
    
                    if (direction == 14) {
                        union() {
                            translate([-outer_size*quarter_slice_size,0,0]) {
                                cube(size=[outer_fudge_smidge, inner_path_size, inner_path_size], center=true);
                            }
    
                            translate([0,-outer_size*quarter_slice_size,0]) {
                                cube(size=[inner_path_size, outer_fudge_smidge, inner_path_size], center=true);
                            }
                        }
                    }
                }
    
                translate([0,0,-path_size_h*0.75]) {
                    union() {
                        cube(size=[path_size+fudge, outer_size+fudge, path_size+fudge], center=true);
                        cube(size=[outer_size+fudge, path_size+fudge, path_size+fudge], center=true);
                    }
                }
            }
        }
    }
 
    brot = (direction == 9) ? [90, 0, 0] :  [0, 90, 0];
    brotb = (direction == 9) ? [0, 45, 0] : [-45, 0, 0];
    bskew = (direction == 9) ? [0,20,0,0,20,0] : [0, 0, 0, 20, 0, 20];
    if (direction == 9 || direction == 10) {
      rotate(brotb) {
          skew(bskew) {
              rotate(brot) {
                  rotate_extrude(convexity = 10, $fn = 100)
                  translate([0.3, -0.125, 0]) {
                    circle(r = 0.033, $fn = 10);
                  }
                  
                  rotate_extrude(convexity = 10, $fn = 100)
                  translate([0.3, 0.125, 0]) {
                    circle(r = 0.033, $fn = 10);
                  }
        
        
                  rotate_extrude(convexity = 10, $fn = 100)
                  translate([0.3, -0.125, 0]) {
                    square(size=[0.005, 0.25]);
                  }
              }
          }
      }
    }
        
    if (shape < 15 && shape >= 0) {
        
      shelf_light_size = [0.033, 0.033, 0.033];
      shelf_light_offset = 0.525;
      shelf_light_h = 0.24;
 
      //shelf lighting
      translate([quarter_slice_size_l * shelf_light_offset, quarter_slice_size_l * shelf_light_offset, quarter_slice_size_l * shelf_light_h]) {
          cube(size=shelf_light_size, center=true);
      }
    
      translate([-quarter_slice_size_l * shelf_light_offset, -quarter_slice_size_l * shelf_light_offset, quarter_slice_size_l * shelf_light_h]) {
          cube(size=shelf_light_size, center=true);
      }
    
      translate([quarter_slice_size_l * shelf_light_offset, -quarter_slice_size_l * shelf_light_offset, quarter_slice_size_l * shelf_light_h]) {
          cube(size=shelf_light_size, center=true);
      }
    
      translate([-quarter_slice_size_l * shelf_light_offset, quarter_slice_size_l * shelf_light_offset, quarter_slice_size_l * shelf_light_h]) {
          cube(size=shelf_light_size, center=true);
      }
    
      // voxel space normalization regestry tris
      translate([outer_size * 0.5,outer_size*0.5,outer_size*0.5]) {
          cube(size=[0.01, 0.01, 0.01], center=true);
      }
    
      translate([-outer_size * 0.5,outer_size*0.5,outer_size*0.5]) {
          cube(size=[0.01, 0.01, 0.01], center=true);
      }
    
      translate([-outer_size * 0.5,-outer_size*0.5,outer_size*0.5]) {
          cube(size=[0.01, 0.01, 0.01], center=true);
      }
    
      translate([-outer_size * 0.5,-outer_size*0.5,-outer_size*0.5]) {
          cube(size=[0.01, 0.01, 0.01], center=true);
      }
    
      translate([outer_size * 0.5,-outer_size*0.5,-outer_size*0.5]) {
          cube(size=[0.01, 0.01, 0.01], center=true);
      }
    
      translate([outer_size * 0.5,outer_size*0.5,-outer_size*0.5]) {
          cube(size=[0.01, 0.01, 0.01], center=true);
      }
    
      translate([-outer_size * 0.5,outer_size*0.5,-outer_size*0.5]) {
          cube(size=[0.01, 0.01, 0.01], center=true);
      }
    
      translate([outer_size * 0.5,-outer_size*0.5,outer_size*0.5]) {
          cube(size=[0.01, 0.01, 0.01], center=true);
      }
    }
    

}

if (false) {
//    for (offset=[0:15]) {
//        translate([(offset*(1.01+0)),0,0]) {
//            pathway(offset, 1.0);
//        }
//    }
  
    pathway(9, 1.0);

} else {
    if (shape > 15) {
      if (shape == 16) {
          pathway(15, 0.77);
      }
    
      if (shape == 17) {
          pathway(15, 0.44);
      }
    } else {
      pathway(shape, 1.0);
    }
}
