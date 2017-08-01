package ai;

import math.BitField;

class WorldState {
	public var values = new BitField(0);
	public var dontcare = new BitField(~0);
	public function new() {}
}
