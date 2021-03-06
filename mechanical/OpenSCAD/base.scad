include <inputs.scad>
include <calcs.scad>

use <sidewalls.scad>

module base_piece()
{
    difference()
    {
        square(size = [robot_width, robot_width], center = true);
        square(size = [robot_width - 2*storage_size, robot_width - 2*storage_size], center = true);
        
        
        translate(v = [-robot_width/2+thickness/2, -robot_width/2, 0])
            notchIn(robot_width);
        
        rotate([0, 0, 90])
        translate(v = [-robot_width/2+thickness/2, -robot_width/2, 0])
            notchIn(robot_width);
        
        rotate([0, 0, 180])
        translate(v = [-robot_width/2+thickness/2, -robot_width/2, 0])
            notchIn(robot_width);
        
        rotate([0, 0, 270])
        translate(v = [-robot_width/2+thickness/2, -robot_width/2, 0])
            notchIn(robot_width);
    }
}

module teeth()
{
    // top and bottom
    for (ii = [-1, 1])
    {
        for (jj = [(-floor(robot_width/2/block_width/2)):2:(floor(robot_width/2/block_width/2))])
        {
            translate(v = [jj*block_width*2, ii*(robot_width/2+thickness/2), 0])                
            {
                if (!(jj == 0 && ii == 1))
                    square(size = [block_width+tol, thickness+tol], center = true);
            }
        }
    }
    
    // left and right
    for (ii = [-1, 1])
    {
        for (jj = [(-floor(robot_width/2/block_width/2)):2:(floor(robot_width/2/block_width/2))])
        {
            translate(v = [ii*(robot_width/2+thickness/2), jj*block_width*2, 0])                
            {
                square(size = [thickness+tol, block_width+tol], center = true);
            }
        }
    }
}

module jigsaw_cuts()
{
    for (ii = [-1, 1])
    {
        for (jj = [2:2:floor(storage_size/block_width)-1])
        {
            translate (v = [ii*(robot_width/2-jj*block_width+block_width/2), (robot_width - 2*storage_size-thickness-2*tol)/2, 0])
            {
                square(size = [block_width+tol, thickness+2*tol], center = true);
            }
        }
    }
    
    for (ii = [-1, 1])
    {
        for (jj = [2:2:floor(storage_size/block_width)-1])
        {
            translate (v = [ii*(robot_width/2-jj*block_width+block_width/2), -(robot_width - 2*storage_size-thickness-2*tol)/2, 0])
            {
                square(size = [block_width+tol, thickness+2*tol], center = true);
            }
        }
    }
    
    for (ii = [-1, 1])
    {
        for (jj = [2:2:floor(storage_size/block_width)-1])
        {
            translate (v = [(robot_width - 2*storage_size-thickness-2*tol)/2, ii*(robot_width/2-jj*block_width+block_width/2), 0])
            {
                square(size = [thickness+2*tol, block_width+tol], center = true);
            }
        }
    }
    
    for (ii = [-1, 1])
    {
        for (jj = [2:2:floor(storage_size/block_width)-1])
        {
            translate (v = [-(robot_width - 2*storage_size-thickness-2*tol)/2, ii*(robot_width/2-jj*block_width+block_width/2), 0])
            {
                square(size = [thickness+2*tol, block_width+tol], center = true);
            }
        }
    }
}

module mount_holes()
{
    hull()
    {
        translate(v = [mount_mount_hole_offset_w, mount_length/2-mount_mount_hole_offset_from_back, 0])
            #circle(d = mount_mount_hole_d, center = true);
        translate(v = [mount_mount_hole_offset_w, mount_length/2-mount_mount_hole_offset_from_back-mount_mount_hole_differential, 0])
        #circle(d = mount_mount_hole_d, center = true);
    }

    hull()
    {
        translate(v = [-mount_mount_hole_offset_w, mount_length/2-mount_mount_hole_offset_from_back, 0])
            #circle(d = mount_mount_hole_d, center = true);
        translate(v = [-mount_mount_hole_offset_w, mount_length/2-mount_mount_hole_offset_from_back-mount_mount_hole_differential, 0])
        #circle(d = mount_mount_hole_d, center = true);
    }
}

module base()
{
    difference()
    {
        base_piece();
        jigsaw_cuts();
        // wire holes
        translate(v = [-(shaft_width/2 + 3/4*wire_hole), 0, 0])
        {
            circle(d = wire_hole);
        }
        translate(v = [(shaft_width/2 + 3/4*wire_hole), 0, 0])
        {
            circle(d = wire_hole);
        }
        
        // servo_hole
        translate(v = [0, (robot_width - storage_size)/2, 0])
        {
            square(size = [storage_size/4,storage_size], center = true);
        }
        
        // 4 MM FUDGE FACTOR
        // mount holes
        for (ii = [-1, 1])
        {
            for (jj = [-1, 1])
            {
                translate(v = [ii*(robot_width/2-wheel_d/2 - 4), jj*(robot_width/2-mount_depth-wheel_w-wheel_out+mount_mount_hole_offset_from_back+mount_mount_hole_differential/2-mount_mount_hole_d ), 0])
                {
                    mount_holes();
                }
            }
        }
        
        for (ii = [-1, 1])
        {
            translate(v = [ii*(robot_width/2-wheel_d/2 - 4), 0, 0])
            {
                mount_holes();
            }
        }
        
        translate(v = [0, 1/4*shaft_width, 0])
        {
            circle(d=shaft_width);
        }
        
        //backboard_clearance
        translate(v = [-(shaft_width/2 - 3/2*backboard_clearance), shaft_width/2+thickness, 0])
            notchIn(storage_size);
    }
    //teeth();
    
    
}

module backboard()
{
    square(size = [shaft_width, storage_size], center = true);
    translate(v = [shaft_width/2+thickness/2, -storage_size/2, 0])
        notchOut(storage_size);
    translate(v = [shaft_width/2+thickness, -storage_size/2, 0])
        notchOut(storage_size);
}

module bumper()
{
    h = 2*cu;
    difference()
    {
        union()
        {
            square(size = [h,robot_width], center = true);
            translate(v = [h/2+base_thickness/2,-robot_width/2])
                scale(v = [base_thickness/thickness, 1])
                    notchOut(robot_width);
            
            translate(v = [-h/2, robot_width/2+thickness/2])
                rotate([0, 0, -90])
                    notchOut(h);
            
            translate(v = [-h/2, -robot_width/2-thickness/2])
                square(size = [h, thickness]);
        }
        translate(v = [-h/2, -robot_width/2-thickness/2])
                rotate([0, 0, -90])
                    notchIn(h);
    }
}

module frontBumper()
{
    difference()
    {
        bumper();
        square(size = [1000,robot_width-2*wheel_d], center = true);
    }
}

// 16 mm circles, 42 mm apart
module dist()
{
    translate(v = [0, -(42-16)/2])
        circle(d = 17);
    translate(v = [0, (42-16)/2])
        circle(d = 17);
}

//46 mm wide

module distx2Bumper()
{
    difference()
    {
        bumper();
        translate(v = [-0.5*cu, (4.25*cu-46)/2])
            dist();
        translate(v = [-0.5*cu, -(4.25*cu-46)/2])
            dist();
    }
}

module distx1Bumper()
{
    difference()
    {
        bumper();
        translate(v = [-0.5*cu, 0])
            dist();
    }
}

*base();
*backboard();
bumper();
*frontBumper();
*distx1Bumper();
//*distx2Bumper();