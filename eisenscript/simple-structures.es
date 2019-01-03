// simple structures

#define a_bit_smaller 0.5
#define a_bit_more 1.5
#define flat 1
#define about_this_wide 20
#define between_each_side 60
#define a_bunch 5

1 * { s a_bit_smaller x between_each_side y between_each_side/2 }
a_bunch * { x between_each_side } big_flat_box

1 * { s a_bit_smaller }
a_bunch * { x between_each_side } planks_with_changing_rotation

rule planks_with_changing_rotation maxdepth 60 {
  { y a_bit_more rz -2.95 } planks_with_changing_rotation small_wide_plank
}

rule small_wide_plank {
  { s a_bit_smaller flat about_this_wide } box
}

rule big_flat_box {
  { x -between_each_side/2 s between_each_side flat about_this_wide } box
}
