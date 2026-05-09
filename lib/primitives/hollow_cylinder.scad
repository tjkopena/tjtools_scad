module s_hollow_cylinder(od, id, h, axis="x", arc=undef) {

  a = (arc==undef) ? [0,360] : ((len(arc)==0)?[0,arc]:arc);
  echo(a);

  difference() {
    cylinder(d=od, h=h);
    translate([0, 0, -1])
      cylinder(d=id, h=h+2);
  }

}

module s_hollow_cone(d1, d2, h) {
  difference() {
    cylinder(d1=d1, d2=d2, h=h);
    translate([0, 0, -1])
      cylinder(d=d2, h=h+2);
  }
}
