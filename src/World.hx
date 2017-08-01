import systems.*;
import components.Drawable.CollisionType;
import math.Vec3;
import math.Mat4;
import math.Utils;
import math.Frustum as ActualFrustum;
import math.Octree as FancyOctree;
import cpml.Bounds;
import cpml.Intersect as CpmlIntersect;
import cpml.Vec3 as CpmlVec3;
import math.Ray;
import lua.PairTools;
import lua.Table;
import love.filesystem.FilesystemModule as Fs;

import Profiler.SegmentColor;

typedef Triangle = {
	var v0: Vec3;
	var v1: Vec3;
	var v2: Vec3;
	var vn: Vec3;
}

abstract Octree<T>(FancyOctree<T>) {
	public inline function new(size, pos, min, loose) {
		this = new FancyOctree(size, new Vec3(pos.x, pos.y, pos.z), min, loose);
	}

	public inline function cast_ray(ray: Ray, fn: math.Octree.HitFn<T>) {
		return this.cast_ray(ray, fn);
	}

	public inline function get_colliding(aabb: math.Bounds): Array<T> {
		return this.get_colliding(aabb);
	}

	public inline function get_colliding_frustum(frustum: ActualFrustum): Array<T> {
		return this.get_colliding_frustum(frustum);
	}

	public function add(obj: T, bounds: { min: Vec3, max: Vec3 }) {
		var min = bounds.min;
		var max = bounds.max;
		var size = max - min;
		var center = min + size / 2;
		return this.add(obj, new math.Bounds(center, size));
	}

	public inline function remove(obj: T) {
		return this.remove(obj);
	}
}

class World {
	static var entities: Array<Entity>;
	static var systems: Array<System>;

	static var player: Player;

	static var path: String = "assets/maps/untitled.map";

	static var triangles: Array<Triangle> = [];

	static var world_size = 2048;
	static var world_origin = new CpmlVec3(0, 0, 0);
	static var world_looseness = 1.1;
	static var octree: Octree<Triangle>;
	static var entity_octree: Octree<Entity>;

	static var is_local_map: Bool = false;

	public static function is_local() {
		return is_local_map;
	}

	public static function cast_ray(ray: Ray, fn: Vec3->Void) {
		octree.cast_ray(ray, function(r, entries) {
			for (entry in entries) {
				if (math.Intersect.ray_aabb(ray, entry.bounds) != null) {
					var hit = math.Intersect.ray_triangle(ray, entry.data);
					if (hit != null) {
						fn(hit.point);
					}
				}
			}
			return false;
		});
	}

	public static function nearest_hit(ray: Ray): Null<{triangle: Triangle, point: Vec3, distance: Float}> {
		var nearest: Float = 1e20;
		var closest_tri: Null<Triangle> = null;
		var closest_hit: Null<Vec3> = null;
		octree.cast_ray(ray, function(r, entries) {
			for (entry in entries) {
				if (math.Intersect.ray_aabb(ray, entry.bounds) != null) {
					var hit = math.Intersect.ray_triangle(ray, entry.data);
					if (hit != null) {
						var d = Vec3.distance(ray.position, hit.point);
						if (d < nearest) {
							nearest = d;
							closest_tri = entry.data;
							closest_hit = hit.point;
						}
					}
				}
			}
			return false;
		});

		if (closest_hit == null || closest_tri == null) {
			return null;
		}

		return {
			distance: nearest,
			triangle: closest_tri,
			point: closest_hit
		};
	}

	static var movement: Movement;

	public static function init(p: Player) {
		player = p;
		movement = new Movement();

		// NOTE: As of Haxe 3.4.2, with the Lua target it's unreliable to ref
		// these as static members of the classes as { filter: Foo.filter, ... }.
		// see this bug: https://github.com/HaxeFoundation/haxe/issues/6368
		systems = [
			new Loader(),
			p,
			new PlayerController(),
			new AI(),
			movement,
			new Animation(),
			new ParticleUpdate(),
			new ParticleCollision(),
			new CapsuleUpdate(),
			// new CapsuleCollision(),
			new Reaper(),
			//new Collision(),
			new Render()
		];
	}

	static inline function within(min1: Vec3, max1: Vec3, min2: Vec3, max2: Vec3) {
		return
			min1[0] <= max2[0] &&
			max1[0] >= min2[0] &&
			min1[1] <= max2[1] &&
			max1[1] >= min2[1] &&
			min1[2] <= max2[2] &&
			max1[2] >= min2[2];
	}

	static inline function tri_min(v0: Vec3, v1: Vec3, v2: Vec3) {
		var min = v0.copy();
		min[0] = Utils.min(min[0], v1[0]);
		min[0] = Utils.min(min[0], v2[0]);
		min[1] = Utils.min(min[1], v1[1]);
		min[1] = Utils.min(min[1], v2[1]);
		min[2] = Utils.min(min[2], v1[2]);
		min[2] = Utils.min(min[2], v2[2]);
		return min;
	}

