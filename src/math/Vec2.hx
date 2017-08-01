package math;

import haxe.ds.Vector;

abstract Vec2(Vector<Float>) {
	public var x(get, set): Float;
	public var y(get, set): Float;

	@:noCompletion public inline function set_x(v: Float) {
		this[0] = v;
		return v;
	}
	@:noCompletion public inline function set_y(v: Float) {
		this[1] = v;
		return v;
	}

	@:noCompletion public inline function get_x() return this[0];
	@:noCompletion public inline function get_y() return this[1];

	public inline function new(x: Float = 0, y: Float = 0) {
		this = new Vector<Float>(2);

		this[0] = x;
		this[1] = y;
	}

	public static inline function unit_x() {
		return new Vec2(1, 0);
	}

	public static inline function unit_y() {
		return new Vec2(0, 1);
	}

	@:noCompletion
	@:arrayAccess
	public inline function get(k: Int) {
		return this[k];
	}

	@:noCompletion
	@:arrayAccess
	public inline function set(k: Int, v: Float) {
		this[k] = v;
		return v;
	}

	@:op(-A)
	public inline function neg() {
		return scale(-1);
	}

	@:op(A * B)
	public inline function scale(b: Float) {
		return new Vec2(this[0] * b, this[1] * b);
	}

	public inline function length() {
		return Math.sqrt(this[0] * this[0] + this[1] * this[1]);
	}

	public inline function lengthsq() {
		return this[0] * this[0] + this[1] * this[1];
	}

	public static inline function distance(a: Vec2, b: Vec2) {
		var dx = a.x - b.x;
		var dy = a.y - b.y;
		return Math.sqrt(dx * dx + dy * dy);
	}

	public function normalize() {
		var l = this[0] * this[0] + this[1] * this[1];
		if (l == 0) {
			return;
		}
		l = Math.sqrt(l);
		this[0] /= l;
		this[1] /= l;
	}

	public function angle_to(?other: Vec2) {
		if (other != null) {
			return Math.atan2(other[1] - this[1], other[0] - this[0]);
		}
		return Math.atan2(this[1], this[0]);
	}
}
