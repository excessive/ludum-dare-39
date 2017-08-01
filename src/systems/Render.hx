package systems;

import love.graphics.GraphicsModule as Lg;
import love.graphics.BlendAlphaMode;
import love.graphics.BlendMode;
import love.math.MathModule as Lm;
import love.mouse.MouseModule as Mouse;
import love.graphics.DrawMode;
import love.graphics.Canvas;
import love.graphics.CanvasFormat;
import love.graphics.Shader;
import love.graphics.Image;
import love.graphics.WrapMode;
import love.graphics.FilterMode;

import math.Utils;

import love3d.Love3d as L3d;
import love3d.Love3d.DepthTestMethod;
import love3d.Love3d.CullMode;

import components.Emitter.ParticleData;
import components.Drawable.ShaderType;
// import components.Drawable.CollisionType;

#if imgui
import ui.LogWindow;
import imgui.Window;
import imgui.Widget;
import imgui.Style;
#end

import math.Vec3;
import math.Mat4;

import Profiler.SegmentColor;

typedef Viewport = {
	var x: Float;
	var y: Float;
	var w: Float;
	var h: Float;
}

class Render extends System {
	static var shaders;
	static var camera: Camera = new Camera(new Vec3(0, 0, 10));

	static var main_canvas: Canvas;
	static var canvases: Array<Canvas>;
	static var edit_canvases: Array<Canvas>;

	static var r: Float = 15.0;
	static var g: Float = 15.0;
	static var b: Float = 15.0;
	static var exposure: Float = 1.5;
	static var vignette: Float = 0.75;

	static var ab: Bool = false;
	static var swap: {
		var r: Float;
		var g: Float;
		var b: Float;
	};

	static var texture: love.graphics.Image;
	static var grass: love.graphics.Mesh;
	static var short_grass: love.graphics.Mesh;

	static var wire_mode = false;

	static var game_aa = 4;
	static var edit_aa = 1;
	static var stage_speed = 7.5;

	public static function resize(w: Float, h: Float) {
		main_canvas = L3d.new_canvas(w, h, CanvasFormat.Rg11b10f, game_aa, true);
	}

	public static function gui_resize(w: Float, h: Float) {
		canvases = [
			L3d.new_canvas(w, h, CanvasFormat.Rg11b10f, game_aa, true),
			L3d.new_canvas(w, h, CanvasFormat.Rg11b10f, 1, false)
		];
		edit_canvases = [
			L3d.new_canvas(w/2, h/2, CanvasFormat.Rg11b10f, game_aa, true),
			L3d.new_canvas(w/2, h/2, CanvasFormat.Rgba8, edit_aa, true),
			L3d.new_canvas(w/2, h/2, CanvasFormat.Rgba8, edit_aa, true),
			L3d.new_canvas(w/2, h/2, CanvasFormat.Rgba8, edit_aa, true),
			L3d.new_canvas(w/2, h/2, CanvasFormat.Rg11b10f, 1, false)
		];
	}

	public static function init() {
		Lg.setBackgroundColor(89, 157, 220);
		L3d.prepare();

		Debug.init();

		resize(Lg.getWidth(), Lg.getHeight());
		gui_resize(2, 2);
		swap = {
			r: r,
			g: g,
			b: b
		};

		grass = iqm.Iqm.load("assets/models/tall-grass.iqm").mesh;
		short_grass = iqm.Iqm.load("assets/models/short-grass.iqm").mesh;

		Signal.register("killed player", function(e) {
			stage_speed = 0;
		});

		Signal.register("boss incoming", function(e) {
			stage_speed = 12;
		});

		Signal.register("boss battle", function(e) {
			stage_speed = 5;
		});

		Signal.register("stage start", function(e) {
			stage_speed = 7.5;
		});

		Signal.register("stage clear", function(e) {
			stage_speed = 15;
		});

		lua.Lua.xpcall(function() {
			shaders = {
				basic:    Lg.newShader("assets/shaders/basic.glsl"),
				sky:      Lg.newShader("assets/shaders/sky.glsl"),
				post:     Lg.newShader("assets/shaders/post.glsl"),
				debug:    Lg.newShader("assets/shaders/debug.glsl"),
				particle: Lg.newShader("assets/shaders/particle.glsl"),
				edit:     Lg.newShader("assets/shaders/edit.glsl"),
				terrain:  Lg.newShader("assets/shaders/terrain.glsl"),
				grass:    Lg.newShader("assets/shaders/grass.glsl")
			}
		}, lua.Lua.print);

		var flags = lua.Table.create();
		flags.mipmaps = true;
		texture = Lg.newImage("assets/textures/terrain.png", flags);
		texture.setWrap(WrapMode.Repeat, WrapMode.Repeat);
		texture.setFilter(FilterMode.Linear, FilterMode.Linear, 16);
	}

