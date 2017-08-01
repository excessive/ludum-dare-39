package math;

#if lua
import cpml.Vec3 as CpmlVec3;
#end

@:publicFields
class Ray {
	var position: Vec3;
	var direction: Vec3;

	function new(p: Vec3, d: Vec3) {
		this.position  = p;
		this.direction = d;
	}

#if lua
	inline function to_cpml() {
		return {
			position:  new CpmlVec3(this.position[0], this.position[1], this.position[2]),
			direction: new CpmlVec3(this.direction[0], this.direction[1], this.direction[2])
		};
	}
#end
}
