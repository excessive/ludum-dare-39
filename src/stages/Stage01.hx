package stages;

import components.*;
import math.Vec3;
import math.Quat;

class Stage01 {
	public static function init(): StageInfo {
		var waves: Array<Array<Entity>> = [
			// Wave 1
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  3,
						iframe: false,
						speed:  10,
						script: Script.straight_down_slow
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(0, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 2
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.straight_down_slow
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(5, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.straight_down_slow
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-5, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 3
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.straight_down_slow
					},
					emitter: [
						Emit.make(Emit.galaxy)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(5, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  2,
						iframe: false,
						speed:  10,
						script: Script.straight_down_fast
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-5, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 4
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.zig_zag_left
					},
					emitter: [
						Emit.make(Emit.fast_spiral_l)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  5,
						iframe: false,
						speed:  10,
						script: Script.zig_zag_right
					},
					emitter: [
						Emit.make(Emit.spiral_r)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 5
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.sweep_left
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  3,
						iframe: false,
						speed:  10,
						script: Script.sweep_right
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 6
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.back_and_forth
					},
					emitter: [
						Emit.make(Emit.galaxy)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(3, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},		
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.back_and_forth_r
					},
					emitter: [
						Emit.make(Emit.galaxy)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-3, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 7
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.pause_right_1
					},
					emitter: [
						Emit.make(Emit.pause_c)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0.5,
						iframe: false,
						speed:  10,
						script: Script.pause_right_2
					},
					emitter: [
						Emit.make(Emit.pause_c)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  1,
						iframe: false,
						speed:  10,
						script: Script.pause_right_3
					},
					emitter: [
						Emit.make(Emit.pause_r)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 8
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.pause_left_1
					},
					emitter: [
						Emit.make(Emit.pause_c)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0.5,
						iframe: false,
						speed:  10,
						script: Script.pause_left_2
					},
					emitter: [
						Emit.make(Emit.pause_c)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  1,
						iframe: false,
						speed:  10,
						script: Script.pause_left_3
					},
					emitter: [
						Emit.make(Emit.pause_r)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 9
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.straight_left_fast
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-11, -3, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0.5,
						iframe: false,
						speed:  10,
						script: Script.straight_right_fast
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(11, 3, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  2,
						iframe: false,
						speed:  10,
						script: Script.straight_down_fast
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(0, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 10 - Blossom
			[
				{
					enemy: {
						id:     Blossom,
						attach: [],
						hp:     500000,
						max_hp: 500000,
						alive:  true,
						delay:  0,
						iframe: true,
						speed:  10,
						script: Script.blossom_intro
					},
					emitter: [
						Emit.make(Emit.galaxy),
						Emit.make(Emit.fast_galaxy_l),
						Emit.make(Emit.fast_galaxy_r),
						Emit.make(Emit.thorn),
						Emit.make(Emit.sakura_l),
						Emit.make(Emit.sakura_r)
					],
					drawable: new Drawable("assets/models/blossom.iqm"),
					transform: new Transform(new Vec3(0, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 11
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.straight_down_slow
					},
					emitter: [
						Emit.make(Emit.galaxy)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(5, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  2,
						iframe: false,
						speed:  10,
						script: Script.straight_down_fast
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-5, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 12
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.zig_zag_left
					},
					emitter: [
						Emit.make(Emit.fast_spiral_l)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  5,
						iframe: false,
						speed:  10,
						script: Script.zig_zag_right
					},
					emitter: [
						Emit.make(Emit.spiral_r)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 13
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  5,
						iframe: false,
						speed:  10,
						script: Script.straight_down_slow
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(0, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 14
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.sweep_left
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  3,
						iframe: false,
						speed:  10,
						script: Script.sweep_right
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 15
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.straight_down_slow
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(5, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.straight_down_slow
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-5, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 16
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.pause_left_1
					},
					emitter: [
						Emit.make(Emit.pause_c)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0.5,
						iframe: false,
						speed:  10,
						script: Script.pause_left_2
					},
					emitter: [
						Emit.make(Emit.pause_c)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  1,
						iframe: false,
						speed:  10,
						script: Script.pause_left_3
					},
					emitter: [
						Emit.make(Emit.pause_r)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 17
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.straight_left_fast
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-11, -3, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0.5,
						iframe: false,
						speed:  10,
						script: Script.straight_right_fast
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(11, 3, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  2,
						iframe: false,
						speed:  10,
						script: Script.straight_down_fast
					},
					emitter: [
						Emit.make(Emit.pulse)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(0, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 18
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.back_and_forth
					},
					emitter: [
						Emit.make(Emit.galaxy)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(3, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},		
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.back_and_forth_r
					},
					emitter: [
						Emit.make(Emit.galaxy)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(-3, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			],

			// Wave 19
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0,
						iframe: false,
						speed:  10,
						script: Script.pause_right_1
					},
					emitter: [
						Emit.make(Emit.pause_c)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  0.5,
						iframe: false,
						speed:  10,
						script: Script.pause_right_2
					},
					emitter: [
						Emit.make(Emit.pause_c)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				},
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  1,
						iframe: false,
						speed:  10,
						script: Script.pause_right_3
					},
					emitter: [
						Emit.make(Emit.pause_r)
					],
					drawable: new Drawable("assets/models/bear.iqm"),
					transform: new Transform(new Vec3(7, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit:  [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			]
		];

		var boss: Entity = {
			enemy: {
				id:     Rose,
				attach: [],
				hp:     750000,
				max_hp: 750000,
				alive:  true,
				delay:  0,
				iframe: true,
				speed:  10,
				script: Script.rose_intro
			},
			emitter: [
				Emit.make(Emit.fast_galaxy_l),
				Emit.make(Emit.fast_galaxy_r),
				Emit.make(Emit.thorn),
				Emit.make(Emit.rose_l),
				Emit.make(Emit.rose_r)
			],
			drawable: new Drawable("assets/models/rose.iqm"),
			transform: new Transform(new Vec3(0, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
			capsules: {
				push: [],
				hit:  [],
				hurt: [
					new BoneCapsule(null, 1.5, 0.5)
				]
			}
		} 

		return {
			waves: waves,
			boss:  boss
		};
	}
}