	override public function filter(e: Entity) {
		if (e.transform != null) {
			return true;
		}
		return false;
	}

	static function setColor(r: Float, g: Float, b: Float, a: Float) {
		Lg.setColor(r * 255.0, g * 255.0, b * 255.0, a * 255.0);
	}

	inline function send(shader: Shader, name: String, data: Dynamic) {
		var result = shader.getExternVariable(name);
		if (result != null && result.type != null) {
			shader.send(name, data);
		}
	}

	function send_uniforms(shader: Shader) {
		var w = Lg.getWidth();
		var h = Lg.getHeight();

		var view = new Mat4();
		var proj = Mat4.from_ortho(-w/2, w/2, h/2, -h/2, -500, 500);
		if (camera != null) {
			view = camera.view;
			proj = camera.projection;
			send(shader, "u_clips", new Vec3(camera.near, camera.far, 0).unpack());
		}

		var inv = view * proj;
		inv.invert();

		var ld = new Vec3(0.5, 0.5, 0.5);
		ld.normalize();
		send(shader, "u_fog_color", new Vec3(1.0, 2.0, 3.0).unpack());
		send(shader, "u_light_direction", ld.unpack());
		send(shader, "u_view", view.to_vec4s());
		send(shader, "u_projection", proj.to_vec4s());
		send(shader, "u_inv_view_proj", inv.to_vec4s());
	}

	static var grass_enabled = false;
	static var grass_range: Float = 50;
	static var grass_density: Float = 4;
	static var grass_seed: Int = 50;
	static var instances = [];

