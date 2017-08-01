package systems;

import math.Vec3;
import math.Mat4;

class CapsuleUpdate extends System {
	override function filter(e: Entity) {
		return e.capsules != null && e.transform != null;
	}

	override function process(e: Entity, dt: Float) {
		var mtx = e.transform.mtx;

		var anim = e.animation;
		var bone_matrices = null;
		if (anim != null && anim.timeline != null) {
			bone_matrices = anim.timeline.current_matrices;
		}
		for (capsules in [ e.capsules.hit, e.capsules.hurt, e.capsules.push ]) {
			for (i in 0...capsules.length) {
				var capsule = capsules[i];
				if (capsule.joint != null && bone_matrices != null) {
					var joint_mtx = Mat4.from_cpml(untyped __lua__("{0}[{1}]", bone_matrices, capsule.joint));
					capsule.update(joint_mtx * mtx);
				}
				else {
					capsule.update(mtx);
				}
			}
		}
	}
}
