package systems;

import love.math.MathModule.random as rand;
import math.Utils;
import math.Vec3;
import components.Transform;
import components.Emitter;
import components.Emitter.ParticleData;
import components.Emitter.InstanceData;
import components.Emitter.BucketData;

class ParticleUpdate extends System {
	static var time: Float = 0.0;

	override function filter(e: Entity) {
		return e.emitter != null && e.transform != null;
	}

	function spawn_particle(transform: Transform, emitter: Emitter) {
		if (!emitter.emitting) {
			return;
		}

		var pd   = emitter.data;
		pd.last_spawn_time = time;
		pd.index++;

		var pos  = transform.position;
		var life = emitter.lifetime;

		var offset = rand(life.min*10000, life.max*10000) / 10000.0;
		var despawn_time = time + offset;

		pd.particles.push(new InstanceData(
			transform.position,
			emitter.velocity,
			emitter.offset,
			despawn_time,
			emitter.spawn_radius,
			emitter.spread
		));
	}

	override function update(entities: Array<Entity>, dt: Float) {
		time += dt;
	}

	function update_emitter(transform: Transform, particle: Emitter, dt: Float) {
		var pd = particle.data;

		// It's been too long since our last particle spawn and we need more, time
		// to get to work.
		var spawn_delta = time - pd.last_spawn_time;
		var count = pd.particles.length;
		if (particle.pulse > 0.0) {
			if (count + particle.spawn_rate <= particle.limit && spawn_delta >= particle.pulse) {
				for (i in 0...particle.spawn_rate) {
					this.spawn_particle(transform, particle);

					if (particle.update != null) {
						particle.update(particle, pd.index);
					}
				}
			}
		}
		else {
			var rate = 1/particle.spawn_rate;
			if (count < particle.limit && spawn_delta >= rate) {
				var need = Std.int(Utils.min(2, Math.floor(spawn_delta / rate)));

				for (i in 0...need) {
					this.spawn_particle(transform, particle);

					if (particle.update != null) {
						particle.update(particle, pd.index);
					}
				}
			}
		}

		pd.buckets = [];
		var nbuckets = ParticleData.bucket_count;
		for (i in 0...nbuckets) {
			pd.buckets.push(new BucketData());
		}

		// Because particles are added in order of time and removals maintain
		// order, we can simply count the number we need to get rid of and process
		// the rest.
		var tl = new Vec3();
		var tr = new Vec3();
		var bl = new Vec3();
		var br = new Vec3();
		var remove_n = 0;
		for (i in 0...pd.particles.length) {
			var p = pd.particles[i];
			if (time > p.despawn_time) {
				remove_n++;
				continue;
			}
			p.position.x = p.position.x + p.velocity.x * dt;
			p.position.y = p.position.y + p.velocity.y * dt;
			// p.position.z = p.position.z + p.velocity.z * dt;

			// don't allocate a table in here...
			var used_a = null;
			var used_b = null;
			var used_c = null;
			var used_d = null;
			inline function drop_in_the_bucket(pos: Vec3) {
				var hash = ParticleData.hash(pos);
				var used = null;
				if (hash < pd.buckets.length && hash > 0) {
					if (hash != used_a && hash != used_b && hash != used_c && hash != used_d) {
						pd.buckets[hash].push({
							position: p.position,
							index: i
						});
						used = hash;
					}
				}
				return used;
			}
			var min_x = p.position.x - particle.radius;
			var max_x = p.position.x + particle.radius;
			var min_y = p.position.y - particle.radius;
			var max_y = p.position.y + particle.radius;
			tl.x = min_x; tl.y = min_y;
			tr.x = max_x; tr.y = min_y;
			bl.x = min_x; bl.y = max_y;
			br.x = max_x; br.y = max_y;
			used_a = drop_in_the_bucket(tl);
			used_b = drop_in_the_bucket(tr);
			used_c = drop_in_the_bucket(bl);
			used_d = drop_in_the_bucket(br);
		}

		// Particles be gone!
		if (remove_n > 0) {
			pd.particles.splice(0, remove_n);
		}

		if (particle.time == null) {
			particle.time = time;
		}

		if (particle.time != null && particle.tween != null) {
			var _time = time - particle.time;
			_time /= particle.tween;
			_time = Math.pow(_time, 2);
			particle.scale = Utils.clamp(1-_time, 0, 1);
		}
	}

	override function process(e: Entity, dt: Float) {
		for (particle in e.emitter) {
			update_emitter(e.transform, particle, dt);
		}
	}
}