	function render_game(c: Canvas, entities: Array<Entity>, viewport: Viewport, debug_draw: Bool) {
		Profiler.marker("", SegmentColor.Render);

		var w = viewport.w;
		var h = viewport.h;

		if (camera != null) {
			camera.update(w, h);
		}

		var drawables = World.filter(true, function(e) { return e.drawable != null && e.transform != null; });

		Profiler.push_block("entity draw", SegmentColor.Render);
		Lg.setCanvas(c);
		var col = Lg.getBackgroundColor();
		Lg.clear(col.r, col.g, col.b, col.a);

		Lg.setShader(shaders.sky);
		send_uniforms(shaders.sky);
		L3d.set_depth_write(false);
		Lg.rectangle(DrawMode.Fill, -1, -1, 2, 2);

		L3d.set_depth_test(DepthTestMethod.Less);
		L3d.set_depth_write(true);
		L3d.set_culling(CullMode.Back);

		Lg.setShader(shaders.terrain);
		send_uniforms(shaders.terrain);
		send(shaders.terrain, "u_time", now);
		send(shaders.terrain, "u_speed", stage_speed);

		Lg.setShader(shaders.basic);
		send_uniforms(shaders.basic);

		L3d.clear();
		Lg.setBlendMode(BlendMode.Replace, BlendAlphaMode.Premultiplied);

		var last_shader = ShaderType.Basic;

		var wire_only = wire_mode;

		for (e in drawables) {
			var d = e.drawable;
			var xform = e.transform;

			if (d.mesh == null) {
				continue;
			}

			var shader = d.shader == ShaderType.Terrain ? shaders.terrain : shaders.basic;
			if (d.shader != last_shader) {
				var st = [
					ShaderType.Basic => shaders.basic,
					ShaderType.Terrain => shaders.terrain
				];
				Lg.setShader(st[d.shader]);
			}
			last_shader = d.shader;

			var mtx = xform.mtx;

			send(shader, "u_model", mtx.to_vec4s());

			var inv = mtx.copy();
			inv.invert();
			inv.transpose();

			send(shader, "u_normal_mtx", inv.to_vec4s());

			var animated = e.animation != null && e.animation.timeline != null;
			if (d.shader == ShaderType.Basic) {
				shader.send("u_rigged", animated? 1 : 0);
				if (animated) {
					var tl = e.animation.timeline;
					inline function unpack(t): Dynamic {
						return untyped __lua__("unpack(t)");
					}
					shader.send("u_pose", lua.TableTools.unpack(tl.current_pose));
				}
			}

			if (d.texture != null) {
				d.texture.setWrap(WrapMode.Repeat, WrapMode.Repeat);
				d.texture.setFilter(FilterMode.Linear, FilterMode.Linear, 16);
				d.mesh.mesh.setTexture(d.texture);
			}
			else if (d.shader == ShaderType.Terrain) {
				d.mesh.mesh.setTexture(texture);
			}
			lua.PairTools.ipairsEach(d.mesh.meshes, function(i, m) {
				var mesh = d.mesh.mesh;
				mesh.setDrawRange(m.first, m.last);
				if (debug_draw || wire_only) {
					L3d.set_culling(CullMode.None);
					setColor(0, 0, 0, 1);
					Lg.setWireframe(true);
					Lg.draw(mesh);
					setColor(1, 1, 1, 1);
					Lg.setWireframe(false);
					L3d.set_culling(CullMode.Back);
				}
				if (!wire_only) {
					Lg.draw(mesh);
				}
			});

			if (debug_draw) {
				var bounds = d.mesh.bounds.base;
				var min = new Vec3(bounds.min[1], bounds.min[2], bounds.min[3]);
				var max = new Vec3(bounds.max[1], bounds.max[2], bounds.max[3]);
				var xform_bounds = Utils.rotate_bounds(mtx, min, max);
				Debug.aabb(xform_bounds.min, xform_bounds.max, 0, 1, 1);
			}

			if (e.attachments != null && animated) {
				var tl = e.animation.timeline;
				for (attach in e.attachments) {
					var m = Mat4.from_cpml(tl.current_matrices[cast attach.bone]);
					var flip = new Mat4([
						1, 0, 0, 0,
						0, 0, -1, 0,
						0, 1, 0, 0,
						attach.offset[0], attach.offset[2],-attach.offset[1], 1
					]);

					var am = flip * m * mtx;
					if (debug_draw) {
						var bounds = attach.mesh.bounds.base;
						var min = new Vec3(bounds.min[1], bounds.min[2], bounds.min[3]);
						var max = new Vec3(bounds.max[1], bounds.max[2], bounds.max[3]);
						var xform_bounds = Utils.rotate_bounds(am, min, max);
						Debug.aabb(xform_bounds.min, xform_bounds.max, 0, 0, 1);
					}
					shader.send("u_model", am.to_vec4s());
					shader.send("u_rigged", 0);
					var inv = am.copy();
					inv.invert();
					inv.transpose();
					send(shader, "u_normal_mtx", inv.to_vec4s());

					lua.PairTools.ipairsEach(attach.mesh.meshes, function(i, m) {
						var mesh = attach.mesh.mesh;
						mesh.setDrawRange(m.first, m.last);
						if (debug_draw || wire_only) {
							L3d.set_culling(CullMode.None);
							setColor(0, 0, 0, 1);
							Lg.setWireframe(true);
							Lg.draw(mesh);
							setColor(1, 1, 1, 1);
							Lg.setWireframe(false);
							L3d.set_culling(CullMode.Back);
						}
						if (!wire_only) {
							Lg.draw(mesh);
						}
					});
				}
			}
		}
		Profiler.pop_block();

		var scale_samples = false;
		function scatter_grass(models: Array<love.graphics.Mesh>, seed: Int, count: Int, min: Float, max: Float, density: Float, scale_range: Float) {
			inline function area(p0, p1, p2) {
				var a = Vec3.distance(p0, p1);
				var b = Vec3.distance(p1, p2);
				var c = Vec3.distance(p2, p0);
				var s = (a + b + c) / 2;
				return Math.sqrt(s * (s-a) * (s-b) * (s-c));
			}
			inline function area2(p0: Vec3, p1: Vec3, p2: Vec3) {
				var ab = p0 - p1;
				var ac = p0 - p2;
				var pg = Vec3.cross(ab, ac);
				return pg.length() / 2.0;
			}

			var buffer = (max - min) / 3;
			var proj = camera.projection.copy();
			proj.set_clips(0.1, (max+buffer)/10);

			// BUG: near/far planes are wrong, far seems too far by 1/near?
			var frustum = (camera.view * proj).to_frustum();

			Profiler.push_block("grass tri query");
			var tris = World.get_triangles_frustum(frustum);
			Profiler.pop_block();

			Profiler.push_block("grass scatter");
			var p = new Vec3(0, 0, 0);
			var wu = Vec3.up();
			for (tri in tris) {
				var p0 = tri.v0;
				var p1 = tri.v1;
				var p2 = tri.v2;
				var n = tri.vn;
				// Widget.value("area vs", area(p0, p1, p2) / area2(p0, p1, p2));

				var up = Vec3.dot(n, wu);
				if (up < 0.5) {
					continue;
				}

				var blade_limit = 250;
				// var blade_scale = (c0[1] / 255 + c1[1] / 255 + c2[1] / 255) / 3
				var blade_scale = 1.0;

				var samples = Std.int(area2(p0, p1, p2) * density * blade_scale);
				samples = Std.int(Utils.min(samples, blade_limit));

				if (scale_samples) {
					var falloff = 0.5;
					var td = Vec3.distance(p0, camera.position);
					td = Utils.min(td, Vec3.distance(p1, camera.position));
					td = Utils.min(td, Vec3.distance(p2, camera.position));
					td = Utils.min(1.0 - td / scale_range, 1);
					td = Math.pow(td, falloff);

					samples = Std.int(samples * td);
				}

				Lm.setRandomSeed(seed);
				for (i in 0...samples) {
					var u = Lm.random();
					var v = (1.0 - u) * Lm.random();
					var w = 1 - u - v;

					p.x = u * p0[0] + v * p1[0] + w * p2[0];
					p.y = u * p0[1] + v * p1[1] + w * p2[1];
					p.z = u * p0[2] + v * p1[2] + w * p2[2];

					// make sure to calculate this, or our randoms will get screwed up after continues.
					// var scale = Utils.min(Math.pow(Math.max(blade_scale, 0.5) + Lm.random() / 3, falloff), 1.0);

					var d = Vec3.distance(p, camera.position);
					if (d >= max + buffer || d < min) {
						continue;
					}

					var sc = Math.sqrt(1 - d / (scale_range / 2));
					sc *= (up - 0.5) * 2;
					if (d > max) {
						sc *= 1.0 - (d - max) / buffer;
					}
					if (sc < 0.1) {
						continue;
					}

					var model = models[i % models.length];

					if (instances.length <= count) {
						var t = lua.Table.create();
						t[1] = p[0];
						t[2] = p[1];
						t[3] = p[2];
						t[4] = sc;
						t[5] = cast model;
						instances.push(t);
					}
					else {
						instances[count][1] = p[0];
						instances[count][2] = p[1];
						instances[count][3] = p[2];
						instances[count][4] = sc;
						instances[count][5] = cast model;
					}
					count++;
				}
			}
			Profiler.pop_block();
			return count;
		}

		Profiler.push_block("grass", new SegmentColor(0.25, 0.75, 0.0));
		var count = 0;
		if (grass_enabled) {
			var models = [
				short_grass,
				short_grass,
				short_grass,
				short_grass,
				short_grass,
				grass,
			];
			count = scatter_grass(models, grass_seed, count, 0, grass_range, grass_density, grass_range);
		}

		Profiler.push_block("grass draw", new SegmentColor(0.1, 0.5, 0.0));
		var gs = shaders.grass;
		Lg.setShader(gs);
		send_uniforms(gs);

		send(gs, "u_time", now);
		send(gs, "u_speed", 1);
		send(gs, "u_wind_force", 0.5);

		L3d.set_culling(CullMode.Back);
		for (i in 0...count) {
			var instance = instances[i];
			gs.send("u_instance", instance);
			Lg.draw(cast instance[5]);
		}
		Profiler.pop_block();
		Profiler.pop_block();

		Profiler.push_block("particle draw");
		var emitters = World.filter(false, function(e) { return e.emitter != null; });

		L3d.set_culling(CullMode.None);
		L3d.set_depth_test(DepthTestMethod.Less);
		setColor(1, 1, 1, 1);
		Lg.setBlendMode(BlendMode.Alpha, BlendAlphaMode.Alphamultiply);

		// Lg.setShader(shaders.basic);
		Lg.setShader(shaders.particle);
		send_uniforms(shaders.particle);
		send(shaders.particle, "u_white_point", new Vec3(r, g, b).unpack());
		send(shaders.particle, "u_exposure", exposure);

		for (e in emitters) {
			var emitter = e.emitter;
			for (emit in emitter) {
				var batch = emit.batch;
				batch.clear();
				var size = 64;
				// batch.setTexture(emit.texture);
				// Widget.value("particles", e.emit.data.particles.length);
				batch.setColor(emit.color.x * 255, emit.color.y * 255, emit.color.z * 255);
				for (p in emit.data.particles) {
					batch.add(
						-p.position.x, -p.position.y,
						p.rotation,
						-.0175*emit.scale, -.0175*emit.scale,
						size/2, size/2
					);
				}
				setColor(1, 1, 1, 1);
				Lg.draw(batch);
			}
		}

		if (Main.showing_menu(Main.WindowType.PlayerDebug)) {
			L3d.set_depth_test(DepthTestMethod.None);
			setColor(1, 0, 1, 1);
			for (e in emitters) {
				if (e.capsules != null) {
					for (cap in e.capsules.hurt) {
						Lg.circle(DrawMode.Line, -cap.final.a.x, -cap.final.a.y, cap.final.radius, 16);
					}
				}
				for (emit in e.emitter) {
					for (p in emit.data.particles) {
						Lg.circle(DrawMode.Line, -p.position.x, -p.position.y, emit.radius, 16);
					}
				}
			}
			var buckets = ParticleData.bucket_count;
			var map_size = ParticleData.map_size;
			var bucket_size = ParticleData.bucket_size;
			var buckets_per_row = Std.int(map_size / bucket_size);
			var row = 0;
			Lg.setLineStyle(love.graphics.LineStyle.Rough);
			Lg.setLineWidth(1/20);
			for (i in 0...buckets) {
				if (ParticleData.hash(Debug.cursor) == i) {
					setColor(1, 0, 1, 1);
				}
				else {
					setColor(0, 0.5, 0.5, 0.25);
				}
				var x = i % buckets_per_row;
				var y = Std.int((i - x) / buckets_per_row);
				x += 1;
				y += 1;
				x *= bucket_size;
				y *= bucket_size;
				x -= Std.int(map_size / 2);
				y -= Std.int(map_size / 2);
				Lg.rectangle(DrawMode.Line, -x, -y, bucket_size, bucket_size);
				setColor(0, 0, 0, 1);
			}
		}
		L3d.set_depth_write(true);

		Profiler.pop_block();

		Profiler.push_block("debug draw", new SegmentColor(0.25, 0.25, 0.25));
		Lg.setWireframe(true);
		Lg.setShader(shaders.debug);
		send_uniforms(shaders.debug);
		send(shaders.debug, "u_white_point", new Vec3(r, g, b).unpack());
		send(shaders.debug, "u_exposure", exposure);

		L3d.set_culling(CullMode.None);

		Debug.draw(false);
		Profiler.pop_block();

		Lg.setWireframe(false);
		Lg.setShader();

		L3d.set_depth_test();

		Lg.setCanvas();
		Lg.setShader();
	}

