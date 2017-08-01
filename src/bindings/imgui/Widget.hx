package imgui;

#if imgui

import lua.Table;

@:luaRequire("imgui")
extern class Widget {
	@:native("GetCursorPosX")
	static function get_cursor_pos_x(): Float;
	@:native("GetCursorPosY")
	static function get_cursor_pos_y(): Float;
	@:native("SetCursorPosX")	
	static function set_cursor_pos_x(x: Float): Void;
	@:native("SetCursorPosY")
	static function set_cursor_pos_y(y: Float): Void;
	@:native("SetCursorPos")
	static function set_cursor_pos(x: Float, y: Float): Void;
	@:native("Image")
	static function image(image: Dynamic, width: Float, height: Float, u0: Float, v0: Float, u1: Float, v1: Float): Void;
	@:native("Checkbox")
	static function checkbox(label: String, enabled: Bool): Bool;
	@:native("Button")
	static function button(label: String, width: Float = 0.0, height: Float = 0.0): Bool;
	@:native("SmallButton")
	static function small_button(label: String, width: Float = 0.0, height: Float = 0.0): Bool;
	@:native("SetScrollHere")
	static function set_scroll_here(where: Float): Void;
	@:native("Bullet")
	static function bullet(): Void;
	@:native("Indent")
	static function indent(width: Float = 0): Void;
	@:native("Unindent")
	static function unindent(width: Float = 0): Void;
	@:native("SameLine")
	static function same_line(width: Float = 0): Void;
	@:native("NewLine")
	static function new_line(): Void;
	@:native("SliderInt")
	static function slider_int(label: String, value: Int, min: Int, max: Int): RetInt;
	@:native("SliderFloat")
	static function slider_float(label: String, value: Float, min: Float, max: Float): RetFloat;
	@:native("SliderFloat2")
	static function slider_float2(label: String, f1: Float, f2: Float, min: Float, max: Float): RetFloat2;
	@:native("InputFloat")
	static function input_float(label: String, f1: Float): RetFloat;
	@:native("InputFloat2")
	static function input_float2(label: String, f1: Float, f2: Float): RetFloat2;
	@:native("InputFloat3")
	static function input_float3(label: String, f1: Float, f2: Float, f3: Float): RetFloat3;
	@:native("DragFloat")
	static function drag_float(label: String, f1: Float, speed: Float, min: Float, max: Float): RetFloat;
	@:native("DragFloat2")
	static function drag_float2(label: String, f1: Float, f2: Float, speed: Float, min: Float, max: Float): RetFloat2;
	@:native("DragFloat3")
	static function drag_float3(label: String, f1: Float, f2: Float, f3: Float, speed: Float, min: Float, max: Float): RetFloat3;
	@:native("ColorEdit3")
	static function color_edit3(label: String, r: Float, g: Float, b: Float): RetFloat3;
	@:native("ColorEdit4")
	static function color_edit4(label: String, r: Float, g: Float, b: Float, a: Float): RetFloat4;
	@:native("Text")
	static function text(text: String): Void;
	@:native("Value")
	static function value(text: String, v: Float): Void;
	@:native("TextWrapped")
	static function text_wrapped(text: String): Void;
	@:native("Separator")
	static function separator(): Void;
	@:native("Spacing")
	static function spacing(): Void;
	@:native("Selectable")
	private static function _selectable(label: String, selected: Bool, flags: Null<Int>, width: Float, height: Float): Bool;
	static inline function selectable(label: String, selected: Bool, width: Float = 0.0, height: Float = 0.0): Bool {
		return _selectable(label, selected, null, width, height);
	}
	@:native("Combo")
	private static function _combo(label: String, selected: Int, items: Table<Int, String>, item_count: Int): RetCombo;
	static inline function combo(label: String, selected: Int, items: Array<String>): Int {
		var t = Table.create();
		for (v in items) {
			Table.insert(t, v);
		}
		return _combo(label, selected, t, items.length).selected;
	}
	@:native("PushID")
	static function push_id(label: String): Void;
	@:native("PopID")
	static function pop_id(): Void;
	@:native("BeginGroup")
	static function begin_group(): Void;
	@:native("EndGroup")
	static function end_group(): Void;
	@:native("SetNextTreeNodeOpen")
	static function set_next_tree_node_open(state: Bool, ?cond: String): Void;
	@:native("TreeNode")
	static function _tree_node(label: String): Bool;
	static inline function tree_node(label: String, default_open: Bool = false): Bool {
		if (default_open) {
			set_next_tree_node_open(true, "FirstUseEver");
		}
		return _tree_node(label);
	}
	@:native("TreePop")
	static function tree_pop(): Void;
}

@:multiReturn
extern class RetCombo {
	var status: String;
	var selected: Int;
}

@:multiReturn
extern class RetFloat {
	var status: String;
	var f1: Float;
}

@:multiReturn
extern class RetFloat2 {
	var status: String;
	var f1: Float;
	var f2: Float;
}

@:multiReturn
extern class RetFloat3 {
	var status: String;
	var f1: Float;
	var f2: Float;
	var f3: Float;
}

@:multiReturn
extern class RetFloat4 {
	var status: String;
	var f1: Float;
	var f2: Float;
	var f3: Float;
	var f4: Float;
}

@:multiReturn
extern class RetInt {
	var status: String;
	var i1: Int;
}

#end
