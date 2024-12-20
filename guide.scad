/*
Command line config settings, for the key type, overridden by generate.bat

The below default values are for Schlage.
*/
/* [Key system] */
// Metric or Imperial
Dimension_modifier=25.4; // [1:Metric,25.4:Imperial]
// Depth of first/zero cut
DOFC=0.335; // 0.0001
// Change in length between consecutive pin sizes
Depth_increment=0.015; //0.0001
// Number of different sized pins
Number_of_cut_depths = 10; //1:10
// Usually 0 or 1
First_cut_designation = 0;
// Number of positions on a key
Max_key_positions = 6;
// Shoulde to pin one (To First Cut)
TFC = 0.231; //0.0001
// Pin spacing (Between Cut Centres)
BCC = 0.156; //0.0001
// Effective Plug Diameter
EPD=0.500; // 0.0001

/* [Lishi plier dimensions] */
lishi_socket_width = 18; // 0.01
lishi_socket_height = 5; // 0.01
lishi_socket_length = 10; // 0.01
lishi_lip_length = 2; // 0.01
lishi_lip_thickness = 1.2; // 0.01
lishi_socket_punch_length = 13.415; //0.001  // Tip of punch to end of lishi.

/* [Guide config] */
tab_side = "left"; // [ left,right]
guide_to_render = -1; // [-1:all,0,1,2,3,4,5,6,7,8,9,10]
wide_mode = false;
// Width of the walls of the guide
walls = 1;
key_slot_width = 2.25; // 0.01
cover_overlap = 2.14; // 0.01
aligner_inset = 1;

/* [Printer and rendering config] */
printer_allowance = 0.3;
// Expressed as a power of 2 (e.g. 5 here is 32)
Rendering_complexity = 5; //2:10

// Derived dimensions
zero_cut_root_depth = Dimension_modifier * DOFC;
depth_step = Dimension_modifier * Depth_increment;
pin_1_from_shoulder = Dimension_modifier * TFC;
pin_spacing = Dimension_modifier * BCC;
echo("DOFC: ",zero_cut_root_depth);
echo("Depth Increment: ",depth_step);
echo("TFC: ",pin_1_from_shoulder);
echo("BCC: ",pin_spacing);

lishi_socket_width_w_allowance = lishi_socket_width + printer_allowance;
guide_back_width = lishi_socket_width_w_allowance + walls*2;
guide_back_length = lishi_socket_length + walls*2;
guide_back_height = lishi_socket_height + lishi_lip_thickness;

guide_front_length = lishi_socket_punch_length + walls*2 - zero_cut_root_depth + ((Number_of_cut_depths-1) * depth_step) + cover_overlap;
guide_front_height = key_slot_width + walls*2;
guide_front_width = guide_back_width / 2 + pin_1_from_shoulder;

lip_width = guide_back_width;
guide_back_wing_width = guide_front_width+(pin_spacing*(Max_key_positions-1))+walls*3 - guide_back_width;
guide_back_wing_length = guide_back_length + zero_cut_root_depth + 5;
shoulder_line = aligner_inset / 3;

echo("Walls:",walls);
echo("Lishi socket length:",lishi_socket_length);
echo("Lip Width: ",lip_width);
echo("Lishi Lip thickness:",lishi_lip_thickness);
echo("Lishi Lip Lengtyh:",lishi_lip_length);

// Derived variables
$fn = pow(2,Rendering_complexity);
mirror_tab = tab_side == "right";

if (guide_to_render==-1) {
	for (depth_index=[First_cut_designation:First_cut_designation+Number_of_cut_depths-1]) {
		translate([0,15*(depth_index-First_cut_designation),0])
			guide(depth_index);
	}
}
else {
	guide(guide_to_render);
}


module guideback() {
	// Guide back - clips to Lishi pliers.
	translate([-walls, 0, -walls*2]) difference() {
		union() {
			cube([guide_back_width, guide_back_height, guide_back_length]);
			if (wide_mode) {
				translate([guide_back_width-walls, 0, 0]) cube([guide_back_wing_width, walls*2, guide_back_wing_length]);
			}
		}

		translate([walls,lishi_lip_thickness,walls*2]) cube([lishi_socket_width_w_allowance, guide_back_height, guide_back_length]);
	}
}

module lip() {
	// Lip.
	translate([-walls, 0, lishi_socket_length]) {
		cube([lip_width, lishi_lip_thickness, lishi_lip_length-lishi_lip_thickness]);
		difference() {
			translate([0, 0, lishi_lip_length-lishi_lip_thickness]) {
				rotate([0, 90, 0]) cylinder(h=lip_width, r=lishi_lip_thickness);
			}
			mirror([0, 1, 0]) translate([-1, 0, -lishi_lip_thickness]) cube([lip_width+2, lishi_lip_thickness+1, lishi_lip_length+lishi_lip_thickness]);
		}
	}
}

module shoulderguides() {
    // Shoulder guides.
    translate([-walls, 0, -walls*2]) if (wide_mode) {
        for (i = [1 : Max_key_positions-1]){
            translate([guide_front_width+(pin_spacing * i), 0, -walls]) {
                cylinder(d=shoulder_line, h=guide_back_wing_length+walls*2);
            }
        }
    }
}

module lowerguide() {
	mirror([mirror_tab ? 1 : 0, 0, 0]) difference() {
		union() {
			guideback();
			lip();
		}
		shoulderguides();
	}
}

module alignment() {
    // Alignment.
    translate([guide_back_width/2, -guide_front_height, guide_front_length]) sphere(r=aligner_inset);
}

module depthbar(depth_index) {
    // Depth bar.
    bar_push = lishi_socket_punch_length - zero_cut_root_depth + (depth_index * depth_step) + walls*2;
    translate([-5, -key_slot_width, bar_push]) cube([lishi_socket_width_w_allowance*2, key_slot_width+1, 30]);
}

module number(depth_index) {
    // Number.
    translate([guide_front_width/2, -guide_front_height+0.5, 2]) rotate([-90, 0, 180]) {
        mirror([mirror_tab ? 1 : 0, 0, 0]) linear_extrude(1) text(str(depth_index), size=6, font="Arial", halign="center", valign="top");
    }
}

module cover(depth_index) {
	// Cover with alignment slot, depth bar and number.
	mirror([mirror_tab ? 1 : 0, 0, 0]) translate([-walls, 0, -walls*2]) difference() {
		mirror([0, 1, 0]) cube([guide_front_width, guide_front_height, guide_front_length]);

		alignment();
		depthbar(depth_index);
		number(depth_index);
	}
}

module guide(depth_index) {
	lowerguide();
	cover(depth_index);
}

