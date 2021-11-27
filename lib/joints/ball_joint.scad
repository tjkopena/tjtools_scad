module tj_balljoint_socket(ball_d=15, wall_th=1.6, f=3, lip=0.5, cut=4, arms=4, stem_angle=75, tol=$tol) {

  // Shell dimensions
  id = ball_d + tol*2;
  od = id + wall_th*2;

  // (cx, cy) center of shell
  cx = 0;
  cy = od/2;

  echo("TJ Ball Joint Socket", ball_d=ball_d, wall_th=wall_th, id=id, od=od, f=f, lip=lip, cut=cut, hy=hy, tol=tol);

  // (tx, ty) point on outer shell tangent to stem_angle
  tx = cos(stem_angle-90)*od/2 + cx;
  ty = sin(stem_angle-90)*od/2 + cy;

  // (vx, vy) stem vector
  vx = cos(stem_angle); // = (tx-cx)/(od/2)
  vy = sin(stem_angle); // = (ty-cy)/(od/2)

  // (ox, oy) where stem vector to (tx, ty) crosses x-axis
  ox = vx*(-ty/vy) + tx;
  oy = 0;

  // _f fillet radius
  _f = f/2;

  // (fffx, ffy) where to place fillet between outer shell and baseplate
  fy = _f;
  ffy = sin(stem_angle+90)*_f + fy;
  ffx = vx*((ffy - ty)/vy) + tx;
  fffx = ffx + cos(stem_angle-90)*_f;

  module _outercurve() {
    translate([cx, cy])
      circle(d=od);

    polygon([[ox, oy],
             [tx, ty],
             [0, ty],
             [0, 0],
             [tx, 0]]);

    difference() {
      square([fffx, ffy]);
      translate([fffx, _f])
        circle(d = f);
    }
  }

  // (rx, ry) where on inner shell to start cutting top off
  rx = cx + id/2-lip;
  // rx = cx + id/2*cos(a) = cx + id/2-lip
  //          id/2*cos(a) =      id/2-lip
  //               cos(a) =         1-lip/(id/2)
  //                   a =     acos(1-lip/(id/2))
  a = tj_tap("a", acos(1-lip/(id/2)));
  ry = id/2*sin(a)+cy;
  //tj_mark(rx, ry);

  // (lx, ly) where on outer shell to stop cutting top off
  lx = cx + od/2*cos(a);
  ly = cy + od/2*sin(a);
  //tj_mark(lx, ly);

  // (mx, my) midpoint of line rl, where to place fillet sphere
  mx = (lx+rx)/2;
  my = (ly+ry)/2;
  //tj_mark(mx, my);

  // (hx, hy) highest point of shape
  hx = mx + (wall_th/2)*cos(90);
  hy = my + (wall_th/2)*sin(90);

  module _profile() {
    difference() {
      _outercurve();

      // Remove left half
      translate([-od/2-1, -1])
        square([od/2+1, od+2]);

      // Remove top
      polygon([
               [cx, cy],
               [lx, ly],
               [lx, od+1],
               [cx-$ep, od+1],
               [cx-$ep, cy]
               ]);

      // Remove center
      translate([0, od/2])
        circle(d=id);
    }

    translate([mx, my])
      circle(d=wall_th);
  }

  module _armcuts() {

    translate([0, 0, ty])
      for (a = [0:(360/arms):360-1]) {
      rotate(a) {
        translate([0, -cut/2, cut/2])
          cube([od/2+1, cut, hy-cut/2+1]);
        translate([0, 0, cut/2])
          rotate([0, 90, 0])
          cylinder(d=cut, h=od/2+1);
      }

    }

  }

  difference() {
    rotate_extrude()
      _profile();

    _armcuts();
  }

}

module tj_balljoint_ball(ball_d=15, stem=1, stem_angle=60, f=3, tol=$tol) {

  // Shell dimensions
  od = ball_d; // Intentionally no subtraction of tol*2

  // (cx, cy) center of shell
  cx = 0;
  cy = od/2 + stem;
  hy = od + stem;

  echo("TJ Ball Joint Ball", ball_d=ball_d, od=od, f=f, hy=hy, tol=tol);

  // (tx, ty) point on outer shell with 60 degree tangent
  tx = cos(stem_angle-90)*od/2 + cx;
  ty = sin(stem_angle-90)*od/2 + cy;

  // (vx, vy) 60 degree vector
  vx = cos(stem_angle); // = (tx-cx)/(od/2)
  vy = sin(stem_angle); // = (ty-cy)/(od/2)

  // (ox, oy) stem outer wall vector to (tx, ty) crosses x-axis
  ox = vx*(-ty/vy) + tx;
  oy = 0;

  // _f fillet radius
  _f = f/2;

  // (fffx, ffy) where to place fillet between outer shell and baseplate
  fy = _f;
  ffy = sin(stem_angle+90)*_f + fy;
  ffx = vx*((ffy - ty)/vy) + tx;
  fffx = ffx + cos(stem_angle-90)*_f;

  module _outercurve() {
    translate([cx, cy])
      circle(d=od);

    polygon([[ox, oy],
             [tx, ty],
             [0, ty],
             [0, 0],
             [tx, 0]]);

    difference() {
      square([fffx, ffy]);
      translate([fffx, _f])
        circle(d = f);
    }
  }

  module _profile() {
    difference() {
      _outercurve();

      // Remove left half
      translate([-od/2-1, -1])
        square([od/2+1, hy+2]);
    }
  }

  rotate_extrude()
    _profile();

}
