package ui;

#if imgui

import imgui.MenuBar.*;
import imgui.Widget;

import Main.*;
import Main.WindowType;
import love.mouse.MouseModule as Mouse;
import love.event.EventModule as Event;

class MainMenu {
	public static function draw() {
		editing = showing_menu(WindowType.EditorUI);
		if (!Mouse.getRelativeMode() || editing) {
			if (begin_main()) {

				if (begin_menu("File")) {
					Widget.separator();
					if (menu_item("Exit")) {
						Event.quit();
					}
					end_menu();
				}

				if (begin_menu("Debug")) {
					if (menu_item("Style Editor...")) {
						show_style_editor = !show_style_editor;
					}
					end_menu();
				}

				if (begin_menu("Window")) {
					if (menu_item("Camera...")) {
						toggle_window(WindowType.CameraDebug);
					}
					if (menu_item("Editor...", "F1")) {
						toggle_window(WindowType.EditorUI);
					}
					if (menu_item("Player Debug...", "F2")) {
						toggle_window(WindowType.PlayerDebug);
					}
					if (menu_item("Log...")) {
						toggle_window(WindowType.Log);
					}
					if (menu_item("Profiler...")) {
						toggle_window(WindowType.ProfilerUI);
					}
					end_menu();
				}

			}
			end_main();
		}
	}
}

#end
