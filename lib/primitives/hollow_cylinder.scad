module s_hollow_cylinder(od, id, h, axis="x", arc=undef) {

  a = (arc==undef) ? [0,360] : ((len(arc)==0)?[0,arc]:arc);
  echo(a);

  difference() {
    cylinder(d=od, h=h);
    translate([0, 0, -1])
      cylinder(d=id, h=h+2);
  }
}
