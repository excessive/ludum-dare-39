package systems;

import iqm.Iqm;
import iqm.Iqm.IqmFile;
import anim9.Anim9;
import math.Vec3;
import math.Mat4;
import math.Utils;
import World.Triangle;

import components.Drawable.CollisionType;

class Loader extends System {
	override function filter(e: Entity) {
		if (e.drawable != null) {
			return true;
		}
		return false;
	}

	static function convert(t: lua.Table<Int, Dynamic>) {
		var tris = [];
		lua.PairTools.ipairsEach(t, function(i, v) {
			var v0 = new Vec3(v[1].position[1], v[1].position[2], v[1].position[3]);
			var v1 = new Vec3(v[2].position[1], v[2].position[2], v[2].position[3]);
			var v2 = new Vec3(v[3].position[1], v[3].position[2], v[3].position[3]);
			var t: Triangle = { v0: v0, v1: v1, v2: v2, vn: new Vec3() };
			t.vn = Utils.normal(t);
			tris.push(t);
		});
		return tris;
	}

	var meshes = new Map<String, IqmFile>();
	function load_mesh(filename: String, actor: Bool) {
		var load_key = filename;
		if (actor) {
			load_key += "_Actor_";
		}
		if (!meshes.exists(load_key)) {
			Log.write(Log.Level.System, "load mesh " + filename);
			meshes[load_key] = Iqm.load(filename, actor, false);
		}
		return meshes[load_key];
	}

	override function process(e: Entity, dt: Float) {
		if (e.drawable != null) {
			if (e.drawable.mesh == null) {
				var actor = e.drawable.collision == CollisionType.Triangle;
				e.drawable.mesh = load_mesh(e.drawable.filename, actor);
				if (actor) {
					var tris = convert(e.drawable.mesh.triangles);
					var xform = new Mat4();
					if (e.transform != null) {
						xform *= Mat4.scale(e.transform.scale);
						xform *= Mat4.rotate(e.transform.orientation);
						xform *= Mat4.translate(e.transform.position);
					}
					World.add_triangles(xform, tris);
				}
			}
		}
		if (e.attachments != null) {
			for (attach in e.attachments) {
				if (attach.mesh == null) {
					attach.mesh = load_mesh(attach.filename, false);
				}
			}
		}
		if (e.animation != null) {
			if (e.animation.timeline == null) {
				var data = Iqm.load_anims(e.animation.filename);
				e.animation.timeline = new Anim9(data);
				var tl = e.animation.timeline;
				if (tl != null && e.animation.anims.length > 0) {
					for (f in e.animation.anims) {
						tl.add_animation(Iqm.load_anims(f));
					}
				}
				if (tl != null) {
					var run = tl.new_track("run");
					tl.play(run);
				}
				else {
					untyped __lua__("for k, v in pairs(data.frames) do print(k, v) end");
				}
			}
		}
	}
}
