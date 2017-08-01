package systems;

import math.Vec3;
import math.Intersect;

class CapsuleCollision extends System {
	override public function filter(e: Entity): Bool {
		return e.capsules != null;
	}

	override public function update(entities: Array<Entity>, dt: Float) {
		for (entity in entities) {
			if (entity.player == null) { continue; }

			for (other in entities) {
				if (other == entity) { continue; }

				// Entities bumping into each other
				for (edata in entity.capsules.push) {
					for (odata in other.capsules.push) {
						var ecap = edata.final;
						var ocap = odata.final;
						var ret = Intersect.capsule_capsule(ecap, ocap);

						if (ret != null) {
							var direction: Vec3 = ret.p1 - ret.p2;
							direction.normalize();

							var power  = Vec3.dot(entity.transform.velocity, direction);
							var reject = direction * -power;
							entity.transform.velocity += reject * entity.transform.velocity.length();

							var offset = ret.p1 - entity.transform.position;
							entity.transform.position = ret.p2 - offset + direction * (ecap.radius + ocap.radius);
						}
					}
				}

				// Player attacking enemies
				for (edata in entity.capsules.hurt) {
					for (odata in other.capsules.hit) {
						var ecap = edata.final;
						var ocap = odata.final;
						var ret = Intersect.capsule_capsule(ecap, ocap);

						if (ret != null) {
							//
						}
					}
				}

				// Enemies attacking player
				for (edata in entity.capsules.hit) {
					for (odata in other.capsules.hurt) {
						var ecap = edata.final;
						var ocap = odata.final;
						var ret = Intersect.capsule_capsule(ecap, ocap);

						if (ret != null) {
							//
						}
					}
				}
			}
		}
	}
}
