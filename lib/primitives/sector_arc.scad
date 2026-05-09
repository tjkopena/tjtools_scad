use <lib/debug.scad>

module s_sector(radius, start, stop, fn=120) {
  r = radius*2;
  step = tj_tap("Step", 360/fn);

  points = [[0, 0],
            for (a = [start : step : stop])
              [r*cos(a)+1, r*sin(a)+1],
                [r*cos(stop)+1, r*sin(stop)+1]
            ];

  intersection() {
    circle(radius, $fn=fn);
    polygon(points);
  }

  // end s_sector
}

module s_arc(radius, angles, width = 1, fn = 24) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
}
