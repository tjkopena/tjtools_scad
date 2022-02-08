$fn = $preview ? 30 : 120;
$debug = $preview;

$tol = 0.25;
$ep = .001;

include <lib/units.scad>
include <lib/colors.scad>
include <lib/debug.scad>

include <lib/primitives/wedge.scad>
include <lib/primitives/hollow_cylinder.scad>
include <lib/primitives/screws.scad>

include <lib/LEGO.scad>

include <lib/joints/ball_joint.scad>