	function setup_post() {
		Lg.setShader(shaders.post);
		if (ab) {
			send(shaders.post, "u_white_point", new Vec3(swap.r, swap.g, swap.b).unpack());
		}
		else {
			send(shaders.post, "u_white_point", new Vec3(r, g, b).unpack());
		}
		send(shaders.post, "u_exposure", exposure);
		send(shaders.post, "u_vignette", vignette);
		setColor(1.0, 1.0, 1.0, 1.0);
	}

	function draw_game_view(vp: Viewport, entities: Array<Entity>, submit_view: Bool) {
		if (!submit_view) {
			render_game(main_canvas, entities, vp, false);
			return;
		}

		render_game(canvases[0], entities, vp, false);

		var c = canvases[1];
		c.renderTo(function() {
			setup_post();
			Lg.draw(canvases[0]);
			Lg.setShader();
		});

#if imgui
		Widget.set_cursor_pos(vp.x, vp.y);
		Widget.image(c, vp.w, vp.h, 0, 0, 1, 1);
#end
	}

	static var activate_game = false;

	static var now = 0.0;

	override public function update(entities: Array<Entity>, dt: Float) {
		now += dt;

		var w = Lg.getWidth();
		var h = Lg.getHeight();

		Lg.setBackgroundColor(89, 157, 220);

		var vp: Viewport = { x: 0, y: 0, w: w, h: h };
		draw_game_view(vp, entities, false);

		var c = main_canvas;
		var rw = w / c.getWidth();
		var rh = h / c.getHeight();
		setup_post();
		Lg.draw(c, vp.x, vp.y, 0, rw, rh);
		Lg.setShader();

		ui.HUD.draw();

		// if (World.is_local()) {
		// 	setColor(0.2, 0.0, 0.0, 0.95);
		// 	var str = "LOCAL MAP";
		// 	var f = Lg.getFont();
		// 	Lg.rectangle(DrawMode.Fill, 20, 20, f.getWidth(str) + 20, f.getHeight() + 20);
		// 	setColor(1.0, 0.0, 0.0, 1.0);
		// 	Lg.print(str, 30, 30);
		// }

		setColor(1.0, 1.0, 1.0, 1.0);
	}
}
