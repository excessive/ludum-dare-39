package math;

@:publicFields
class Capsule {
	var a: Vec3;
	var b: Vec3;
	var radius: Float;

	function new(a: Vec3, b: Vec3, radius: Float) {
		this.a = a;
		this.b = b;
		this.radius = radius;
	}
}
