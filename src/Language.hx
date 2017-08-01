import i18n.I18n;
import love.filesystem.FilesystemModule as Fs;
import lua.Table;

class Language {
	static var data = new I18n();
	public static function load(locale) {
		var base = "assets/locales/";
		var files = Fs.getDirectoryItems(base);

		Table.foreach(files, function(i, v) {
			var filename = base + v;
			if (filename.lastIndexOf(".lua") == filename.length - 4) {
				data.load(filename);
			}
		});

		data.set_locale(locale);
		if (locale != "en") {
			data.set_fallback("en");
		}
	}
	public static inline function get_data(key) {
		return data.get(key);
	}
	public static inline function get(key) {
		return data.get(key).text;
	}
}
