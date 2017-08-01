package imgui;

#if imgui

@:luaRequire("imgui")
extern class Input {
	@:native("GetWantCaptureKeyboard")
	static function get_want_capture_keyboard(): Bool;
	@:native("GetWantCaptureMouse")
	static function get_want_capture_mouse(): Bool;
	@:native("MouseMoved")
	static function mousemoved(x: Float, y: Float): Void;
	@:native("MousePressed")
	static function mousepressed(button: Float): Void;
	@:native("MouseReleased")
	static function mousereleased(button: Float): Void;
	@:native("WheelMoved")
	static function wheelmoved(y: Float): Void;
	@:native("KeyPressed")
	static function keypressed(key: String): Void;
	@:native("KeyReleased")
	static function keyreleased(key: String): Void;
	@:native("TextInput")
	static function textinput(text: String): Void;
}

#end
