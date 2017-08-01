package systems;

import components.Emitter.ParticleData;
import math.Capsule;
import math.Intersect;
import math.Vec3;
import math.Utils;

class ParticleCollision extends System {
	override public function filter(e: Entity): Bool {
		return e.emitter != null;
	}

	override public function update(entities: Array<Entity>, dt: Float) {
		for (entity in entities) {
			if (entity.player == null) { continue; }

			for (other in entities) {
				if (other == entity) { continue; }

				// we only care about emitters with update functions, since those are
				// the ones used for battle (not effects)
				var update = false;
				for (e in other.emitter) {
					if (e.update != null) {
						update = true;
						break;
					}
				}

				if (!update) {
					continue;
				}

				// Player's bullets hit an enemy
				if (
					other.capsules != null &&
					other.enemy    != null &&
					!other.enemy.iframe
				) {
					hit(entity, other);
				}

				// Enemy's bullets hit a player
				hit(other, entity);
			}
		}
	}

	private function hit(a: Entity, b: Entity) {
		for (e in a.emitter) {
			if (e.radius == 0) { return; }

			var pd     = e.data;
			var bucket = pd.buckets[ParticleData.hash(b.transform.position)];
			if (bucket == null) { return; }

			var acap = new Capsule(new Vec3(), new Vec3(), 0);
			var bcap = new Capsule(new Vec3(), new Vec3(), 0);
			
			// Remove a bullet if it collides
			var i = bucket.length;
			while (--i >= 0) {
				for (cap in b.capsules.hurt) {
					var bullet  = bucket[i];
					acap.a      = bullet.position;
					acap.b      = bullet.position;
					acap.radius = e.radius;
					bcap        = cap.final;
					var ret     = Intersect.capsule_capsule(acap, bcap);

					if (ret != null) {
						// Player getting hit
						if (b.player != null) {
							if (b.player.iframes == 0 && b.player.hp > 0) {
								pd.particles.splice(bullet.index, 1);
								if (b.player.shield) {
									b.player.max_battery = Utils.max(0, b.player.max_battery - b.player.battery_drain_per_hit);
									b.player.iframes = b.player.max_iframes;
									Signal.emit("invulnerable", b.player.iframes);
								}
								else {
									// no shield? you're dead, kiddo.
									b.player.hp = Utils.max(0, b.player.hp - 1);
									Signal.emit("killed player", b);
								}
							}
							return;
						} else if (b.enemy != null) {
							if (b.enemy.hp > 0) {
								pd.particles.splice(bullet.index, 1); // ????????????????????????????????????????
								b.enemy.hp = Utils.max(0, b.enemy.hp - a.player.damage);
								a.player.score += 129;
							}
							return;
						}
					}
				}
			}
		}
	}
}
