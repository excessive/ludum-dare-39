package imgui;

#if imgui

import lua.Table;

@:luaRequire("imgui")
extern class Window {
	@:native("Begin")
	static function begin(label: String, ?initial: Null<Bool>, ?flags: Table<Int, String>): Bool;
	@:native("End")
	static function end(): Void;
	@:native("BeginDockspace")
	static function begin_dockspace(): Void;
	@:native("EndDockspace")
	static function end_dockspace(): Void;
	@:native("SetDockActive")
	static function set_dock_active(): Void;
	@:native("SetNextDock")
	static function set_next_dock(slot: String): Void;
	@:native("BeginDock")
	static function begin_dock(label: String, ?opened: Bool, ?flags: Table<Int, String>): Bool;
	@:native("EndDock")
	static function end_dock(): Void;
	@:native("BeginChild")
	static function begin_child(label: String, width: Float = 0.0, height: Float = 0.0, border: Bool = false, ?flags: Table<Int, String>): Bool;
	@:native("EndChild")
	static function end_child(): Void;
	@:native("SetNextDockSplitRatio")
	static function set_next_dock_split_ratio(x: Float = 0.5, y: Float = 0.5): Void;
	@:native("SetNextWindowPos")
	static function set_next_window_pos(x: Float, y: Float, ?initial: Bool): Void;
	@:native("SetNextWindowSize")
	static function set_next_window_size(width: Float, height: Float, ?initial: Bool): Void;
	@:native("GetContentRegionMax")
	private static function _get_content_region_max(): RetVec2;
	static inline function get_content_region_max(): Array<Float> {
		var v = _get_content_region_max();
		return [ v.f1, v.f2 ];
	}
}

@:multiReturn
extern class RetVec2 {
	var f1: Float;
	var f2: Float;
}

#end
