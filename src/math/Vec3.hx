package math;

import haxe.ds.Vector;

// NB: Use .x/y/z indexing internally! It's needed for target specific fixups
// since Lua likes 1-indexing on tables.

#if (lua && fast_math)
abstract Vec3(lua.Table<Int, Float>) {
#else
abstract Vec3(Vector<Float>) {
#end
	public var x(get, set): Float;
	public var y(get, set): Float;
	public var z(get, set): Float;

#if (lua && fast_math)
	@:noCompletion public inline function get_x() return this[1];
	@:noCompletion public inline function get_y() return this[2];
	@:noCompletion public inline function get_z() return this[3];

	@:noCompletion public inline function set_x(v: Float) {
		this[1] = v;
		return v;
	}
	@:noCompletion public inline function set_y(v: Float) {
		this[2] = v;
		return v;
	}
	@:noCompletion public inline function set_z(v: Float) {
		this[3] = v;
		return v;
	}

	@:noCompletion @:arrayAccess public inline function get(k: Int): Float return this[k+1];
	@:noCompletion @:arrayAccess public inline function set(k: Int, v: Float) this[k+1] = v;
#else
	@:noCompletion public inline function get_x() return this[0];
	@:noCompletion public inline function get_y() return this[1];
	@:noCompletion public inline function get_z() return this[2];

	@:noCompletion public inline function set_x(v: Float) {
		this[0] = v;
		return v;
	}
	@:noCompletion public inline function set_y(v: Float) {
		this[1] = v;
		return v;
	}
	@:noCompletion public inline function set_z(v: Float) {
		this[2] = v;
		return v;
	}

	@:noCompletion @:arrayAccess public inline function get(k: Int): Float return this[k];
	@:noCompletion @:arrayAccess public inline function set(k: Int, v: Float) this[k] = v;
#end

#if (lua && fast_math)
	public function new(x: Float = 0, y: Float = 0, z: Float = 0) {
		this = lua.Table.create([ x, y, z ]);
	}
#else
	public inline function new(x: Float = 0, y: Float = 0, z: Float = 0) {
		this = new Vector<Float>(3);

		this[0] = x;
		this[1] = y;
		this[2] = z;
	}
#end

	public static inline function unit_x() {
		return new Vec3(1, 0, 0);
	}

	public static inline function unit_y() {
		return new Vec3(0, 1, 0);
	}

	public static inline function unit_z() {
		return new Vec3(0, 0, 1);
	}

	public static inline function forward() {
		return new Vec3(0, -1, 0);
	}

	public static inline function right() {
		return unit_x();
	}

	public static inline function up() {
		return unit_z();
	}

	@:op(A + B)
	public function add(b: Vec3) {
		var a: Vec3 = cast this;
		return new Vec3(a.x + b.x, a.y + b.y, a.z + b.z);
	}

	@:op(A - B)
	public function sub(b: Vec3) {
		var a: Vec3 = cast this;
		return new Vec3(a.x - b.x, a.y - b.y, a.z - b.z);
	}

	@:op(A / B)
	public function div(b: Vec3) {
		var a: Vec3 = cast this;
		return new Vec3(a.x / b.x, a.y / b.y, a.z / b.z);
	}

	@:op(A * B)
	public function mul(b: Vec3) {
		var a: Vec3 = cast this;
		return new Vec3(a.x * b.x, a.y * b.y, a.z * b.z);
	}

	@:op(A / B)
	public function fdiv(b: Float) {
		var a: Vec3 = cast this;
		return new Vec3(a.x / b, a.y / b, a.z / b);
	}

	@:op(A * B)
	public function scale(b: Float) {
		var a: Vec3 = cast this;
		return new Vec3(a.x * b, a.y * b, a.z * b);
	}

	@:op(-A)
	public inline function neg() {
		return scale(-1);
	}

	public function length() {
		var self: Vec3 = cast this;
		return Math.sqrt(self.lengthsq());
	}

	public inline function lengthsq() {
		var self: Vec3 = cast this;
		return self.x * self.x + self.y * self.y + self.z * self.z;
	}

	public function normalize() {
		var a: Vec3 = cast this;
		var l = a.lengthsq();
		if (l == 0) {
			return;
		}
		l = Math.sqrt(l);
		a.x /= l;
		a.y /= l;
		a.z /= l;
	}

	public function rotate(phi: Float, axis: Vec3) {
		var a: Vec3 = cast this;
		var u = axis.copy();
		u.normalize();
		var c = Math.cos(phi);
		var s = Math.sin(phi);

		// Calculate generalized rotation matrix
		var m1 = new Vec3((c + u.x * u.x * (1 - c)),       (u.x * u.y * (1 - c) - u.z * s), (u.x * u.z * (1 - c) + u.y * s));
		var m2 = new Vec3((u.y * u.x * (1 - c) + u.z * s), (c + u.y * u.y * (1 - c)),       (u.y * u.z * (1 - c) - u.x * s));
		var m3 = new Vec3((u.z * u.x * (1 - c) - u.y * s), (u.z * u.y * (1 - c) + u.x * s), (c + u.z * u.z * (1 - c)));

		return new Vec3(
			Vec3.dot(a, m1),
			Vec3.dot(a, m2),
			Vec3.dot(a, m3)
		);
	}

	public static function cross(a: Vec3, b: Vec3) {
		return new Vec3(
			a.y * b.z - a.z * b.y,
			a.z * b.x - a.x * b.z,
			a.x * b.y - a.y * b.x
		);
	}

	public static inline function distance(a: Vec3, b: Vec3) {
		var dx = a.x - b.x;
		var dy = a.y - b.y;
		var dz = a.z - b.z;
		return Math.sqrt(dx * dx + dy * dy + dz * dz);
	}

	public function trim(max_len: Float) {
		var self: Vec3 = cast this;
		var len = Math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z);
		if (len > max_len) {
			self.x /= len;
			self.y /= len;
			self.z /= len;
			self.x *= max_len;
			self.y *= max_len;
			self.z *= max_len;
		}
	}

	public static function min(a: Vec3, b: Vec3) {
		return new Vec3(
			Utils.min(a.x, b.x),
			Utils.min(a.y, b.y),
			Utils.min(a.z, b.z)
		);
	}

	public static function max(a: Vec3, b: Vec3) {
		return new Vec3(
			Utils.max(a.x, b.x),
			Utils.max(a.y, b.y),
			Utils.max(a.z, b.z)
		);
	}

	public static function dot(a: Vec3, b: Vec3) {
		return a.x * b.x + a.y * b.y + a.z * b.z;
	}

	public inline function copy() {
		var self: Vec3 = cast this;
		return new Vec3(self.x, self.y, self.z);
	}

	public static function lerp(low: Vec3, high: Vec3, progress: Float): Vec3 {
		return ((high - low) + low) * progress;
	}

#if lua
	public inline function unpack(): lua.Table<Int, Float> {
#if fast_math
		return this;
#else
		var self: Vec3 = cast this;
		return lua.Table.create([ self.x, self.y, self.z ]);
#end
	}
#end
}
