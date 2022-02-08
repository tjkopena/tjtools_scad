
module wood_screw_cavity(recess=1, shaft=8) {

  head_d = 8 + $tol*2;
  head_h = 0.5;

  recess_h = recess;

  shaft_d = 4 + $tol*2;
  shaft_h = shaft;

  translate([0, 0, -0.5]) {
    cylinder(d=head_d, h=head_h+recess_h);

    translate([0, 0, -2]) {
      cylinder(d1=shaft_d, d2=head_d, h=2);

      translate([0, 0, -shaft_h])
        cylinder(d=shaft_d, h=shaft_h);
    }
  }

}
