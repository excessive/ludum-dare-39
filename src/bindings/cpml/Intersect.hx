package cpml;

import haxe.extern.EitherType;
import lua.Table;

@:multiReturn
extern class RayResult {
	var point: EitherType<Bool, Vec3>;
	var distance: Float;
}

@:luaRequire("cpml.modules.intersect")
extern class Intersect {
	static function ray_aabb(ray: Ray, aabb: Bounds): RayResult;
	static function ray_triangle(ray: Ray, triangle: Table<Int, Vec3>): RayResult;
}
