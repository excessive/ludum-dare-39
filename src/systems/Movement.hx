package systems;

import math.Vec3;
import math.Mat4;

@:publicFields
class Movement extends System {
	override function filter(e: Entity) {
		if (e.transform != null) {
			return true;
		}
		return false;
	}

	var cached = new Map<Entity, Mat4>();

	function remove(e) {
		cached.remove(e);
	}

	function update_cache(e: Entity) {
		var d = e.drawable;
		var mtx = e.transform.mtx;
		var add = false;
		if (!cached.exists(e)) {
			cached[e] = mtx.copy();
			add = true;
		}
		else if (cached[e].equal(mtx)) {
			return;
		}
		else {
			cached[e] = mtx.copy();
		}
		var bounds = d.mesh.bounds.base;
		var min = new Vec3(bounds.min[1], bounds.min[2], bounds.min[3]);
		var max = new Vec3(bounds.max[1], bounds.max[2], bounds.max[3]);
		var xform_bounds = math.Utils.rotate_bounds(mtx, min, max);
		World.refresh_entity(e, xform_bounds, add);
	}

	override function process(e: Entity, dt: Float) {
		e.transform.position += e.transform.velocity * dt;

		if (e.player != null) {
			World.enforce_bounds(e);
		}

		e.transform.update();

		var d = e.drawable;
		if (d != null && d.mesh != null) {
			update_cache(e);
		}
	}
}
