import lua.Table;
import love.graphics.Mesh;
import love.graphics.MeshDrawMode;
import love.graphics.SpriteBatchUsage;
import love.graphics.GraphicsModule as Lg;

import math.Vec3;
import math.Ray;

class Debug {
	static var mesh: Mesh;
	public static var cursor: Vec3 = new Vec3();

	static var vertices: Array<Array<Float>> = [];

	static var cube_indices = [
		0, 4, 1, 5, 2, 6, 3, 7, // sides
		0, 1, 0, 3, 2, 3, 2, 1, // top
		4, 5, 4, 7, 6, 7, 6, 5  // bottom
	];

	public static function init() {
		var fmt = Table.create();
		fmt[1] = Table.create([ "VertexPosition", "float", cast 3 ]);
		fmt[2] = Table.create([ "VertexColor", "float", cast 4 ]);
		mesh = Lg.newMesh(fmt, 65535, MeshDrawMode.Triangles, SpriteBatchUsage.Stream);
	}

	public static function line(v0: Vec3, v1: Vec3, r: Float = 1, g: Float = 1, b: Float = 1) {
		vertices.push([ v0[0], v0[1], v0[2], r*1, g*1, b*1, 1]);
		// love only gives us triangles, so dupe.
		vertices.push(vertices[vertices.length-1]);
		vertices.push([ v1[0], v1[1], v1[2], r*1, g*1, b*1, 1 ]);
	}

	public static function ray(ray: Ray, length: Float = 10, r: Float = 1, g: Float = 1, b: Float = 1) {
		line(ray.position, ray.position + ray.direction * length, r, g, b);
	}

	public static function axis(origin: Vec3, x: Vec3, y: Vec3, z: Vec3, length: Float = 1) {
		line(origin, origin+x*length, 1.0, 0.0, 0.0);
		line(origin, origin+y*length, 0.0, 1.0, 0.0);
		line(origin, origin+z*length, 0.0, 0.0, 1.0);
	}

	public static function aabb(min: Vec3, max: Vec3, r: Float = 1, g: Float = 1, b: Float = 1) {
		var cube_vertices = [
			new Vec3(min[0], min[1], max[2]),
			new Vec3(max[0], min[1], max[2]),
			new Vec3(max[0], max[1], max[2]),
			new Vec3(min[0], max[1], max[2]),
			new Vec3(min[0], min[1], min[2]),
			new Vec3(max[0], min[1], min[2]),
			new Vec3(max[0], max[1], min[2]),
			new Vec3(min[0], max[1], min[2])
		];

		var i = 1;
		for (j in 0...Std.int(cube_indices.length / 2)) {
			var i0 = cube_indices[i-1];
			var i1 = cube_indices[i];
			line(cube_vertices[i0], cube_vertices[i1], r, g, b);
			i += 2;
		}
	}

	public static function draw(wipe_only: Bool) {
		if (wipe_only || vertices.length == 0) {
			vertices = [];
			return;
		}

		var t = Table.create();
		for (i in 0...vertices.length) {
			t[i+1] = Table.create();
			for (j in 0...7) { // XYZRGBA
				t[i+1][j+1] = vertices[i][j];
			}
		}

		mesh.setVertices(t);
		mesh.setDrawRange(1, vertices.length);
		Lg.draw(mesh);

		vertices = [];
	}
}
