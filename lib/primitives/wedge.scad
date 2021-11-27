module tj_wedge(dim, plane="xy", flip="") {

  module _(x, y, z, fl) {
    pol =
      (fl=="x") ? [[0, 0], [x, y], [x, 0]] :
      (fl=="y") ? [[0, 0], [x, y], [0, y]] :
      (fl=="xy" || flip=="yx") ? [[x, y], [0, y], [x, 0]] :
      [[0, 0], [x, 0], [0, y]];
    linear_extrude(height=z)
      polygon(points=pol);
  }

  if (plane=="xy" || plane=="yx") {
    _(dim[0], dim[1], dim[2], flip);

  } else if (plane=="xz" || plane=="zx") {
    fl =
      (flip=="z") ? "y" :
      (flip=="xz"||flip=="zx") ? "xy" :
      flip;
    translate([0, dim[1], 0])
      rotate([90, 0, 0])
      _(dim[0], dim[2], dim[1], fl);

  } else if (plane=="yz" || plane=="zy") {
    fl =
      (flip=="z") ? "x" :
      (flip=="yz"||flip=="zy") ? "xy" :
      flip;
    translate([dim[0], 0, 0])
      rotate([0, -90, 0])
      _(dim[2], dim[1], dim[0], fl);
  }

  // end tj_wedge
}
