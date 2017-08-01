package cpml;

import lua.Table;

typedef Vec4 = {
	var a: Float;
	var b: Float;
	var c: Float;
	var d: Float;
}

typedef Frustum = {
	var left: Vec4;
	var right: Vec4;
	var bottom: Vec4;
	var top: Vec4;
	var near: Vec4;
	var far: Vec4;
}

typedef HitFn = Ray->Table<Int, Dynamic>->Table<Int, Dynamic>->Dynamic;

@:luaRequire("cpml.modules.octree")
extern class Octree {
	function new(initialWorldSize: Float, initialWorldPos: Vec3, minNodeSize: Float = 1, looseness: Float = 1);

	function add(obj: Dynamic, bounds: Bounds): Void;
	function remove(obj: Dynamic): Bool;

	function get_colliding(bounds: Bounds): Table<Int, Dynamic>;
	function get_colliding_frustum(frustum: Frustum): Table<Int, Dynamic>;

	function cast_ray(ray: Ray, func: HitFn, ?t: Table<Int, Dynamic>): Null<Dynamic>;
}
