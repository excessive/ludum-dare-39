package ui;

#if imgui
import imgui.Widget;
import imgui.Window;
import imgui.MenuBar;
import Main.WindowType;

@:publicFields
class PlayerDebugWindow {
	static function draw(e: Entity) {
		GameInput.bind(GameInput.Action.Debug_F2, function() {
			Main.toggle_window(WindowType.PlayerDebug);
			return true;
		});

		if (!Main.showing_menu(WindowType.PlayerDebug)) {
			return;
		}

		// var flags = lua.Table.create(["MenuBar"]);
		var flags = null;
		if (Window.begin("Player Debug", null, flags)) {
			// if (MenuBar.begin()) {
				//
			// }
			// MenuBar.end();

			var p = e.player;
			Helpers.any_value("Battery", p.battery);
			Helpers.any_value("Max Battery", p.max_battery);
			Helpers.any_value("Damage", p.damage);
			Helpers.any_value("HP", p.hp);
			Helpers.any_value("Shield", p.shield);
			Helpers.any_value("iframes", p.iframes);
		}
		Window.end();
	}
}

#end
