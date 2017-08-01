package cpml;

@:luaRequire("cpml.modules.vec3")
extern class Vec3 {
	function new(?x: Float, ?y: Float, ?z: Float);
	var x: Float;
	var y: Float;
	var z: Float;
}
