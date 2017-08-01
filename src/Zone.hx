import haxe.Json;
import love.filesystem.FilesystemModule as Fs;
import components.Transform;
import math.Vec3;
import math.Quat;

import components.Drawable;
import components.Drawable.CollisionType;
import components.Drawable.ShaderType;

typedef ZoneData = {
	var version: Int;
	var spawns: Array<{
		id: Int,
		type: Int
	}>;
	var entities: Array<{
		id: Int,
		collision: Int,
		model: String,
		pos: Array<Float>,
		rot: Array<Float>,
		scale: Array<Float>
	}>;
}

class Zone {
	static var map_version: Int = 2;

	public static function load(path: String) {
		var saved = Fs.read(path);

		if (saved.contents != null) {
			var data: ZoneData = Json.parse(saved.contents);

			var version = 0;
			if (data.version != null) {
				version = data.version;
			}

			// reserve the entity list so that our IDs work
			var entities: Array<Entity> = [];
			var max_id: Int = 0;
			max_id = Std.int(Math.max(max_id, data.entities.length));
			max_id = Std.int(Math.max(max_id, data.spawns.length));
			for (i in 0...max_id) {
				entities.push({});
			}

			for (spawn in data.spawns) {
				var target = entities[spawn.id];
				target.npc = {
					id: Entity.NPCId.createByIndex(spawn.type)
				}
			}

			for (entity in data.entities) {
				var target = entities[entity.id];
				target.transform = new Transform(
					new Vec3(entity.pos[0], entity.pos[1], entity.pos[2]),
					new Vec3(),
					new Quat(entity.rot[0], entity.rot[1], entity.rot[2], entity.rot[3])
				);
				if (version >= 2) {
					target.transform.scale = new Vec3(entity.scale[0], entity.scale[1], entity.scale[2]);
				}
				var collidable = CollisionType.None;
				var shader = ShaderType.Basic;
				if (version >= 1) {
					collidable = CollisionType.createByIndex(entity.collision);
				}
				// HACK: force triplanar shader on drawables
				if (collidable == CollisionType.Triangle) {
					shader = ShaderType.Terrain;
				}
				if (entity.model.length != 0) {
					target.drawable = new Drawable(entity.model, collidable, shader);
				}
			}

			World.new_entities(path, entities);
		}
	}

	public static function save(entities: Array<Entity>, path: String) {
		var data = {
			version: map_version,
			spawns: [],
			entities: [],
		};
		var id = 0;
		for (e in entities) {
			// skip the player and enemy entities, we don't want doppelgangers
			if (e.player != null || e.enemy != null) {
				continue;
			}
			if (e.transform != null) {
				var pos = e.transform.position;
				var rot = e.transform.orientation;
				var sca = e.transform.scale;
				var mesh = "";
				var coll = CollisionType.None;
				if (e.drawable != null) {
					mesh = e.drawable.filename;
					coll = e.drawable.collision;
				}
				data.entities.push({
					model: mesh,
					id: id,
					collision: coll.getIndex(),
					pos: [ pos[0], pos[1], pos[2] ],
					rot: [ rot[0], rot[1], rot[2], rot[3] ],
					scale: [ sca[0], sca[1], sca[2] ]
				});
			}
			if (e.npc != null) {
				var npc = e.npc;
				data.spawns.push({
					id: id,
					type: npc.id
				});
			}
			id += 1;
		}
		var out = Json.stringify(data);
		if (!Fs.isDirectory("assets/maps")) {
			Fs.createDirectory("assets/maps");
		}
		Fs.write(path, out);
	}
}
