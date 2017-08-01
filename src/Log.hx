import ui.LogWindow;

enum Level {
	Debug;
	Info;
	Item;
	Quest;
	System;
}

class Log {
	public static function write(level: Level, msg: String) {
		var line = "[" + level.getName() + "] " + msg;
#if imgui
		LogWindow.push(line);
#end
		Sys.println(line);
	}
}
