/*
Command line config settings, for the key type, overridden by generate.bat

The below default values are for Schlage.
*/
tab_side = "right"; // [ left,right]
zero_cut_root_depth = 8.509;
depth_step = 0.381;
pin_1_from_shoulder = 5.86;
total_depths = 10; //1:10
draw_all = false;
depth_index = 9;
zero_cut_number = 0;

/*
Additional command line settings if generating wide version.
*/
wide_mode = false;
pin_spacing = 3.96;
total_pins = 6;

// Lishi pliers dimensions.
lishi_socket_width = 18 + 0.3;  // 0.3 from my printer, you may need to tweak.
lishi_socket_height = 5;
lishi_socket_length = 10;
lishi_lip_length = 2;
lishi_lip_thickness = 1.2;
lishi_socket_punch_length = 13.415;  // Tip of punch to end of lishi.

// Guide config.
$fn = 30;
walls = 1;
key_slot_width = 2.25;
cover_overlap = 2.14;
aligner_inset = 1;

// Derived dimensions
guide_back_width = lishi_socket_width + walls*2;
guide_back_length = lishi_socket_length + walls*2;
guide_back_height = lishi_socket_height + lishi_lip_thickness;

guide_front_length = lishi_socket_punch_length + walls*2 - zero_cut_root_depth + ((total_depths-1) * depth_step) + cover_overlap;
guide_front_height = key_slot_width + walls*2;
guide_front_width = guide_back_width / 2 + pin_1_from_shoulder;

lip_width = guide_back_width;

guide_back_wing_width = guide_front_width+(pin_spacing*(total_pins-1))+walls*3 - guide_back_width;
guide_back_wing_length = guide_back_length + zero_cut_root_depth + 5;
shoulder_line = aligner_inset / 3;

mirror_tab = tab_side == "right";

if (draw_all) {
	for (depth_index=[zero_cut_number:zero_cut_number+total_depths-1]) {
		translate([0,15*depth_index,0])
			guide(depth_index);
	}
}
else {
	guide(depth_index);
}

module guideback (){
        // Guide back - clips to Lishi pliers.
        translate([-walls, 0, -walls*2]) difference() {
            union() {
                cube([guide_back_width, guide_back_height, guide_back_length]);
                if (wide_mode) {
                    translate([guide_back_width-walls, 0, 0]) cube([guide_back_wing_width, walls*2, guide_back_wing_length]);
                }
            }

            translate([walls,lishi_lip_thickness,walls*2]) cube([lishi_socket_width, guide_back_height, guide_back_length]);
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
        for (i = [1 : total_pins-1]){
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
    translate([-5, -key_slot_width, bar_push]) cube([lishi_socket_width*2, key_slot_width+1, 30]);
}

module number(depth_index) {
    // Number.
    translate([guide_front_width/2, -guide_front_height+0.5, 2]) rotate([-90, 0, 180]) {
        mirror([mirror_tab ? 1 : 0, 0, 0]) linear_extrude(1) text(str(depth_index+zero_cut_number), size=6, font="Arial", halign="center", valign="top");
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

