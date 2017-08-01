import love.Love;
import love.event.EventModule as Event;
import love.keyboard.KeyboardModule as Keyboard;
import love.timer.TimerModule as Timer;
import love.mouse.MouseModule as Mouse;
import imgui.*;
import systems.Render;
import systems.PlayerController;
import ui.MainMenu;
import Profiler.SegmentColor;
import timer.Timer as ScriptTimer;

enum WindowType {
	EditorUI;
	CameraDebug;
	PlayerDebug;
	Inventory;
	ProfilerUI;
	Log;
}

enum UIPanelCategory {
	Settings;
	Entities;
	Selection;
}

typedef UIPanelFn = Void->Void;

typedef UIPanelEntry = {
	var label: String;
	var cb: UIPanelFn;
}

typedef UIPanel = {
	var type: UIPanelCategory;
	var panels: Array<UIPanelEntry>;
	var dock_at: Null<String>;
}

class Main {
	static var world: World;
	static var open_windows: Array<WindowType> = [];

	public static var player: Player;
	public static var debug_mode = false;
	public static var editing = false;

	public static var panels: Array<UIPanel> = [];

	public static function showing_menu(window) {
		return open_windows.indexOf(window) >= 0;
	}

	public static function toggle_window(window) {
		var idx = open_windows.indexOf(window);
		if (idx >= 0) {
			open_windows.splice(idx, 1);
			return;
		}
		open_windows.push(window);
	}

	static function main() {
		Splash.init();
	}

	public static function init() {
		Language.load("en");

		var scale = 1.0;
		if (love.Love.getVersion().minor == 10) {
			scale = love.window.WindowModule.getPixelScale();
		}
		#if imgui
		ImGui.set_global_font("assets/fonts/NotoSans-Regular.ttf", 16*scale, 0, 0, 2, 2);

		var cats = UIPanelCategory.createAll();
		for (v in cats) {
			panels.push({
				type: v,
				panels: [],
				dock_at: v == UIPanelCategory.Selection? "Bottom" : null
			});
		}

		// Style.push_var("WindowRounding", 0, 0);
		// Style.push_var("ChildWindowRounding", 0, 0);
		// Style.push_var("FrameRounding", 0, 0);

		Style.push_color("Text", 1.00, 1.00, 1.00, 1.00);
		Style.push_color("WindowBg", 0.07, 0.07, 0.08, 0.98);
		Style.push_color("PopupBg", 0.07, 0.07, 0.08, 0.98);
		Style.push_color("CheckMark", 0.15, 1.0, 0.4, 0.91);
		Style.push_color("Border", 0.70, 0.70, 0.70, 0.20);
		Style.push_color("FrameBg", 0.80, 0.80, 0.80, 0.12);
		Style.push_color("FrameBgHovered", 0.04, 0.50, 0.78, 1.00);
		Style.push_color("FrameBgActive", 0.15, 0.52, 0.43, 1.00);
		Style.push_color("TitleBg", 0.15, 0.52, 0.43, 0.76);
		Style.push_color("TitleBgCollapsed", 0.11, 0.22, 0.23, 0.50);
		Style.push_color("TitleBgActive", 0.15, 0.52, 0.43, 1.00);
		Style.push_color("MenuBarBg", 0.07, 0.07, 0.11, 0.76);
		Style.push_color("ScrollbarBg", 0.26, 0.29, 0.33, 1.00);
		Style.push_color("ScrollbarGrab", 0.40, 0.43, 0.47, 0.76);
		Style.push_color("ScrollbarGrabHovered", 0.28, 0.81, 0.68, 0.76);
		Style.push_color("ScrollbarGrabActive", 0.96, 0.66, 0.06, 1.00);
		Style.push_color("SliderGrab", 0.28, 0.81, 0.68, 0.47);
		Style.push_color("SliderGrabActive", 0.96, 0.66, 0.06, 0.76);
		Style.push_color("Button", 0.22, 0.74, 0.61, 0.47);
		Style.push_color("ButtonHovered", 0.00, 0.48, 1.00, 1.00);
		Style.push_color("ButtonActive", 0.83, 0.57, 0.04, 0.76);
		Style.push_color("Header", 0.22, 0.74, 0.61, 0.47);
		Style.push_color("HeaderHovered", 0.07, 0.51, 0.92, 0.76);
		Style.push_color("HeaderActive", 0.96, 0.66, 0.06, 0.76);
		Style.push_color("Column", 0.22, 0.74, 0.61, 0.47);
		Style.push_color("ColumnHovered", 0.28, 0.81, 0.68, 0.76);
		Style.push_color("ColumnActive", 0.96, 0.66, 0.06, 1.00);
		Style.push_color("ResizeGrip", 0.22, 0.74, 0.61, 0.47);
		Style.push_color("ResizeGripHovered", 0.28, 0.81, 0.68, 0.76);
		Style.push_color("ResizeGripActive", 0.96, 0.66, 0.06, 0.76);
		Style.push_color("CloseButton", 0.00, 0.00, 0.00, 0.47);
		Style.push_color("CloseButtonHovered", 0.00, 0.00, 0.00, 0.76);
		Style.push_color("PlotLinesHovered", 0.22, 0.74, 0.61, 1.00);
		// Style.push_color("PlotHistogram", 0.78, 0.21, 0.21, 1.0);
		Style.push_color("PlotHistogram", 0.15, 0.52, 0.43, 1.00);
		Style.push_color("PlotHistogramHovered", 0.96, 0.66, 0.06, 1.00);
		Style.push_color("TextSelectedBg", 0.22, 0.74, 0.61, 0.47);
		Style.push_color("ModalWindowDarkening", 0.20, 0.20, 0.20, 0.69);

		ImGui.new_frame();
		#end

		Mouse.setVisible(showing_menu(EditorUI));

		EntityList.init();
		GameInput.init();

		var player = new Player();

		Render.init();
		World.init(player);
		Stage.init(player);
		ui.Anchor.update();
		ui.HUD.init();
		Profiler.start_frame();

		Love.mousepressed  = mousepressed;
		Love.mousereleased = mousereleased;
		Love.mousemoved    = mousemoved;
		Love.wheelmoved    = wheelmoved;
		Love.textinput     = textinput;
		Love.keypressed    = keypressed;
		Love.keyreleased   = keyreleased;
		Love.load          = load;
		Love.draw          = draw;
		Love.quit          = quit;
		Love.resize        = resize;
		Love.focus         = focus;
	}

