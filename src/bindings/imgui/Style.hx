package imgui;

#if imgui

@:luaRequire("imgui")
extern class Style {
	@:native("PushStyleColor")
	static function push_color(key: String, r: Float, g: Float, b: Float, a: Float = 1.0): Void;
	@:native("PopStyleColor")
	static function pop_color(count: Int = 1): Void;
	@:native("PushStyleVar")
	static function push_var(key: String, x: Float, y: Float = 0): Void;
	@:native("PopStyleVar")
	static function pop_var(count: Int = 1): Void;
}

#end