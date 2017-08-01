package ui;

#if imgui

import imgui.Widget;
import imgui.Window;

@:publicFields
class CameraDebugWindow {
	static function draw(camera: Camera) {
		if (!Main.showing_menu(Main.WindowType.CameraDebug)) {
			return;
		}

		if (Window.begin("Camera")) {
			Widget.text("orbit");
			var ret = Widget.slider_float("X##orbit", camera.offset[0], -10, 10);
			camera.offset[0] = ret.f1;
			ret = Widget.slider_float("Y##orbit", camera.offset[1], -10, 10);
			camera.offset[1] = ret.f1;
			ret = Widget.slider_float("Z##orbit", camera.offset[2], -10, 10);
			camera.offset[2] = ret.f1;

			Widget.text("offset");
			ret = Widget.slider_float("X##offset", camera.orbit_offset[0], -10, 10);
			camera.orbit_offset[0] = ret.f1;
			ret = Widget.slider_float("Y##offset", camera.orbit_offset[1], -10, 10);
			camera.orbit_offset[1] = ret.f1;
			ret = Widget.slider_float("Z##offset", camera.orbit_offset[2], -10, 10);
			camera.orbit_offset[2] = ret.f1;

			Widget.value("clip distance", camera.clip_distance);
		}
		Window.end();
	}
}

#end
