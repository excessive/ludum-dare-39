package math;

typedef HitResult            = { point: Vec3, distance: Float }
typedef CapsuleCapsuleResult = { p1: Vec3, p2: Vec3 }
typedef ClosestPointResult   = { p1: Vec3, p2: Vec3, dist2: Float, s: Float, t: Float }

class Intersect {
	public static inline function encapsulate_aabb(outer: Bounds, inner: Bounds) {
		return
			outer.min.x <= inner.min.x &&
			outer.max.x >= inner.max.x &&
			outer.min.y <= inner.min.y &&
			outer.max.y >= inner.max.y &&
			outer.min.z <= inner.min.z &&
			outer.max.z >= inner.max.z
		;
	}

	public static inline function aabb_aabb(a: Bounds, b: Bounds) {
		return 
			a.min.x <= b.max.x &&
			a.max.x >= b.min.x &&
			a.min.y <= b.max.y &&
			a.max.y >= b.min.y &&
			a.min.z <= b.max.z &&
			a.max.z >= b.min.z
		;
	}

	public static function aabb_frustum(aabb: Bounds, frustum: Frustum) {

		// We have 6 planes defining the frustum, 5 if infinite.
#if (lua && fast_math)
		var box = lua.Table.create();
		box[1] = aabb.min;
		box[2] = aabb.max;

		var n = 6;
		var planes = lua.Table.create();
		planes[1] = frustum.left;
		planes[2] = frustum.right;
		planes[3] = frustum.bottom;
		planes[4] = frustum.top;
		planes[5] = frustum.near;
		planes[6] = frustum.far;
#else
		var box = [ aabb.min, aabb.max ];
		var n = 5;
		var planes = [
			frustum.left,
			frustum.left,
			frustum.right,
			frustum.bottom,
			frustum.top,
			frustum.near
		];

		// Skip the last test for infinite projections, it'll never fail.
		if (frustum.far != null) {
			planes.push(frustum.far);
			n += 1;
		}
#end

		for (i in 1...n) {
			// This is the current plane
			var p = planes[i+1];

			// p-vertex selection (with the index trick)
			// According to the plane normal we can know the
			// indices of the positive vertex

			// writing it this way fixes stupid lua codegen
			var px;
			var py;
			var pz;
#if (lua && fast_math)
			if (p.x > 0.0) px = 2; else px = 1;
			if (p.y > 0.0) py = 2; else py = 1;
			if (p.z > 0.0) pz = 2; else pz = 1;
#else
			if (p.x > 0.0) px = 1; else px = 0;
			if (p.y > 0.0) py = 1; else py = 0;
			if (p.z > 0.0) pz = 1; else pz = 0;
#end

			// project p-vertex on plane normal
			// (How far is p-vertex from the origin)
			var dot = (p.x * box[px].x) + (p.y * box[py].y) + (p.z * box[pz].z);

			// Doesn't intersect if it is behind the plane
			if (dot < -p.w) {
				return false;
			}
		}

		return true;
	}

	public static function ray_aabb(ray: Ray, aabb: Bounds): Null<HitResult> {
		var dir = ray.direction.copy();
		dir.normalize();

		var dirfrac = new Vec3(1 / dir.x, 1 / dir.y, 1 / dir.z);

		var t1 = (aabb.min.x - ray.position.x) * dirfrac.x;
		var t2 = (aabb.max.x - ray.position.x) * dirfrac.x;
		var t3 = (aabb.min.y - ray.position.y) * dirfrac.y;
		var t4 = (aabb.max.y - ray.position.y) * dirfrac.y;
		var t5 = (aabb.min.z - ray.position.z) * dirfrac.z;
		var t6 = (aabb.max.z - ray.position.z) * dirfrac.z;

		var tmin = Utils.max(Utils.max(Utils.min(t1, t2), Utils.min(t3, t4)), Utils.min(t5, t6));
		var tmax = Utils.min(Utils.min(Utils.max(t1, t2), Utils.max(t3, t4)), Utils.max(t5, t6));

		// ray is intersecting AABB, but whole AABB is behind us
		if (tmax < 0) {
			return null;
		}

		// ray does not intersect AABB
		if (tmin > tmax) {
			return null;
		}

		// Return collision point and distance from ray origin
		return {
			point: ray.position + ray.direction * tmin,
			distance: tmin
		};
	}

