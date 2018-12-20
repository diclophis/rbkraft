include <text_on.scad>;

translate([0, 0, 0]) {
  rotate([0, -90, 0]) {
    rotate([0, -90, 0]) {
      rotate([-90, 0, 0]) {
        text_on_sphere(msg, font="TakaoMincho", r=100, extrusion_height=3, northsouth=90, size=32, rounded=true, spacing=1.01);
      }
    }
  }
}

