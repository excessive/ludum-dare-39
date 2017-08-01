package math;

@:publicFields
class Plane {
	var origin: Vec3;
	var normal: Vec3;
	var equation: Vec4;

	function new(a: Vec3, b: Vec3) {
		this.origin = a;
		this.normal = b;
		this.equation = new Vec4(
			b.x, b.y, b.z,
			-(b.x * a.x + b.y * a.y + b.z * a.z)
		);
	}

	static function from_triangle(a: Vec3, b: Vec3, c: Vec3) {
		var ba = b - a;
		var ca = c - a;

		var temp = Vec3.cross(ba, ca);
		temp.normalize();

		var plane = new Plane(a, temp);
		plane.equation.x = temp.x;
		plane.equation.y = temp.y;
		plane.equation.z = temp.z;
		plane.equation.w = -(temp.x * a.x + temp.y * a.y + temp.z * a.z);

		return plane;
	}

	function signed_distance(base_point: Vec3) {
		return Vec3.dot(base_point, this.normal) - Vec3.dot(this.normal, this.origin);
	}

	function is_front_facing(direction: Vec3): Bool {
		var f: Float = Vec3.dot(this.normal, direction);

		if (f <= 0.0) {
			return true;
		}

		return false;
	}
}
