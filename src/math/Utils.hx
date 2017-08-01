package math;

@:publicFields
class Utils {
	static inline function min(a: Float, b: Float): Float {
#if (lua && fast_math)
		return lua.Math.min(a, b);
#else
		return Math.min(a, b);
#end
	}

	static inline function max(a: Float, b: Float): Float {
#if (lua && fast_math)
		return lua.Math.max(a, b);
#else
		return Math.max(a, b);
#end
	}

	// Haxe doesn't always provide deg/rad, but Lua does.
	static inline function rad(v: Float): Float {
#if lua
		return lua.Math.rad(v);
#else
		return v*(Math.PI/180);
#end
	}
	static inline function deg(v: Float): Float {
#if lua
		return lua.Math.deg(v);
#else
		return v/(Math.PI/180);
#end
	}
	static inline function map(value: Float, min_in: Float, max_in: Float, min_out: Float, max_out: Float): Float {
		return ((value) - (min_in)) * ((max_out) - (min_out)) / ((max_in) - (min_in)) + (min_out);
	}
	static function clamp(v: Float, low: Float, high: Float): Float {
		return max(min(v, high), low);
	}
	static function lerp(low: Float, high: Float, progress: Float): Float {
		return ((high - low) + low) * progress;
	}
	static function sign(value: Float): Float {
		return value < 0? -1 : (value > 0? 1 : 0);
	}

	static function normal(triangle: World.Triangle): Vec3 {
		var ba = triangle.v1 - triangle.v0;
		var ca = triangle.v2 - triangle.v0;
		var n = Vec3.cross(ba, ca);
		n.normalize();
		return n;
	}

	/** Returns `value` if it is equal or greater than |`size`|, or 0. **/
	static inline function deadzone(value: Float, size: Float): Float {
		return Math.abs(value) >= size? value : 0;
	}

	/** return if value is equal or greater than threshold. **/
	static inline function threshold(value: Float, threshold): Bool {
		// I know, it barely saves any typing at all.
		return Math.abs(value) >= threshold;
	}

	static function rotate_bounds(mtx: Mat4, min: Vec3, max: Vec3) {
		var verts = [
			mtx * new Vec3(min.x, min.y, max.z),
			mtx * new Vec3(max.x, min.y, max.z),
			mtx * new Vec3(min.x, max.y, max.z),
			mtx * new Vec3(max.x, min.y, min.z),
			mtx * new Vec3(max.x, max.y, min.z),
			mtx * new Vec3(min.x, max.y, min.z)
		];
		var new_min = mtx * min;
		var new_max = mtx * max;
		for (v in verts) {
			new_min = Vec3.min(new_min, v);
			new_max = Vec3.max(new_max, v);
		}
		return {
			min: new_min,
			max: new_max
		};
	}

	/*
--- Check if value is equal or less than threshold.
-- @param value
-- @param threshold
-- @return boolean
function utils.tolerance(value, threshold)
	-- I know, it barely saves any typing at all.
	return abs(value) <= threshold
end
	*/

}
