package imgui;

#if imgui

@:luaRequire("imgui")
extern class MenuBar {
	@:native("BeginMainMenuBar")
	static function begin_main(): Bool;
	@:native("EndMainMenuBar")
	static function end_main(): Void;
	@:native("BeginMenuBar")
	static function begin(): Bool;
	@:native("EndMenuBar")
	static function end(): Void;
	@:native("BeginMenu")
	static function begin_menu(label: String): Bool;
	@:native("EndMenu")
	static function end_menu(): Void;
	@:native("MenuItem")
	static function menu_item(label: String, ?shortcut: String, ?selected: Bool, ?enabled: Bool = true): Bool;
}

#end
