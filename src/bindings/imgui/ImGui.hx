package imgui;

#if imgui

@:luaRequire("imgui")
extern class ImGui {
	@:native("Render")
	static function render(): Void;
	@:native("ShutDown")
	static function shutdown(): Void;
	@:native("NewFrame")
	static function new_frame(): Void;
	@:native("ShowStyleEditor")
	static function show_style_editor(): Void;
	@:native("SetGlobalFontFromFileTTF")
	static function set_global_font(path: String, size_pixels: Float, spacing_x: Float = 0, spacing_y: Float = 0, oversample_x: Float = 1, oversample_y: Float = 1): Void;
}

#end
