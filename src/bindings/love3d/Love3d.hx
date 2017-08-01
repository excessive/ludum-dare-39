package love3d;

import love.graphics.Canvas;
import love.graphics.CanvasFormat;

@:enum
abstract DepthTestMethod(String) {
	var None = null;
	var Greater = "greater";
	var Equal = "equal";
	var Less = "less";
}

@:enum
abstract CullMode(String) {
	var None = null;
	var Front = "front";
	var Back = "back";
}

@:luaRequire("love3d")
extern class Love3d {
	@:native("import")
	static function prepare(): Void;
	static function set_depth_test(method: DepthTestMethod = DepthTestMethod.None): Void;
	static function set_depth_write(enabled: Bool = true): Void;
	static function set_culling(mode: CullMode = CullMode.None): Void;
	static function clear(color: Bool = false, depth: Bool = true): Void;
	static function new_canvas(?width:Float, ?height:Float, ?format:CanvasFormat, ?msaa:Float, ?gen_depth:Bool): Canvas;
}
