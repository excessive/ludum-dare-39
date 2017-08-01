package systems;

import components.*;
import components.Emitter.ParticleData;
import love.graphics.GraphicsModule as Lg;
import love.graphics.SpriteBatchUsage;
import love.math.MathModule as Lm;
import math.Vec3;
import timer.*;

class Reaper extends System {
	override function filter(e: Entity) {
		return e.enemy != null;
	}

	public static function reap(e: Entity) {
		Timer.script(function(wait) {
			for (emit in e.emitter) {
				emit.emitting = false;
				emit.radius   = 0;

				for (p in emit.data.particles) {
					p.velocity = p.velocity.scale((Lm.random(100, 700) / 1000));
				}
			}

			var boom: Entity = {
				transform: new Transform(e.transform.position.copy()),
				emitter: [
					{
						batch: Lg.newSpriteBatch(Lg.newImage("assets/textures/orb.png"), 50, SpriteBatchUsage.Stream),
						color: new Vec3(Lm.random(0, 100) / 100, Lm.random(0, 100) / 100, Lm.random(0, 100) / 100),
						limit: 50,
						data: new ParticleData(),
						lifetime: { min: 1, max: 1 },
						pulse: 1,
						spawn_radius: 0,
						spawn_rate: 50,
						spread: 30,
						offset: new Vec3(),
						scale: 1,
						tween: 0.5,
						radius: 0,
						emitting: true,
						velocity: new Vec3(0, 0, 0),
						user_data: null,
						update: null
					}
				]
			}
			World.add(boom);
			wait(0.1);

			e.drawable = null;
			boom.emitter[0].emitting = false;
			wait(0.9);

			var away = new Vec3(50, -50, 0);
			for (emit in e.emitter) {
				for (p in emit.data.particles) {
					var dir = away - p.position;
					dir.normalize();

					p.velocity = dir * (Lm.random(700, 1000) / 10);
				}
			}
			wait(1);

			World.remove(e);
			World.remove(boom);
		});
		
	}

	override function process(e: Entity, dt: Float) {
		if (e.enemy.hp == 0 && e.enemy.alive) {
			e.enemy.alive = false;
			e.transform.velocity.x = 0;
			e.transform.velocity.y = 0;
			e.transform.velocity.z = 0;

			reap(e);

			for (a in e.enemy.attach) {
				reap(a);
			}

			Signal.emit("killed enemy", e);

			var wave = Stage.waves[Stage.wave];
			if (wave != null) {
				return Signal.emit("enemy clear", { wave:wave, entity:e });
			}
		}
	}
}
