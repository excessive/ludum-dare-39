package math;

abstract BitField(Int) {
	public inline function new(v: Int) this = v;
	public inline function set(i: Int) this |= 1 << i;
	public inline function unset(i: Int) this &= ~(1 << i);
	public inline function toggle(i: Int) this ^= 1 << i;
	public inline function is_set(i: Int): Bool return (this & (1 << i)) != 0;
	public inline function flipped() return new BitField(this ^ ~0);

	@:op(A & B)
	public inline function band(b: BitField) {
		return new BitField(this & cast b);
	}

	@:op(A | B)
	public inline function bor(b: BitField) {
		return new BitField(this | cast b);
	}

	@:op(A ^ B)
	public inline function bxor(b: BitField) {
		return new BitField(this ^ cast b);
	}
}
