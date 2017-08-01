class Signal {
	static var signals = new Map<String, Array<Dynamic->Void>>();

	public static function register(event: String, fn: Dynamic->Void) {
		if (!signals.exists(event)) {
			signals[event] = [];
		}
		signals[event].push(fn);
	}

	public static function unregister(event: String, fn: Dynamic->Void) {
		if (!signals.exists(event)) {
			return;
		}
		var cbs = signals[event];
		var idx = cbs.indexOf(fn);
		if (idx >= 0) {
			cbs.splice(idx, 1);
		}
	}

	public static function emit(event: String, ?data: Dynamic) {
		if (!signals.exists(event)) {
			return;
		}
		var cbs = signals[event];
		for (cb in cbs) {
			cb(data);
		}
	}
}
