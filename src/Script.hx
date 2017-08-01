import timer.Timer;
import components.*;
import love.math.MathModule as Lm;
import math.Vec3;

typedef MoveInfo = {
	velocity: Vec3,
	time:     Float
}

// THESE ARE ALL BROKEN IN HAXE 4
class Script {
	public static var boss_location: Vec3 = new Vec3(0, -8, 0);
	public static function move(_: Dynamic, e: Entity, to: Vec3): MoveInfo {
		var to   = to != null ? to : new Vec3(Lm.random(-90, 90) / 10, Lm.random(-90, 0) / 10, 0);
		var dist = Vec3.distance(e.transform.position, to);
		var time = dist / e.enemy.speed;
		var dir  = to - e.transform.position;
		dir.normalize();

		return { velocity:dir.scale(e.enemy.speed), time:time };
	}

	/* DEBUG SCRIPT */

	public static function debug(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			wait(9999);
			return debug(_, e, w);
		});
	}

	/* TRASH SCRIPTS */

	public static function straight_down_fast(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			for (em in e.emitter) { em.emitting = true; }

			e.transform.velocity.y = 10;
			wait(2);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function straight_down_slow(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			for (em in e.emitter) { em.emitting = true; }

			e.transform.velocity.y = 5;
			wait(4);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function straight_left_fast(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			for (em in e.emitter) { em.emitting = true; }

			e.transform.velocity.x = 10;
			wait(2);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function straight_left_slow(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			for (em in e.emitter) { em.emitting = true; }

			e.transform.velocity.x = 5;
			wait(4);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function straight_right_fast(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			for (em in e.emitter) { em.emitting = true; }

			e.transform.velocity.x = -10;
			wait(2);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function straight_right_slow(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			for (em in e.emitter) { em.emitting = true; }

			e.transform.velocity.x = -5;
			wait(4);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function zig_zag_left(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			for (em in e.emitter) { em.emitting = true; }

			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;	
			wait(0.25);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function zig_zag_right(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			for (em in e.emitter) { em.emitting = true; }

			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;	
			wait(0.25);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function sweep_left(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			for (em in e.emitter) { em.emitting = true; }

			e.transform.velocity.x = 0;
			e.transform.velocity.y = 10;
			wait(0.5);
			e.transform.velocity.x = 10;
			e.transform.velocity.y = 0;
			wait(1.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 10;
			wait(2);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function sweep_right(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			for (em in e.emitter) { em.emitting = true; }

			e.transform.velocity.x = 0;
			e.transform.velocity.y = 10;
			wait(0.5);
			e.transform.velocity.x = -10;
			e.transform.velocity.y = 0;
			wait(1.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 10;
			wait(2);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function pause_left_1(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.55);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.75);
			for (em in e.emitter) { em.emitting = true; }
			wait(4);
			for (em in e.emitter) { em.emitting = false; }
			wait(0.5);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.15);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(1);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function pause_left_2(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.35);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.55);
			for (em in e.emitter) { em.emitting = true; }
			wait(4);
			for (em in e.emitter) { em.emitting = false; }
			wait(0.5);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.35);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(1);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function pause_left_3(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.15);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.35);
			for (em in e.emitter) { em.emitting = true; }
			wait(4);
			for (em in e.emitter) { em.emitting = false; }
			wait(0.5);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.55);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(1);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

		public static function pause_right_1(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.55);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.75);
			for (em in e.emitter) { em.emitting = true; }
			wait(4);
			for (em in e.emitter) { em.emitting = false; }
			wait(0.5);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.15);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(1);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function pause_right_2(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.35);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			for (em in e.emitter) { em.emitting = true; }
			wait(4);
			for (em in e.emitter) { em.emitting = false; }
			wait(0.5);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.35);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(1);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function pause_right_3(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.15);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.25);
			for (em in e.emitter) { em.emitting = true; }
			wait(4);
			for (em in e.emitter) { em.emitting = false; }
			wait(0.5);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.55);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(1);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function back_and_forth(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			for (em in e.emitter) { em.emitting = true; }

			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	public static function back_and_forth_r(_: Dynamic, e: Entity, w: Array<Entity>) {
		Timer.script(function(wait) {
			for (em in e.emitter) { em.emitting = true; }

			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = -20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 20;
			e.transform.velocity.y = 0;
			wait(0.25);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			wait(0.5);
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 20;
			wait(0.25);

			return Signal.emit("enemy clear", { wave:w, entity:e });
		});
	}

	/* BLOSSOM SCRIPTS */

	public static function blossom_intro(_: Dynamic, e: Entity) {
		Signal.emit("boss incoming");
		Signal.emit("set bgm", "assets/bgm/Blossom.mp3");
		var v = e.transform.velocity;

		Timer.script(function(wait) {
			wait(1);
			v.y = 3;
			wait(1);
			v.y = 0;
			Signal.emit("dialog", "blossom_intro_01");
			wait(2);
			Signal.emit("dialog", "erin_engage_01");
			wait(2);

			Signal.emit("boss battle", e);
			Signal.emit("dialog", "blossom_phase_01");
			return blossom_phase01(_, e);
		});
	}

	public static function blossom_phase01(_: Dynamic, e: Entity) {
		var v = e.transform.velocity;
		e.enemy.iframe = false;

		Timer.script(function(wait) {
			blossom01(_, e);
			wait(7);

			var hp = e.enemy.hp / e.enemy.max_hp;
			if (hp < 0.667) {
				e.enemy.iframe = true;
				Signal.emit("bullet clear now", e);

				var info = move(_, e, boss_location);
				v.x = info.velocity.x;
				v.y = info.velocity.y;
				wait(info.time);
				v.x = 0;
				v.y = 0;
				wait(0.25);
				Signal.emit("dialog", "blossom_phase_02");
				wait(2);

				for (em in e.emitter) {
					em.radius = 0.15;
				}

				return blossom_phase02(_, e);
			}

			return blossom_phase01(_, e);
		});
	}

	public static function blossom_phase02(_: Dynamic, e: Entity) {
		var v = e.transform.velocity;
		e.enemy.iframe = false;

		Timer.script(function(wait) {
			var attack = [ 0, 1, 2 ];
			var r = Math.floor(Lm.random(0, attack.length-1));
			if (r == 0) {
				blossom01(_, e);
			} else if (r == 1) {
				blossom02(_, e);
			} else if (r == 2) {
				blossom03(_, e);
			}
			wait(7);

			var hp = e.enemy.hp / e.enemy.max_hp;
			if (hp < 0.333) {
				e.enemy.iframe = true;
				Signal.emit("bullet clear now", e);

				var info = move(_, e, boss_location);
				v.x = info.velocity.x;
				v.y = info.velocity.y;
				wait(info.time);
				v.x = 0;
				v.y = 0;
				wait(0.25);
				Signal.emit("dialog", "blossom_phase_03");
				wait(2);
				return blossom_phase03(_, e);
			}

			return blossom_phase02(_, e);
		});
	}

	public static function blossom_phase03(_: Dynamic, e: Entity) {
		e.enemy.iframe = false;

		Timer.script(function(wait) {
			blossom04(_, e);
			wait(7);

			if (e.enemy.hp == 0) {
				Signal.emit("bullet clear now", e);
				Signal.emit("dialog", "blossom_defeat_01");
				wait(3);
				return;
			}

			return blossom_phase03(_, e);
		});
	}

	public static function blossom01(_: Dynamic, e: Entity) {
		var v = e.transform.velocity;
		var info = move(_, e, null);

		Timer.script(function(wait) {
			v.x = info.velocity.x;
			v.y = info.velocity.y;
			wait(info.time);
			v.x = 0;
			v.y = 0;
			wait(0.25);

			var attacks = [0, 1, 2, 3];
			var r = Math.floor(Lm.random(0, attacks.length-1));
			e.emitter[attacks[r]].emitting = true;
			wait(5);

			e.emitter[attacks[r]].emitting = false;
			wait(0.25);
		});
	}

	public static function blossom02(_: Dynamic, e: Entity) {
		var v = e.transform.velocity;
		var x = Lm.random(0, 1);
		x = x == 0 ? -1 : 1;
		var info = move(_, e, new Vec3(7 * x, -7, 0));

		Timer.script(function(wait) {
			v.x = info.velocity.x;
			v.y = info.velocity.y;
			wait(info.time);
			v.x = 0;
			v.y = 0;
			wait(0.25);

			var em: Entity = {
				transform: new Transform(new Vec3(-7 * x, 7, 0)),
				emitter:   []
			};
			e.enemy.attach.push(em);
			World.add(em);

			if (x < 0) {
				e.emitter[1].emitting = true;
				em.emitter.push(Emit.make(Emit.Emit.fast_galaxy_l));
			} else {
				e.emitter[2].emitting = true;
				em.emitter.push(Emit.make(Emit.Emit.fast_galaxy_r));
			}
			em.emitter[0].emitting = true;
			wait(5);

			if (x < 0) {
				e.emitter[1].emitting = false;
			} else {
				e.emitter[2].emitting = false;
			}
			em.emitter[0].emitting = false;
			wait(0.25);
		});
	}

	public static function blossom03(_: Dynamic, e: Entity) {
		var v = e.transform.velocity;
		var info = move(_, e, new Vec3(0, -7, 0));

		Timer.script(function(wait) {
			v.x = info.velocity.x;
			v.y = info.velocity.y;
			wait(info.time);
			v.x = 0;
			v.y = 0;
			wait(0.25);

			var em1: Entity = {
				transform: new Transform(new Vec3(7, -7, 0)),
				emitter:   [
					Emit.make(Emit.Emit.fast_spiral_l)
				]
			};
			e.enemy.attach.push(em1);
			World.add(em1);

			var em2: Entity = {
				transform: new Transform(new Vec3(-7, -7, 0)),
				emitter:   [
					Emit.make(Emit.Emit.fast_spiral_r)
				]
			};
			e.enemy.attach.push(em2);
			World.add(em2);

			e.emitter[3].emitting   = true;
			em1.emitter[0].emitting = true;
			em2.emitter[0].emitting = true;
			wait(5);
			e.emitter[3].emitting   = false;
			em1.emitter[0].emitting = false;
			em2.emitter[0].emitting = false;
			wait(0.25);
		});
	}

	public static function blossom04(_: Dynamic, e: Entity) {
		var v = e.transform.velocity;
		var info = move(_, e, new Vec3(0, -3, 0));

		Timer.script(function(wait) {
			v.x = info.velocity.x;
			v.y = info.velocity.y;
			wait(info.time);
			v.x = 0;
			v.y = 0;
			wait(0.25);

			var em1: Entity = {
				transform: new Transform(new Vec3(-5, 7, 0)),
				emitter:   [
					Emit.make(Emit.fast_spiral_l)
				]
			};
			e.enemy.attach.push(em1);
			World.add(em1);

			var em2: Entity = {
				transform: new Transform(new Vec3(5, 7, 0)),
				emitter:   [
					Emit.make(Emit.fast_spiral_r)
				]
			};
			e.enemy.attach.push(em2);
			World.add(em2);

			e.emitter[3].emitting   = true;
			e.emitter[4].emitting   = true;
			e.emitter[5].emitting   = true;
			em1.emitter[0].emitting = true;
			em2.emitter[0].emitting = true;
			wait(5);

			e.emitter[3].emitting   = false;
			e.emitter[4].emitting   = false;
			e.emitter[5].emitting   = false;
			em1.emitter[0].emitting = false;
			em2.emitter[0].emitting = false;
		});
	}

	/* ROSE SCRIPTS */

	public static function rose_intro(_: Dynamic, e: Entity) {
		Signal.emit("boss incoming");
		Signal.emit("set bgm", "assets/bgm/Rose.mp3");
		var v = e.transform.velocity;

		Timer.script(function(wait) {
			wait(1);
			v.y = 3;
			wait(1);
			v.y = 0;
			Signal.emit("dialog", "rose_intro_01");
			wait(2);
			Signal.emit("dialog", "erin_sister_01");
			wait(2);
			Signal.emit("dialog", "rose_intro_02");
			wait(2);
			Signal.emit("dialog", "erin_sister_02");
			wait(2);
			Signal.emit("dialog", "rose_intro_03");
			wait(2);
			Signal.emit("dialog", "rose_intro_04");
			wait(2);
			Signal.emit("reveal");
			wait(2);

			Signal.emit("boss battle", e);
			Signal.emit("dialog", "rose_phase_01");
			return rose_phase01(_, e);
		});
	}

	public static function rose_phase01(_: Dynamic, e: Entity) {
		var v = e.transform.velocity;
		e.enemy.iframe = false;

		Timer.script(function(wait) {
			rose01(_, e);
			wait(7);

			var hp = e.enemy.hp / e.enemy.max_hp;
			if (hp < 0.50) {
				e.enemy.iframe = true;
				Signal.emit("bullet clear now", e);

				var info = move(_, e, boss_location);
				v.x = info.velocity.x;
				v.y = info.velocity.y;
				wait(info.time);
				v.x = 0;
				v.y = 0;
				wait(0.25);
				Signal.emit("dialog", "rose_phase_02");
				wait(2);

				for (em in e.emitter) {
					em.radius = 0.15;
				}

				return rose_phase02(_, e);
			}

			return rose_phase01(_, e);
		});
	}

	public static function rose_phase02(_: Dynamic, e: Entity) {
		var v = e.transform.velocity;
		e.enemy.iframe = false;

		Timer.script(function(wait) {
			var attack = [ 0, 1, 2 ];
			var r = Math.floor(Lm.random(0, attack.length-1));
			if (r == 0) {
				rose01(_, e);
			} else if (r == 1) {
				rose02(_, e);
			} else if (r == 2) {
				rose03(_, e);
			}
			wait(7);

			var hp = e.enemy.hp / e.enemy.max_hp;
			if (hp < 0.25) {
				e.enemy.iframe = true;
				Signal.emit("bullet clear now", e);

				var info = move(_, e, boss_location);
				v.x = info.velocity.x;
				v.y = info.velocity.y;
				wait(info.time);
				v.x = 0;
				v.y = 0;
				wait(0.25);
				Signal.emit("dialog", "rose_phase_03");
				wait(2);
				return rose_phase03(_, e);
			}

			return rose_phase02(_, e);
		});
	}

	public static function rose_phase03(_: Dynamic, e: Entity) {
		e.enemy.iframe = false;

		Timer.script(function(wait) {
			rose04(_, e);
			wait(7);

			if (e.enemy.hp == 0) {
				Signal.emit("bullet clear now", e);
				Signal.emit("dialog", "rose_defeat_01");
				return Signal.emit("boss clear", e);
			}

			return rose_phase03(_, e);
		});
	}

	public static function rose01(_: Dynamic, e: Entity) {
		var v = e.transform.velocity;
		var info = move(_, e, null);

		Timer.script(function(wait) {
			v.x = info.velocity.x;
			v.y = info.velocity.y;
			wait(info.time);
			v.x = 0;
			v.y = 0;
			wait(0.25);

			var attacks = [0, 1, 2, 3];
			var r = Math.floor(Lm.random(0, attacks.length-1));
			e.emitter[attacks[r]].emitting = true;
			wait(5);

			e.emitter[attacks[r]].emitting = false;
			wait(0.25);
		});
	}

	public static function rose02(_: Dynamic, e: Entity) {
		var v = e.transform.velocity;
		var x = Lm.random(0, 1);
		x = x == 0 ? -1 : 1;
		var info = move(_, e, new Vec3(7 * x, -7, 0));

		Timer.script(function(wait) {
			v.x = info.velocity.x;
			v.y = info.velocity.y;
			wait(info.time);
			v.x = 0;
			v.y = 0;
			wait(0.25);

			var em: Entity = {
				transform: new Transform(new Vec3(-7 * x, 7, 0)),
				emitter:   []
			};
			e.enemy.attach.push(em);
			World.add(em);

			if (x < 0) {
				e.emitter[1].emitting = true;
				em.emitter.push(Emit.make(Emit.Emit.fast_galaxy_l));
			} else {
				e.emitter[2].emitting = true;
				em.emitter.push(Emit.make(Emit.Emit.fast_galaxy_r));
			}
			em.emitter[0].emitting = true;
			wait(5);

			if (x < 0) {
				e.emitter[1].emitting = false;
			} else {
				e.emitter[2].emitting = false;
			}
			em.emitter[0].emitting = false;
			wait(0.25);
		});
	}

	public static function rose03(_: Dynamic, e: Entity) {
		var v = e.transform.velocity;
		var info = move(_, e, new Vec3(0, -7, 0));

		Timer.script(function(wait) {
			v.x = info.velocity.x;
			v.y = info.velocity.y;
			wait(info.time);
			v.x = 0;
			v.y = 0;
			wait(0.25);

			var em1: Entity = {
				transform: new Transform(new Vec3(7, -7, 0)),
				emitter:   [
					Emit.make(Emit.twin_spiral_l)
				]
			};
			e.enemy.attach.push(em1);
			World.add(em1);

			var em2: Entity = {
				transform: new Transform(new Vec3(-7, -7, 0)),
				emitter:   [
					Emit.make(Emit.twin_spiral_r)
				]
			};
			e.enemy.attach.push(em2);
			World.add(em2);

			e.emitter[3].emitting   = true;
			em1.emitter[0].emitting = true;
			em2.emitter[0].emitting = true;
			wait(5);
			e.emitter[3].emitting   = false;
			em1.emitter[0].emitting = false;
			em2.emitter[0].emitting = false;
			wait(0.25);
		});
	}

	public static function rose04(_: Dynamic, e: Entity) {
		var v = e.transform.velocity;
		var info = move(_, e, new Vec3(0, -3, 0));

		Timer.script(function(wait) {
			v.x = info.velocity.x;
			v.y = info.velocity.y;
			wait(info.time);
			v.x = 0;
			v.y = 0;
			wait(0.25);

			e.emitter[2].emitting   = true;
			e.emitter[3].emitting   = true;
			e.emitter[4].emitting   = true;
			wait(5);

			e.emitter[2].emitting   = false;
			e.emitter[3].emitting   = false;
			e.emitter[4].emitting   = false;
		});
	}
}
