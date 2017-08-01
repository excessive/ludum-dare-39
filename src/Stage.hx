import components.*;
import components.Emitter.ParticleData;
import math.Vec3;
import timer.Timer;

import love.graphics.GraphicsModule as Lg;
import love.audio.AudioModule as La;
import love.math.MathModule as Lm;

import stages.StageDebug;
import stages.Stage01;
import Credits;

class Stage {
	public static var waves: Array<Array<Entity>> = [];
	public static var stage: Int    = 1;
	public static var wave:  Int    = 0;
	public static var boss:  Entity = {};
	public static var bgm:   love.audio.Source;

	public static function spawn(player: Player) {
		Profiler.load_zone();

		World.new_entities("", []);
		var e = {
			transform: new Transform(new Vec3(0, 0, 0)),
			drawable: new Drawable("assets/models/flat-map.iqm", Triangle, Terrain)
		};
		e.drawable.texture = Lg.newImage("assets/textures/concrete.png");
		World.add(e);

		// Test Player
		Player.spawn(new Vec3(0.0, 7.0, 0.0), player, [
			Emit.make({
				image:    Emit.particles.bullet,
				color:    Emit.colors.sky_blue,
				radius:   0.35,
				velocity: new Vec3(0.0, -30.0, 0.0),
				update:   function(p: Emitter, i: Int) {
					if (p.emitting && player.battery > 0) {
						// player.battery = Math.max(0, player.battery - 1/100);
						// player.score += 100;
					}
				}
			}),
			Emit.make({
				image:    Emit.particles.orb,
				color:    Emit.colors.thorn,
				radius:   0.25,
				spread:   1.0,
				lifetime: 0.25,
				velocity: new Vec3(0.0, 0.0, 0.0)
			})
		]);
	}
	public static function init(player: Player) {
		spawn(player);

		Signal.register("set bgm", function(path: String) {
			if (bgm != null) { bgm.stop(); }
			bgm = La.newSource(path);
			bgm.setLooping(true);
			bgm.setVolume(0.7);
			bgm.play();
		});

		Signal.register("bullet clear now", function(entity: Entity) {
			Timer.script(function(wait) {
				for (e in entity.emitter) {
					e.radius = 0;
					e.emitting = false;
				}

				for (a in entity.enemy.attach) {
					for (em in a.emitter) {
						em.radius = 0;
						em.emitting = false;
					}
				}
				wait(0.25);

				var away = new Vec3(50, -50, 0);
				for (e in entity.emitter) {
					for (particle in e.data.particles) {
						var dir = away - particle.position;
						dir.normalize();
						particle.velocity = dir * (Lm.random(700, 1000) / 10);
					}
				}

				for (a in entity.enemy.attach) {
					for (em in a.emitter) {
						for (particle in em.data.particles) {
							var dir = away - particle.position;
							dir.normalize();
							particle.velocity = dir * (Lm.random(700, 1000) / 10);
						}
					}
				}
				wait(1);

				for (e in entity.emitter) {
					e.data = new ParticleData();
				}
			});
		});

		Signal.register("bullet clear", function(entity: Entity) {
			Timer.script(function(wait) {
				wait(5);

				var away = new Vec3(50, -50, 0);
				for (e in entity.emitter) {
					e.radius = 0;
					e.emitting = false;

					for (particle in e.data.particles) {
						var dir = away - particle.position;
						dir.normalize();
						particle.velocity = dir * (Lm.random(700, 1000) / 10);
					}
				}
				wait(1);

				for (e in entity.emitter) {
					e.data = new ParticleData();
				}
			});
		});

		Signal.register("emitter clear", function(entity: Entity) {
			Timer.script(function(wait) {
				for (e in entity.emitter) {
					e.emitting = false;
				}

				Signal.emit("bullet clear", entity);
				wait(6);

				World.remove(entity);
			});
		});

		Signal.register("enemy clear", function(params) {
			Timer.script(function(wait) {
				var wave: Array<Entity> = params.wave;
				var entity: Entity = params.entity;

				var i = wave.indexOf(entity);
				if (i >= 0) {
					wave.splice(i, 1);
				} else {
					return;
				}

				Signal.emit("emitter clear", entity);
			});
		});

		Signal.register("boss clear", function(entity: Entity) {
			Timer.script(function(wait) {
				Signal.emit("emitter clear", entity);
				wait(6);

				stage += 1;
				init_stage();
			});
		});

		Signal.register("dialog", function(key: String) {
			var text = Language.get(key);
			trace(text);
		});

		init_stage();
	}

	public static function init_stage() {
		var info = {
			waves: [],
			boss: {}
		};

		if (stage == 1) {
			info = Stage01.init();
		} else {
			bgm.stop();
			Credits.init();
			return;
		}

		waves = info.waves;
		boss  = info.boss;
		wave  = 0;
		Timer.after(1, new_wave);

		Signal.emit("set bgm", "assets/bgm/Stage.mp3");
		Signal.emit("stage start");
	}

	private static function new_wave(t) {
		var w = waves[wave];
		for (e in w) {
			Timer.after(e.enemy.delay, function(t) {
				World.add(e);
				e.enemy.script(e, w);
			});
		}
	}

	private static function new_boss(t) {
		Signal.emit("boss enter", boss);
		World.add(boss);
		boss.enemy.script(boss, bgm);
	}

	public static function update(dt: Float) {
		if (waves[wave] != null && waves[wave].length == 0) {
			wave += 1;

			if (waves[wave] == null) {
				Timer.after(1, new_boss);
			} else {
				Timer.after(1, new_wave);
			}
		}
	}
}


