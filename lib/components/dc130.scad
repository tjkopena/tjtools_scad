// DC 130 motor
// Metal casing is 20mm wide by 15mm tall by 20mm long
// Rear plastic housing is same shape as casing, 5mm long
// Typical spindle is 2mm by 8mm beyond the protruding small bearing
module tj_dc130(spindle_d=2) {
  module can_shape(l) {
      intersection() {
        translate([-11, 0, -7.5])
          cube([22, l, 15]);

        translate([0, l, 0])
          rotate([90, 0, 0])
          cylinder(d=20, h=l);
      }
    // end can_shape
  }

  // Metal casing
  color("gray") {
    can_shape(20);

    rotate([90, 0, 0])
      cylinder(d=6, h=2);
  }

  // Plastic white
  color("white") {
    translate([0, 20, 0]) {
      // Rear housing
      difference() {
        can_shape(5);
        translate([9, 6, 0])
          union() {
            rotate([90, 0, 0])
            cylinder(d=3, h=7);
            translate([0, -7, -1.5])
            cube([1.5, 7, 3]);
          };

        // Side cuts for casing tabs
        translate([-9, 6, 0])
          union() {
            rotate([90, 0, 0])
            cylinder(d=3, h=7);
            translate([-1.5, -7, -1.5])
            cube([1.5, 7, 3]);
          };
      }

      // Top bar and contacts
      translate([-8.5, 0, 7.5])
        cube([17, 5, 2]);

      // Rear protrusion
      translate([0, 5, 0])
        difference() {
        translate([0, 2, 0])
          rotate([90, 0, 0])
          cylinder(d=10, h=2);
        translate([-6, -1, -5])
          cube([12, 4, 2]);
      }

    }

    // end plastic white
  }

  // Spindle
  color("silver") {
    // Front
    translate([0, -2, 0])
      rotate([90, 0, 0])
      cylinder(d=spindle_d, h=8);

    // Rear
    translate([0, 28, 0])
      rotate([90, 0, 0])
      cylinder(d=spindle_d, h=2);
  }

  // end dc130
}
