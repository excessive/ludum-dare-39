package components;

import math.Vec3;
import math.Mat4;
import math.Capsule;

@:publicFields
class BoneCapsule {
	var length: Float;
	var radius: Float;
	var joint: Null<String>;
	var final: Capsule;

	function new(joint: Null<String>, length: Float, radius: Float) {
		this.joint = joint;
		this.length = length;
		this.radius = radius;
		this.final = new Capsule(new Vec3(), new Vec3(), 0.0);
	}

	function update(mtx: Mat4) {
		this.final.a = mtx * new Vec3(0, 0, 0);
		this.final.b = mtx * new Vec3(0, this.length, 0);
		this.final.radius = this.radius;
	}
}
