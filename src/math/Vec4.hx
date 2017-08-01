package math;

import haxe.ds.Vector;

abstract Vec4(Vector<Float>) {
	public var x(get, set): Float;
	public var y(get, set): Float;
	public var z(get, set): Float;
	public var w(get, set): Float;

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
	@:noCompletion public inline function set_w(v: Float) {
		this[3] = v;
		return v;
	}

	@:noCompletion public inline function get_x() return this[0];
	@:noCompletion public inline function get_y() return this[1];
	@:noCompletion public inline function get_z() return this[2];
	@:noCompletion public inline function get_w() return this[3];

	public function new(a: Float = 0, b: Float = 0, c: Float = 0, d: Float = 0) {
		this = new Vector(4);

		this[0] = a;
		this[1] = b;
		this[2] = c;
		this[3] = d;
	}

	@:arrayAccess
	@:noCompletion
	public inline function get(k: Int) {
		return this[k];
	}

	@:arrayAccess
	@:noCompletion
	public inline function set(k: Int, v: Float) {
		this[k] = v;
	}

	public function normalize() {
		var l = this[0] * this[0] + this[1] * this[1] + this[2] * this[2] + this[3] * this[3];
		if (l == 0) {
			return;
		}
		l = Math.sqrt(l);
		for (i in 0...4) {
			this[i] /= l;
		}
	}
}
