
$debug = ($preview) ? true : false;

function tj_tap(s, o) = let (nothing = [ for (i = [1:1]) if ($debug) echo(str(s, ": ", o)) ]) o;

module tj_mark(x, y, z=undef, t="", color=RED, d=0.25) {
  if ($debug) {
    if (z==undef) {
      color(color)
        translate([x, y])
        circle(d=d);

      if (t)
        echo(t, x=x, y=y);
    } else {
      color(color)
        translate([x, y, z])
        sphere(d=d);
      if (t)
        echo(t, x=x, y=y, z=z);
    }
  }
}
