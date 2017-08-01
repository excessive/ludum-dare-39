import math.Vec3;
import components.Drawable;
import components.Transform;
import love.filesystem.FilesystemModule as Fs;
import lua.PairTools;

typedef EntityData = {
	var filename: String;
}

class EntityList {
	public static var available_entities: Array<EntityData> = [];

	static function collect_r(path): Array<EntityData> {
		var ret = [];
		var items = Fs.getDirectoryItems(path);

		PairTools.ipairsEach(items, function(i: Int, file: String) {
			var filename = path + "/" + file;
			if (Fs.isFile(filename)) {
				ret.push({
					filename: filename
				});
				return;
			}
			if (Fs.isDirectory(filename)) {
				var merge = collect_r(filename);
				for (v in merge) {
					ret.push(v);
				}
				return;
			}
		});

		return ret;
	}

	public static function init() {
		available_entities = collect_r("assets/models");
	}

	public static function spawn(at: Vec3, data: EntityData) {
		var e = {
			transform: new Transform(at.copy()),
			drawable: new Drawable(data.filename)
		};
		World.add(e);
		// Editor.selected = e;
	}
}
