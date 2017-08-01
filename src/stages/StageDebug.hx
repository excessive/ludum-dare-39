package stages;

import components.*;
import math.Vec3;
import math.Quat;

class StageDebug {
	public static function init(): StageInfo {
		var waves: Array<Array<Entity>> = [
			[
				{
					enemy: {
						id:     Trash,
						attach: [],
						hp:     1,
						max_hp: 1,
						alive:  true,
						delay:  2,
						iframe: false,
						speed:  9,
						script: Script.debug
					},
					emitter: [
						Emit.make(Emit.galaxy)
					],
					drawable: new Drawable("assets/models/player.iqm"),
					transform: new Transform(new Vec3(-8, -5, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit: [],
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
						speed:  9,
						script: Script.debug
					},
					emitter: [
						Emit.make(Emit.galaxy)
					],
					drawable: new Drawable("assets/models/blossom.iqm"),
					transform: new Transform(new Vec3(-4, -5, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit: [],
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
						speed:  9,
						script: Script.debug
					},
					emitter: [
						Emit.make(Emit.galaxy)
					],
					drawable: new Drawable("assets/models/lily.iqm"),
					transform: new Transform(new Vec3(0, -5, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit: [],
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
						speed:  9,
						script: Script.debug
					},
					emitter: [
						Emit.make(Emit.galaxy)
					],
					drawable: new Drawable("assets/models/iris.iqm"),
					transform: new Transform(new Vec3(4, -5, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit: [],
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
						speed:  9,
						script: Script.debug
					},
					emitter: [
						Emit.make(Emit.galaxy)
					],
					drawable: new Drawable("assets/models/rose.iqm"),
					transform: new Transform(new Vec3(8, -5, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
					capsules: {
						push: [],
						hit: [],
						hurt: [
							new BoneCapsule(null, 1.5, 0.5)
						]
					}
				}
			]
		];

		var boss: Entity = {
			enemy: {
				id:     Blossom,
				attach: [],
				hp:     10000,
				max_hp: 10000,
				alive:  true,
				delay:  3,
				iframe: true,
				speed:  9,
				script: Script.blossom_intro
			},
			emitter: [
				Emit.make(Emit.galaxy),
				Emit.make(Emit.sakura_l),
				Emit.make(Emit.sakura_r)
			],
			drawable: new Drawable("assets/models/blossom.iqm"),
			transform: new Transform(new Vec3(0, -11, 0), new Vec3(), Quat.from_angle_axis(Math.PI, Vec3.up())),
			capsules: {
				push: [],
				hit: [],
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
