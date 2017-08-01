package components;

import math.Vec3;
import math.Quat;
import math.Mat4;

@:publicFields
class Transform {
	var position: Vec3;
	var velocity: Vec3;
	var orientation: Quat;
	var scale: Vec3;
	var snap_to: Quat;
	var snap: Bool;
	var slerp: Float;
	var accel: Vec3;
	var mtx: Mat4 = new Mat4();

	function new(pos: Vec3, ?vel: Vec3, ?rot: Quat, ?sca: Vec3) {
		this.position = pos;
		if (vel != null) {
			this.velocity = vel;
		}
		else {
			this.velocity = new Vec3(0, 0, 0);
		}

		if (rot != null) {
			this.orientation = rot;
		}
		else {
			this.orientation = new Quat(0, 0, 0, 1);
		}

		if (sca != null) {
			this.scale = sca;
		}
		else {
			this.scale = new Vec3(1, 1, 1);
		}

		this.snap_to = new Quat(0, 0, 0, 1);
		this.snap = false;
		this.slerp = 0;
	}

	function update() {
		mtx.identity();
		if (scale.lengthsq() > 0) {
			mtx *= Mat4.scale(scale);
		}
		mtx *= Mat4.rotate(orientation);
		mtx *= Mat4.translate(position);
	}
}