	static inline function tri_max(v0: Vec3, v1: Vec3, v2: Vec3) {
		var max = v0.copy();
		max[0] = Utils.max(max[0], v1[0]);
		max[0] = Utils.max(max[0], v2[0]);
		max[1] = Utils.max(max[1], v1[1]);
		max[1] = Utils.max(max[1], v2[1]);
		max[2] = Utils.max(max[2], v1[2]);
		max[2] = Utils.max(max[2], v2[2]);
		return max;
	}

	public static function get_triangles(min: Vec3, max: Vec3): Array<Triangle> {
		var size = max - min;
		var center = min + size / 2;
		var tris = octree.get_colliding(new math.Bounds(center, size));
		return tris;
	}

	public static function get_triangles_frustum(frustum: ActualFrustum): Array<Triangle> {
		return octree.get_colliding_frustum(frustum);
	}

	public static function enforce_bounds(e: Entity) {
		var kill_z = -5;
		var pos = e.transform.position;
		if (pos.z < kill_z) {
			World.remove(e);
			Main.respawn(true);
		}
	}

	public static function add_triangles(xform: Mat4, tris: Array<Triangle>) {
		for (t in tris) {
			var xt: Triangle = {
				v0: xform * t.v0,
				v1: xform * t.v1,
				v2: xform * t.v2,
				vn: xform * t.vn
			};

			var min = tri_min(xt.v0, xt.v1, xt.v2);
			var max = tri_max(xt.v0, xt.v1, xt.v2);

			var size = max - min;
			var center = min + size / 2;

			octree.add(xt, { min: min, max: max });
		}
	}

	public static function new_entities(new_path: String, new_entities: Array<Entity>) {
		entities = new_entities;
		path = new_path;

		// is_local_map = Fs.getRealDirectory(path).indexOf(Fs.getSaveDirectory()) >= 0;
		rebuild_octree();
	}

	public static function reload() {
		Zone.load(path);
	}

	public static function rebuild_octree() {
		// wipe octree, reload relevant models...
		octree = new Octree(world_size, world_origin, 2, world_looseness);
		entity_octree = new Octree(world_size, world_origin, 5, world_looseness);
		for (e in entities) {
			if (e.drawable == null || e.transform == null) {
				continue;
			}
			if (e.drawable.collision == CollisionType.Triangle) {
				e.drawable.mesh = null;
			}
		}
	}

	public static function save() {
		Zone.save(entities, path);
		// is_local_map = Fs.getRealDirectory(path).indexOf(Fs.getSaveDirectory()) >= 0;

		rebuild_octree();
	}

	public static inline function refresh_entity(e: Entity, bounds, add: Bool) {
		if (!add) {
			entity_octree.remove(e);
		}
		entity_octree.add(e, bounds);
	}

	public static inline function add(to_add: Entity) {
		entities.push(to_add);
	}

	public static function remove(to_remove: Entity) {
		var i = entities.length;
		while (i-- > 0) {
			if (entities[i] == to_remove) {
				entities.splice(i, 1);
			}
		}
		var d = to_remove.drawable;
		if (to_remove.transform != null && d != null && d.mesh != null) {
			entity_octree.remove(to_remove);
			movement.remove(to_remove);
		}
	}

	static var visible_entities: Array<Entity> = [];
	public static inline function update_visible(frustum: ActualFrustum) {
		visible_entities = entity_octree.get_colliding_frustum(frustum);
	}

	public static function filter(only_visible: Bool, fn: Entity->Bool): Array<Entity> {
		var relevant = [];
		var set = only_visible ? visible_entities : entities;
		for (entity in set) {
			if (fn(entity)) {
				relevant.push(entity);
			}
		}
		return relevant;
	}

	static var borked: Array<Dynamic> = [];
	static var current_bork: Dynamic = null;
	public static function update(dt: Float) {
		var log = function(err) {
			if (borked.indexOf(current_bork) >= 0) {
				return;
			}
			borked.push(current_bork);
			Log.write(Log.Level.System, "Error: " + err);
		}
		Profiler.push_block("world update", SegmentColor.World);
		for (system in systems) {
			var relevant = [];
			Profiler.push_block(system.PROFILE_NAME, system.PROFILE_COLOR);
			for (entity in entities) {
				if (system.filter(entity)) {
					relevant.push(entity);
					if (system.process != null) {
						current_bork = system.process;
						lua.Lua.xpcall(system.process, log, entity, dt);
					}
				}
			}
			if (system.update != null) {
				current_bork = system.update;
				lua.Lua.xpcall(system.update, log, relevant, dt);
			}
			Profiler.pop_block();
		}
		Profiler.pop_block();
	}
}