	public static function unbind() {
		Love.mousepressed  = null;
		Love.mousereleased = null;
		Love.mousemoved    = null;
		Love.wheelmoved    = null;
		Love.textinput     = null;
		Love.keypressed    = null;
		Love.keyreleased   = null;
		Love.load          = null;
		Love.draw          = null;
		Love.quit          = null;
		Love.resize        = null;
		Love.focus         = null;
	}

	static var show_profiler = false;

	static function load(args: lua.Table<Dynamic, Dynamic>) {
		var boot_editor = false;
		lua.PairTools.ipairsEach(args, function(i, v: String) {
			if (v == "--perf") {
				show_profiler = true;
				return;
			}
			if (v == "--editor") {
				boot_editor = true;
				return;
			}
		});

		if (boot_editor) {
			toggle_window(WindowType.EditorUI);
			editing = true;
			// Mouse.setRelativeMode(false);
		}
	}

	static function resize(w: Float, h: Float) {
		Render.resize(w, h);
	}

	static function mousepressed(x: Float, y: Float, button: Float, istouch: Bool) {
#if imgui
		if (!Mouse.getRelativeMode()) {
			Input.mousepressed(button);
		}
#end
	}

	static function mousereleased(x: Float, y: Float, button: Float, istouch: Bool) {
#if imgui
		if (!Mouse.getRelativeMode()) {
			Input.mousereleased(button);
		}
#end
	}

	static function mousemoved(x: Float, y: Float, dx: Float, dy: Float, istouch: Bool) {
#if imgui
		if (!Mouse.getRelativeMode()) {
			Input.mousemoved(x, y);
		}
#end
	}

	static function wheelmoved(x: Float, y: Float) {
#if imgui
		if (!Mouse.getRelativeMode()) {
			Input.wheelmoved(y);
		}
#end
	}

	static function textinput(str: String) {
#if imgui
		if (!Mouse.getRelativeMode()) {
			Input.textinput(str);
		}
#end
	}

	static function keypressed(key: String, scan: String, isrepeat: Bool) {
		if (!isrepeat) {
			GameInput.keypressed(key);
		}

		if (key == "escape" && Keyboard.isDown("lshift", "rshift")) {
			Event.quit();
		}

#if imgui
		Input.keypressed(key);
#end
	}

	static function keyreleased(key: String) {
		GameInput.keyreleased(key);

#if imgui
		if (!Mouse.getRelativeMode()) {
			Input.keyreleased(key);
		}
#end
	}

	public static function respawn(use_spawn = false) {
		//Player.spawn(use_spawn? player.spawn_point : Editor.cursor, player, emitter);
	}

	public static var show_style_editor = false;
	static var has_focus = true;

	static function focus(focus: Bool) {
		has_focus = focus;
	}

	public static function register_panel(cat: UIPanelCategory, label: String, fn: UIPanelFn) {
		panels[cat.getIndex()].panels.push({
			label: label,
			cb: fn
		});
	}

	static var tick: Float = 0;
	static var tick_rate: Float = 1/60;

	static function draw() {
		var dt = Timer.getDelta();
		ui.Anchor.update();

		// MainMenu.draw();

		if (Keyboard.isDown("tab")) {
			dt *= 4;
		}

#if imgui
		if (show_style_editor) {
			ImGui.show_style_editor();
		}
#end

		GameInput.update(dt);
		GameInput.bind(GameInput.Action.Debug_F5, function() {
			Event.quit("restart");
			return true;
		});

		GameInput.bind(GameInput.Action.Debug_F1, function() {
			toggle_window(WindowType.EditorUI);
			Mouse.setVisible(showing_menu(EditorUI));
			return true;
		});

		ScriptTimer.update(dt);

		// significantly reduce framerate if out of focus while in editor mode.
		if (editing && !has_focus) {
			Timer.sleep(0.1);
		}

		Profiler.start_frame();

		// tick += dt;
		// while (tick >= tick_rate) {
		// 	tick -= tick_rate;
			Stage.update(dt);
			World.update(dt);
		// }

		Profiler.push_block("GC", new SegmentColor(0.5, 0.0, 0.0));

		lua.Lua.collectgarbage(lua.Lua.CollectGarbageOption.Step, 20);

		Profiler.pop_block();
		Profiler.end_frame();
#if imgui
		ImGui.render();
		ImGui.new_frame();
#end
	}

	static function quit(): Bool {
#if imgui
		ImGui.shutdown();
#end

		return false;
	}
}
