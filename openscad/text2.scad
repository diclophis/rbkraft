difference() {
	difference() {
		difference() {
		    difference() {
		        cube(100, center = true);
		        translate([0, 0, 0]) { cube(99, center = true); };
		    };
		    scale([0.1, 1.9, 0.1]) { cube(100, center = true); };
		};
	        scale([0.1, 0.1, 1.9]) { cube(100, center = true); };
	};
    	scale([1.9, 0.1, 0.1]) { cube(100, center = true); };
};
