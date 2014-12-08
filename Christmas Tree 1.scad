// points = number of points (minimum 3)
// outer  = radius to outer points
// inner  = radius to inner points
module star(points, outer, inner) {
  // polar to cartesian: radius/angle to x/y
	function x(r, a) = r * cos(a);
	function y(r, a) = r * sin(a);
	
	// angular width of each pie slice of the star
	increment = 360/points;
	
	translate([0, 0, -8.5])
	union() {
		for (p = [0 : points-1]) {
			
			// outer is outer point p
			// inner is inner point following p
			// next is next outer point following p
			rotate([0, 90, 0])
			assign(	
               x_outer = x(outer, increment * p),
					y_outer = y(outer, increment * p),
					x_inner = x(inner, (increment * p) + (increment/2)),
					y_inner = y(inner, (increment * p) + (increment/2)),
					x_next  = x(outer, increment * (p+1)),
					y_next  = y(outer, increment * (p+1))) {
				polygon(
				  points = [
               [x_outer, y_outer], 
               [x_inner, y_inner], 
               [x_next, y_next], 
               [0, 0]
             ], 
             paths = [
               [0, 1, 2, 3]
             ]
           );
			}
		}
	}
}

/**
 * @param swirl_count How many 360 branches does the tree have
 * @param z_translate_step How tight are the gaps between swirls
 * @param leaf_depth_step How much do the branches extend depth
 * @param leaf_height_step How much do the branches extend height
 * @param globe_frequncy How often should we generate a new globe
 * @param globe_radius How large should the globes be 
 */
module tree(
  swirl_count = 7,
  z_translate_step = .03,
  leaf_depth_step = .012,
  leaf_height_step = .002,
  globe_frequency = 5,
  globe_radius = 3
) {
  union() {
    for (swirl = [0:swirl_count]) { 
      for (x = [1:360]) {
        assign(
          current_z = (swirl * 360 * z_translate_step) + (x * z_translate_step),
          z_offset = swirl * 360 * z_translate_step,
          leaf_size = [
            1, 
            leaf_depth_step * x + (swirl * 360 * leaf_depth_step), 
            leaf_height_step * x + (swirl * 360 * leaf_height_step)
          ],
          last_leaf_size = [
            1, 
            leaf_depth_step + (swirl * 360 * leaf_depth_step), 
            leaf_height_step + (swirl * 360 * leaf_height_step)
          ],
          has_globe = x % (360 / globe_frequency) == 0
        ) {
          if (swirl < swirl_count) {
            rotate(x)
            translate([0, 0, current_z])
            color([0, rands(.5, .8, 1)[0],0])
            cube(leaf_size, center = false);  
            if (has_globe
                && swirl > 0 
                && swirl < swirl_count -1
            ) {
              translate([0, 0, current_z])
              rotate(x)
              translate([
                leaf_size[1], 
                0, 
                0
              ]) 
              color("Red")
              sphere(3);  
            };                    
          } else {
            translate([0, 0, z_offset])
    	      rotate([0, 0, x])
            color([0, rands(.5, .8, 1)[0],0])
            cube(last_leaf_size, center = false); 
          }
        }
      }
   }
    children();
  }
}

$fn = 100;
tree() {
  color("Olive")
  cylinder(80, .7, 1);
  translate([0, 0, 5])	
  color("Yellow") 
  star(6, 6, 2.5);
}