	public static function ray_triangle(ray: Ray, triangle: World.Triangle): Null<HitResult> {
		var e1 = triangle.v1 - triangle.v0;
		var e2 = triangle.v2 - triangle.v0;
		var h  = Vec3.cross(ray.direction, e2);
		var a  = Vec3.dot(h, e1);

		var epsilon = 1.19209290e-07;

		// if a is too close to 0, ray does not intersect triangle
		if (Math.abs(a) <= epsilon) {
			return null;
		}

		var f = 1 / a;
		var s = ray.position - triangle.v0;
		var u = Vec3.dot(s, h) * f;

		// ray does not intersect triangle
		if (u < 0 || u > 1) {
			return null;
		}

		var q = Vec3.cross(s, e1);
		var v = Vec3.dot(ray.direction, q) * f;

		// ray does not intersect triangle
		if (v < 0 || u + v > 1) {
			return null;
		}

		// at this stage we can compute t to find out where
		// the intersection point is on the line
		var t = Vec3.dot(q, e2) * f;

		// return position of intersection and distance from ray origin
		if (t >= epsilon) {
			return {
				point: ray.position + ray.direction * t,
				distance: t
			};
		}

		// ray does not intersect triangle
		return null;
	}


	public static function capsule_capsule(c1: Capsule, c2: Capsule): Null<CapsuleCapsuleResult> {
		var ret    = closest_point_segment_segment(c1.a, c1.b, c2.a, c2.b);
		var radius = c1.radius + c2.radius;

		if (ret.dist2 <= radius * radius) {
			return {
				p1: ret.p1,
				p2: ret.p2
			};
		}

		return null;
	}

	public static function closest_point_segment_segment(p1: Vec3, p2: Vec3, p3: Vec3, p4: Vec3): ClosestPointResult {
		var epsilon = 1.19209290e-07;

		var c1: Vec3;  // Collision point on segment 1
		var c2: Vec3;  // Collision point on segment 2
		var s:  Float; // Distance of intersection along segment 1
		var t:  Float; // Distance of intersection along segment 2

		var d1: Vec3  = p2 - p1; // Direction of segment 1
		var d2: Vec3  = p4 - p3; // Direction of segment 2
		var r:  Vec3  = p1 - p3;
		var a:  Float = Vec3.dot(d1, d1);
		var e:  Float = Vec3.dot(d2, d2);
		var f:  Float = Vec3.dot(d2, r);

		// Check if both segments degenerate into points
		if (a <= epsilon && e <= epsilon) {
			c1 = p1;
			c2 = p3;
			s  = 0;
			t  = 0;

			return {
				p1:    c1,
				p2:    c2,
				dist2: Vec3.dot(c1 - c2, c1 - c2),
				s:     s,
				t:     t
			};
		}

		// Check if segment 1 degenerates into a point
		if (a <= epsilon) {
			s = 0;
			t = Utils.clamp(f / e, 0.0, 1.0);
		} else {
			var c = Vec3.dot(d1, r);

			// Check is segment 2 degenerates into a point
			if (e <= epsilon) {
				s = Utils.clamp(-c / a, 0.0, 1.0);
				t = 0;
			} else {
				var b     = Vec3.dot(d1, d2);
				var denom = a * e - b * b;

				if (Math.abs(denom) > 0) {
					s = Utils.clamp((b * f - c * e) / denom, 0.0, 1.0);
				} else {
					s = 0;
				}

				t = (b * s + f) / e;

				if (t < 0) {
					s = Utils.clamp(-c / a, 0.0, 1.0);
					t = 0;
				} else if (t > 1) {
					s = Utils.clamp((b - c) / a, 0.0, 1.0);
					t = 1;
				}
			}
		}

		c1 = p1 + d1 * s;
		c2 = p3 + d2 * t;

		return {
			p1:    c1,
			p2:    c2,
			dist2: Vec3.dot(c1 - c2, c1 - c2),
			s:     s,
			t:     t
		};
	}
}
