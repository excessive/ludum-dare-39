package ui;

#if imgui

import imgui.Window;
import imgui.Widget;
import Main.WindowType;

class LogWindow {
	static var messages: Array<String> = [];
	public static inline function push(msg) {
		messages.push(msg);
	}
	public static function draw() {
		GameInput.bind(GameInput.Action.Debug_F3, function() {
			Main.toggle_window(WindowType.Log);
			return true;
		});

		if (!Main.showing_menu(WindowType.Log)) {
			return;
		}

		Window.set_next_window_size(550, 350);
		if (Window.begin_dock("Log")) {
			for (msg in messages) {
				Widget.text_wrapped(msg);
			}
			Widget.set_scroll_here(1.0);
		}
		Window.end_dock();
	}
}

#end
