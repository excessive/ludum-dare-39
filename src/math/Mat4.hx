package math;

#if lua
import lua.Table;
#end

#if (lua && fast_math)
abstract Mat4(Table<Int, Float>) {
	public inline function new(?data: Array<Float>) {
		if (data == null) {
			this = Table.create([
				     0.0, 0.0, 0.0,
				0.0, 1.0, 0.0, 0.0,
				0.0, 0.0, 1.0, 0.0,
				0.0, 0.0, 0.0, 1.0
			]);
			this[0] = 1;
		}
		else {
			this = Table.create([
				data[1], data[2], data[3],
				data[4], data[5], data[6], data[7],
				data[8], data[9], data[10], data[11],
				data[12], data[13], data[14], data[15]
			]);
			this[0] = data[0];
		}
	}
#else
abstract Mat4(Array<Float>) {
	public inline function new(?data: Array<Float>) {
		if (data == null) {
			this = [
				1, 0, 0, 0,
				0, 1, 0, 0,
				0, 0, 1, 0,
				0, 0, 0, 1
			];
		}
		else {
			this = data;
		}
	}
#end

	public function identity() {
		for (i in 0...15) {
			this[i] = 0;
		}
		for (i in 0...3) {
			this[i+i*4] = 1;
		}
	}

	public static function scale(s: Vec3) {
		return new Mat4([
			s.x, 0, 0, 0,
			0, s.y, 0, 0,
			0, 0, s.z, 0,
			0, 0, 0, 1
		]);
	}

	public static function translate(t: Vec3) {
		return new Mat4([
			1, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 1, 0,
			t.x, t.y, t.z, 1
		]);
	}

	public static inline function rotate(q: Quat) {
		var a = q.to_angle_axis();
		return from_angle_axis(a.angle, a.axis);
	}

	public static function look_at(eye: Vec3, at: Vec3, up: Vec3) {
		var forward = at - eye;
		forward.normalize();
		var side = Vec3.cross(forward, up);
		side.normalize();
		var new_up = Vec3.cross(side, forward);

		return new Mat4([
			side.x, new_up.x, -forward.x, 0,
			side.y, new_up.y, -forward.y, 0,
			side.z, new_up.z, -forward.z, 0,
			-Vec3.dot(side, eye), -Vec3.dot(new_up, eye), Vec3.dot(forward, eye), 1
		]);
	}

	public function invert() {
		var out = new Mat4();
		out[0]  =  this[5] * this[10] * this[15] - this[5] * this[11] * this[14] - this[9]  * this[6] * this[15] + this[9]  * this[7] * this[14] + this[13] * this[6] * this[11] - this[13] * this[7] * this[10];
		out[1]  = -this[1] * this[10] * this[15] + this[1] * this[11] * this[14] + this[9]  * this[2] * this[15] - this[9]  * this[3] * this[14] - this[13] * this[2] * this[11] + this[13] * this[3] * this[10];
		out[2]  =  this[1] * this[6]  * this[15] - this[1] * this[7]  * this[14] - this[5]  * this[2] * this[15] + this[5]  * this[3] * this[14] + this[13] * this[2] * this[7]  - this[13] * this[3] * this[6];
		out[3]  = -this[1] * this[6]  * this[11] + this[1] * this[7]  * this[10] + this[5]  * this[2] * this[11] - this[5]  * this[3] * this[10] - this[9]  * this[2] * this[7]  + this[9]  * this[3] * this[6];
		out[4]  = -this[4] * this[10] * this[15] + this[4] * this[11] * this[14] + this[8]  * this[6] * this[15] - this[8]  * this[7] * this[14] - this[12] * this[6] * this[11] + this[12] * this[7] * this[10];
		out[5]  =  this[0] * this[10] * this[15] - this[0] * this[11] * this[14] - this[8]  * this[2] * this[15] + this[8]  * this[3] * this[14] + this[12] * this[2] * this[11] - this[12] * this[3] * this[10];
		out[6]  = -this[0] * this[6]  * this[15] + this[0] * this[7]  * this[14] + this[4]  * this[2] * this[15] - this[4]  * this[3] * this[14] - this[12] * this[2] * this[7]  + this[12] * this[3] * this[6];
		out[7]  =  this[0] * this[6]  * this[11] - this[0] * this[7]  * this[10] - this[4]  * this[2] * this[11] + this[4]  * this[3] * this[10] + this[8]  * this[2] * this[7]  - this[8]  * this[3] * this[6];
		out[8]  =  this[4] * this[9]  * this[15] - this[4] * this[11] * this[13] - this[8]  * this[5] * this[15] + this[8]  * this[7] * this[13] + this[12] * this[5] * this[11] - this[12] * this[7] * this[9];
		out[9] =  -this[0] * this[9]  * this[15] + this[0] * this[11] * this[13] + this[8]  * this[1] * this[15] - this[8]  * this[3] * this[13] - this[12] * this[1] * this[11] + this[12] * this[3] * this[9];
		out[10] =  this[0] * this[5]  * this[15] - this[0] * this[7]  * this[13] - this[4]  * this[1] * this[15] + this[4]  * this[3] * this[13] + this[12] * this[1] * this[7]  - this[12] * this[3] * this[5];
		out[11] = -this[0] * this[5]  * this[11] + this[0] * this[7]  * this[9]  + this[4]  * this[1] * this[11] - this[4]  * this[3] * this[9]  - this[8]  * this[1] * this[7]  + this[8]  * this[3] * this[5];
		out[12] = -this[4] * this[9]  * this[14] + this[4] * this[10] * this[13] + this[8]  * this[5] * this[14] - this[8]  * this[6] * this[13] - this[12] * this[5] * this[10] + this[12] * this[6] * this[9];
		out[13] =  this[0] * this[9]  * this[14] - this[0] * this[10] * this[13] - this[8]  * this[1] * this[14] + this[8]  * this[2] * this[13] + this[12] * this[1] * this[10] - this[12] * this[2] * this[9];
		out[14] = -this[0] * this[5]  * this[14] + this[0] * this[6]  * this[13] + this[4]  * this[1] * this[14] - this[4]  * this[2] * this[13] - this[12] * this[1] * this[6]  + this[12] * this[2] * this[5];
		out[15] =  this[0] * this[5]  * this[10] - this[0] * this[6]  * this[9]  - this[4]  * this[1] * this[10] + this[4]  * this[2] * this[9]  + this[8]  * this[1] * this[6]  - this[8]  * this[2] * this[5];

		var det = this[0] * out[0] + this[1] * out[4] + this[2] * out[8] + this[3] * out[12];

		if (det == 0) {
			return;
		}

		det = 1 / det;

		for (i in 0...15) {
			this[i] = out[i] * det;
		}
	}

	public function transpose() {
#if (lua && fast_math)
		var tmp = [ for (i in 0...15) this[i] ];
#else
		var tmp = this.copy();
#end
		this[1]  = tmp[4];
		this[2]  = tmp[8];
		this[3]  = tmp[12];
		this[4]  = tmp[1];
		this[6]  = tmp[9];
		this[7]  = tmp[13];
		this[8]  = tmp[2];
		this[9]  = tmp[6];
		this[11] = tmp[14];
		this[12] = tmp[3];
		this[13] = tmp[7];
		this[14] = tmp[11];
	}

	public static function from_angle_axis(angle: Float, axis: Vec3) {
		var l = axis.lengthsq();
		if (l == 0) {
			return new Mat4();
		}
		l = Math.sqrt(l);

		var x = axis.x / l;
		var y = axis.y / l;
		var z = axis.z / l;
		var c = Math.cos(angle);
		var s = Math.sin(angle);

		return new Mat4([
			x*x*(1-c)+c,   y*x*(1-c)+z*s, x*z*(1-c)-y*s, 0,
			x*y*(1-c)-z*s, y*y*(1-c)+c,   y*z*(1-c)+x*s, 0,
			x*z*(1-c)+y*s, y*z*(1-c)-x*s, z*z*(1-c)+c,   0,
			0, 0, 0, 1
		]);
	}

	public static function from_ortho(left: Float, right: Float, top: Float, bottom: Float, near: Float, far: Float) {
		return new Mat4([
			2 / (right - left), 0, 0, 0,
			0, 2 / (top - bottom), 0, 0,
			0, 0, -2 / (far - near), 0,
			-((right + left) / (right - left)), -((top + bottom) / (top - bottom)), -((far + near) / (far - near)), 1
		]);
	}

	public static function from_perspective(fovy: Float, aspect: Float, near: Float, far: Float) {
		var t = Math.tan(Utils.rad(fovy) / 2);
		return new Mat4([
			1 / (t * aspect), 0, 0, 0,
			0, 1 / t, 0, 0,
			0, 0, -(far + near) / (far - near), -1,
			0, 0,  -(2 * far * near) / (far - near), 0
		]);
	}

	public function set_clips(near: Float, far: Float) {
		this[10] = -(far + near) / (far - near);
		this[14] = -(2 * far * near) / (far - near);
	}

#if lua
	public static function from_cpml(t: lua.Table<Int, Float>) {
		return new Mat4([
			t[1], t[2], t[3], t[4],
			t[5], t[6], t[7], t[8],
			t[9], t[10], t[11], t[12],
			t[13], t[14], t[15], t[16]
		]);
	}
#end

	public function copy() {
		var out = new Mat4();
		for (i in 0...15) {
			out[i] = this[i];
		}
		return out;
	}

#if lua
	public function to_vec4s() {
		var a = this;
		untyped __lua__("
			do return {
				{ a[0],  a[1],  a[2],  a[3]  },
				{ a[4],  a[5],  a[6],  a[7]  },
				{ a[8],  a[9],  a[10], a[11] },
				{ a[12], a[13], a[14], a[15] }
			} end
		");
		return Table.create();
	}
#end

	public function to_frustum(infinite: Bool = false) {
		// Extract the LEFT plane
		var left = new Vec4(
			this[3]  + this[0],
			this[7]  + this[4],
			this[11] + this[8],
			this[15] + this[12]
		);
		left.normalize();

		// Extract the RIGHT plane
		var right = new Vec4(
			this[3]  - this[0],
			this[7]  - this[4],
			this[11] - this[8],
			this[15] - this[12]
		);
		right.normalize();

		// Extract the BOTTOM plane
		var bottom = new Vec4(
			this[3]  + this[1],
			this[7]  + this[5],
			this[11] + this[9],
			this[15] + this[13]
		);
		bottom.normalize();

		// Extract the TOP plane
		var top = new Vec4(
			this[3]  - this[1],
			this[7]  - this[5],
			this[11] - this[9],
			this[15] - this[13]
		);
		top.normalize();

		// Extract the NEAR plane
		var near = new Vec4(
			this[3]  + this[2],
			this[7]  + this[6],
			this[11] + this[10],
			this[15] + this[14]
		);
		near.normalize();

		var far = null;
		if (!infinite) {
			// Extract the FAR plane
			far = new Vec4(
				this[3]  - this[2],
				this[7]  - this[6],
				this[11] - this[10],
				this[15] - this[14]
			);
			far.normalize();
		}

		return new Frustum({
			left: left,
			right: right,
			bottom: bottom,
			top: top,
			near: near,
			far: far
		});
	}

	@:arrayAccess
	public inline function get(k: Int): Float {
		return this[k];
	}

	@:arrayAccess
	public inline function set(k: Int, v: Float) {
		this[k] = v;
		return v;
	}

	@:op(A * B)
	public function mul(b: Mat4) {
		var out = new Mat4();
		var a = this;
		out[0]  = a[0]  * b[0] + a[1]  * b[4] + a[2]  *  b[8] +  a[3] * b[12];
		out[1]  = a[0]  * b[1] + a[1]  * b[5] + a[2]  *  b[9] +  a[3] * b[13];
		out[2]  = a[0]  * b[2] + a[1]  * b[6] + a[2]  * b[10] +  a[3] * b[14];
		out[3]  = a[0]  * b[3] + a[1]  * b[7] + a[2]  * b[11] +  a[3] * b[15];
		out[4]  = a[4]  * b[0] + a[5]  * b[4] + a[6]  *  b[8] +  a[7] * b[12];
		out[5]  = a[4]  * b[1] + a[5]  * b[5] + a[6]  *  b[9] +  a[7] * b[13];
		out[6]  = a[4]  * b[2] + a[5]  * b[6] + a[6]  * b[10] +  a[7] * b[14];
		out[7]  = a[4]  * b[3] + a[5]  * b[7] + a[6]  * b[11] +  a[7] * b[15];
		out[8]  = a[8]  * b[0] + a[9]  * b[4] + a[10] *  b[8] + a[11] * b[12];
		out[9]  = a[8]  * b[1] + a[9]  * b[5] + a[10] *  b[9] + a[11] * b[13];
		out[10] = a[8]  * b[2] + a[9]  * b[6] + a[10] * b[10] + a[11] * b[14];
		out[11] = a[8]  * b[3] + a[9]  * b[7] + a[10] * b[11] + a[11] * b[15];
		out[12] = a[12] * b[0] + a[13] * b[4] + a[14] *  b[8] + a[15] * b[12];
		out[13] = a[12] * b[1] + a[13] * b[5] + a[14] *  b[9] + a[15] * b[13];
		out[14] = a[12] * b[2] + a[13] * b[6] + a[14] * b[10] + a[15] * b[14];
		out[15] = a[12] * b[3] + a[13] * b[7] + a[14] * b[11] + a[15] * b[15];
		return out;
	}

	@:op(A * B)
	public function mul_vec3(b: Vec3) {
		return new Vec3(
			b.x * this[0] + b.y * this[4] + b.z * this[8]  + this[12],
			b.x * this[1] + b.y * this[5] + b.z * this[9]  + this[13],
			b.x * this[2] + b.y * this[6] + b.z * this[10] + this[14]
		);
	}

	@:op(A * B)
	public function mul_vec4(b: Vec4) {
		return new Vec4(
			b.x * this[0] + b.y * this[4] + b.z * this[8]  + this[12] * b.w,
			b.x * this[1] + b.y * this[5] + b.z * this[9]  + this[13] * b.w,
			b.x * this[2] + b.y * this[6] + b.z * this[10] + this[14] * b.w,
			b.x * this[3] + b.y * this[7] + b.z * this[11] + this[15] * b.w
		);
	}

	public function equal(that: Mat4) {
		for (i in 0...15) {
			if (Math.abs(this[i] - that[i]) > 1.0e-5) {
				return false;
			}
		}
		return true;
	}
}
