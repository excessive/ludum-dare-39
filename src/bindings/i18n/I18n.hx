package i18n;

@:multiReturn
extern class I18nRet {
	var text: String;
	var audio: Null<String>; // might not work correctly
	var fallback: Bool;
}

@:luaRequire("i18n")
extern class I18n {
	// @:native("new")
	function new();
	function load(file: String): Bool;
	function set_fallback(locale: String): Void;
	function set_locale(locale: String): Void;
	function invalidate_cache(): Void;
	function get(key: String): I18nRet;
}

// class I18n {
// 	var internal: I18nExtern;
// 	public inline function new() {
// 		internal = I18nExtern._new();
// 	}
// 	public inline function load(file) {
// 		return internal.load(file);
// 	}
// 	public inline function set_fallback(locale) {
// 		return internal.set_fallback(locale);
// 	}
// 	public inline function set_locale(locale) {
// 		return internal.set_locale(locale);
// 	}
// 	public inline function invalidate_cache() {
// 		return internal.invalidate_cache();
// 	}
// 	public inline function get(key): I18nRet {
// 		return internal.get(key);
// 	}
// }
