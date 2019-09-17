// simple set of instructions

#define a_bit_smaller 0.75
#define a_bit_more 1.55
#define flat 0.9
#define about_this_wide 20
#define between_each_side 60
#define a_bunch 3

1 * { y between_each_side/2 }
a_bunch * { x between_each_side } big_flat_box

a_bunch * { x between_each_side } planks_with_changing_rotation

rule planks_with_changing_rotation maxdepth between_each_side {
  { y a_bit_more rz -180/between_each_side } planks_with_changing_rotation small_wide_plank
}

rule small_wide_plank {
  { s a_bit_smaller flat about_this_wide } box
}

rule big_flat_box {
  { x between_each_side/2 s between_each_side flat about_this_wide } box
}
