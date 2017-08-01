#if imgui

import love.timer.TimerModule as Timer;
import haxe.ds.GenericStack as Stack;
import imgui.Widget;
import imgui.Window;
import imgui.Style;
#end

import math.Vec3;
import math.Utils;

abstract SegmentColor(Vec3) {
	public inline function new(r, g, b) {
		this = new Vec3(r, g, b);
	}

	public var r(get, never): Float;
	public var g(get, never): Float;
	public var b(get, never): Float;

	public inline function get_r() return this[0];
	public inline function get_g() return this[1];
	public inline function get_b() return this[2];

	public static var Render = new SegmentColor(1.0, 0.0, 0.0);
	public static var Default = new SegmentColor(0.0, 0.5, 1.0);
	public static var Player = new SegmentColor(1.0, 0.5, 0.0);
	public static var Animation = new SegmentColor(1.0, 0.0, 0.5);
	public static var World = new SegmentColor(0.25, 0.5, 0.25);
}

#if imgui
private typedef TimeSegment = {
	color: SegmentColor,
	marker: Bool,
	source: String,
	label: String,
	start: Float,
	duration: Float,
	memory: Float
}

private typedef Frame = {
	data: Array<TimeSegment>,
	start: Float,
	duration: Float,
	fps: Float,
	delta: Float,
	memory: Float
}

class Profiler {
	static var time_stack = new Stack<TimeSegment>();
	static var this_frame: Frame = {
		data: [],
		start: 0.0,
		duration: 0.0,
		fps: 0.0,
		delta: 0.0,
		memory: 0.0
	};
	static var pause_frame: Null<Frame> = null;
	static var frame_history: Array<Frame> = [];
	static var sample_rate: Float = 1/30;
	static var history_length: Int = Std.int((1/sample_rate) * 5);
	static var last_update: Float = -1.0;

	static var slowest = new Map<String, Float>();
	static var fastest = new Map<String, Float>();

	static function render(frame: Frame) {
		frame.data.sort(function(a, b) return a.start > b.start ? 1 : -1);

		GameInput.bind(GameInput.Action.Debug_F4, function() {
			if (pause_frame == null) {
				pause_frame = frame;
			}
			else {
				pause_frame = null;
			}
			return true;
		});

		if (Window.begin("Profiler", null)) {
			Widget.value("FPS", frame.fps);
			Widget.same_line(150);
			Widget.value("frame ms/f", Std.int(frame.delta*100000)/100.0);
			Widget.same_line(300);
			Widget.value("GC Memory (MiB)", frame.memory / 1024);

			Widget.value("UPS", 1.0/frame.duration);
			Widget.same_line(150);
			Widget.value("update ms/f", Std.int(frame.duration*100000)/100.0);

			Widget.spacing();

			var height = 0;
			for (time in frame.data) {
				if (time.marker) {
					continue;
				}
				height++;
			}

			var spacing = 18;
			Style.push_color("ChildWindowBg", 0.0, 0.0, 0.0, 0.5);
			Window.begin_child("Graph", 0, height*spacing, true, lua.Table.create(["NoInputs"]));
			var size = Window.get_content_region_max();
			var scale = frame.duration / size[0];

			var i = 0;
			for (time in frame.data) {
				if (time.marker) {
					continue;
				}
				var key = time.source;

				if (pause_frame == null) {
					Style.push_color("Button", time.color.r, time.color.g, time.color.b, 0.1);
					Widget.set_cursor_pos_x(time.start / scale);
					Widget.set_cursor_pos_y(spacing * i);
					Widget.button("", slowest[key] / scale, spacing);
				}

				Style.push_color("Button", time.color.r, time.color.g, time.color.b, 1.0);
				Widget.set_cursor_pos_x(time.start / scale);
				Widget.set_cursor_pos_y(spacing * i);
				Widget.button("", time.duration / scale, spacing);

				if (pause_frame == null) {
					Style.push_color("Button", time.color.r / 2, time.color.g / 2, time.color.b / 2, 0.75);
					Widget.set_cursor_pos_x(time.start / scale);
					Widget.set_cursor_pos_y(spacing * i);
					Widget.button("", fastest[key] / scale, spacing);
					Style.pop_color(3);
				}
				else {
					Style.pop_color(1);
				}
				i++;
			}

			for (time in frame.data) {
				Widget.set_cursor_pos_x(time.start / scale);
				Widget.set_cursor_pos_y(0);
				Style.push_color("Button", time.color.r, time.color.g, time.color.b, 1);
				Widget.button("", 1, height*spacing);
				Style.pop_color();
			}

			i = 0;
			for (time in frame.data) {
				Widget.set_cursor_pos_x(time.start / scale + 2);
				Widget.set_cursor_pos_y(spacing * i - 1);
				if (!time.marker) {
					Widget.text(time.label + " (" + Std.string(Std.int(time.duration * 100000) / 100.0) + "ms)");
					i++;
				}
				else {
					Widget.text(time.label);
				}
			}

			Window.end_child();
			Style.pop_color();
		}
		Window.end();
	}

