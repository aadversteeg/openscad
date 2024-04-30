$fn=50;

depth = 154;
width = 187;
bottom_height = 80;
top_height = 65;
rounding = 3;
wallthickness = 2;
tolerance = 0.4; // 0.2 tight fit, 0.4 loose fit,
overlap = 3;


bottom_cup(width, depth, bottom_height);


//translate([0,0, 25])
// top_cup(width, depth, top_height, false);

module bottom_cup(widht, depth, height)
{

    difference(){
        
        // basic body
        minkowski(){
            cube([width-2*rounding, depth-2*rounding, height], center=true);
            sphere(rounding);
        }

        // chop off the top
        translate([0,0,height/2]) 
          cube([width+1, depth+1, rounding*2], center = true);  
        
        // hollow out the the body
        minkowski(){
            cube([width - 2* wallthickness-2*rounding, depth- 2* wallthickness-2*rounding, height - 2* wallthickness], center=true);
            sphere(rounding);
        }
     
    }
}


module top_cup(width, depth, height, divider = true)
{

    union(){
        // visible top part
        difference(){
            
            solid_top_cup(width, depth, height);
            
            // hollow out the the body
            translate([0,0, height/2 + wallthickness + rounding])
                minkowski(){
                    cube([width - 2* wallthickness-2*rounding, depth- 2* wallthickness-2*rounding, height], center=true);
                    sphere(rounding);
                }
        }
        

        if (divider)
        {
            // separator
            translate([0, 0, height/2]) rotate([00, -90, 0]) 
                linear_extrude(wallthickness, center = true)
                    difference(){
                        minkowski(){
                            square([height, depth-2 * rounding], center = true);
                            circle(rounding);
                        }
                        
                        translate([-height/2-rounding/2, 0, 0])    
                        square([rounding, depth], center = true);
                    }
        }
    }        
}

module solid_top_cup(width, depth, height)
{
    // basic body
    linear_extrude(height) 
        minkowski(){
            square([width-2*rounding, depth-2*rounding], center = true);
            circle(rounding);
        }
            
    // overlap with bottom part
    translate([0,0, -overlap])
        linear_extrude(overlap) 
            minkowski(){
                square([width- 2* wallthickness-2*rounding, depth- 2* wallthickness-2*rounding], center = true);
                circle(rounding-tolerance/2);
            }
}