	public static function end_frame() {
		if (!time_stack.isEmpty()) {
			var str = "";
			for (entry in time_stack) {
				str += "\n\t- " + entry.source + " (" + entry.label + ")";
			}
			Log.write(Log.Level.Debug, "Profiler stack dirty at end of frame. Contents: " + str);
			while (!time_stack.isEmpty()) {
				time_stack.pop();
			}
		}

		var now = Timer.getTime();
		this_frame.duration = now - this_frame.start;
		this_frame.fps = Timer.getFPS();
		this_frame.delta = Timer.getDelta();
		this_frame.memory = lua.Lua.collectgarbage(lua.Lua.CollectGarbageOption.Count);

		var len: Float = frame_history.length;
		var frame: Frame = this_frame;
		for (seg in frame.data) {
			var key = seg.source;
			if (!slowest.exists(key) || !fastest.exists(key)) {
				slowest[key] = seg.duration;
				fastest[key] = seg.duration;
			}
			else {
				slowest[key] = Utils.max(slowest[key], seg.duration);
				fastest[key] = Utils.min(fastest[key], seg.duration);
			}
		}

		if (pause_frame != null) {
			frame = pause_frame;
		}
		else if (len > 0) {
			var fd = new Map<String, TimeSegment>();
			frame = {
				data: [],
				start: now,
				duration: 0.0,
				fps: 0.0,
				delta: 0.0,
				memory: 0.0
			};

			for (f in frame_history) {
				frame.duration += f.duration;
				frame.delta += f.delta;
				frame.fps += f.fps;
				frame.memory += f.memory;
				for (seg in f.data) {
					var key = seg.source;
					if (!fd.exists(seg.source)) {
						fd[key] = {
							color: seg.color,
							marker: seg.marker,
							source: seg.source,
							label: seg.label,
							start: seg.start,
							duration: seg.duration,
							memory: seg.memory
						};
					}
					else {
						var avs = fd[key];
						avs.duration += seg.duration;
						avs.start += seg.start;
						avs.memory += seg.memory;
					}
				}
			}
			for (d in fd) {
				d.duration /= len;
				d.start /= len;
				d.memory /= len;
				frame.data.push(d);
			}
			frame.duration /= len;
			frame.delta /= len;
			frame.fps /= len;
			frame.memory /= len;
		}

		if (Main.showing_menu(Main.WindowType.ProfilerUI)) {
			render(frame);
		}
	}

	// throw out the first few frames - they take ages.
	static var first_update = 0;
	public static function load_zone() {
		first_update = 0;
	}

	public static function start_frame() {
		GameInput.bind(GameInput.Action.Debug_F3, function() {
			Main.toggle_window(Main.WindowType.ProfilerUI);
			return true;
		});

		var now = Timer.getTime();
		if (now - last_update >= sample_rate || frame_history.length < history_length) {
			if (first_update < 4) {
				first_update++;
				if (first_update == 4) {
					slowest = new Map<String, Float>();
					fastest = new Map<String, Float>();
				}
			}
			else {
				last_update = now;
				frame_history.push(this_frame);
			}
			if (frame_history.length > history_length) {
				var take = frame_history.length - history_length;
				frame_history.splice(0, take);
			}
		}
		this_frame = {
			data: [],
			start: now,
			duration: 0.0,
			fps: 0.0,
			delta: 0.0,
			memory: 0.0
		};
	}

	public static function marker(label: String, ?color: SegmentColor, ?pos: haxe.PosInfos) {
		if (color == null) {
			color = SegmentColor.Default;
		}
		this_frame.data.push({
			color: color,
			marker: true,
			source: pos.className + "." + pos.methodName + "@" + pos.fileName + ":" + Std.string(pos.lineNumber) + label,
			label: label,
			start: Timer.getTime() - this_frame.start,
			duration: 0.0,
			memory: lua.Lua.collectgarbage(lua.Lua.CollectGarbageOption.Count)
		});
	}

	public static function push_block(label: String, ?color: SegmentColor, ?pos: haxe.PosInfos) {
		if (color == null) {
			color = SegmentColor.Default;
		}
		time_stack.add({
			color: color,
			marker: false,
			source: pos.className + "." + pos.methodName + "@" + pos.fileName + ":" + Std.string(pos.lineNumber) + label,
			label: label,
			start: Timer.getTime() - this_frame.start,
			duration: 0.0,
			memory: lua.Lua.collectgarbage(lua.Lua.CollectGarbageOption.Count)
		});
	}

	public static function pop_block(?pos: haxe.PosInfos) {
		if (time_stack.isEmpty()) {
			var source = pos.className + "." + pos.methodName + "@" + pos.fileName + ":" + Std.string(pos.lineNumber);
			Log.write(Log.Level.Debug, "Attempt to pop empty profiler stack from " + source);
			return;
		}
		var block = time_stack.first();
		block.duration = Timer.getTime() - this_frame.start - block.start;

		this_frame.data.push(time_stack.pop());
	}
}

#else
class Profiler {
	public static inline function push_block(label: String, ?color: SegmentColor, ?pos: haxe.PosInfos) {}
	public static inline function pop_block(?pos: haxe.PosInfos) {}
	public static inline function marker(label: String, ?color: SegmentColor, ?pos: haxe.PosInfos) {}
	public static inline function start_frame() {}
	public static inline function end_frame() {}
	public static inline function load_zone() {}
}

#end
