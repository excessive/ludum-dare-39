import components.Emitter;
import math.Vec3;

// THESE ARE ALL BROKEN IN HAXE 4
class Pattern {
	public static function explode_pulse(_: Dynamic, p: Emitter, i: Int) {
		untyped __lua__("if not i then i = p; p = _ end"); // HACK: FIXED IN HAXE 4
		var ring: Int = Math.floor(i / p.spawn_rate);

		if (p.user_data.alt == true && p.user_data.ring < ring) {
			p.velocity = p.velocity.rotate(Math.PI, Vec3.up());
		}

		p.user_data.ring = ring;
		p.velocity = p.velocity.rotate(Math.PI * 2 / p.spawn_rate, Vec3.up());
	}

	public static function explode_spiral(_: Dynamic, p: Emitter, i: Int) {
		untyped __lua__("if not i then i = p; p = _ end"); // HACK: FIXED IN HAXE 4
		var pi = Math.PI;
		if (p.user_data.reverse == true) {
			pi *= -1;
		}

		p.velocity = p.velocity.rotate(pi / p.spawn_rate, Vec3.up());
	}

	public static function explode_galaxy(_: Dynamic, p: Emitter, i: Int) {
		untyped __lua__("if not i then i = p; p = _ end"); // HACK: FIXED IN HAXE 4
		var ring: Int = Math.floor(i / p.spawn_rate);

		if (p.user_data.ring < ring) {
			var pi = Math.PI;
			if (p.user_data.reverse == true) {
				pi *= -1;
			}

			p.velocity = p.velocity.rotate(pi * 2 / p.spawn_rate / (p.user_data.spin_rate), Vec3.up());
		}

		p.user_data.ring = ring;
		p.velocity = p.velocity.rotate(Math.PI * 2 / p.spawn_rate, Vec3.up());
	}

	public static function explode_hypno(_: Dynamic, p: Emitter, i: Int) {
		untyped __lua__("if not i then i = p; p = _ end"); // HACK: FIXED IN HAXE 4

		var ring: Int = Math.floor(i / p.spawn_rate);

		if (p.user_data.ring < ring) {
			if (ring % p.user_data.swap_rate == 0) {
				p.user_data.swap *= -1;
			}

			var pi = Math.PI;
			if (p.user_data.reverse == true) {
				pi *= -1;
			}

			p.velocity = p.velocity.rotate(pi * 2 / p.spawn_rate / (p.user_data.swap_rate * p.user_data.swap), Vec3.up());
		}

		p.user_data.ring = ring;
		p.velocity = p.velocity.rotate(Math.PI * 2 / p.spawn_rate, Vec3.up());
	}

	public static function implode_pulse(_: Dynamic, p: Emitter, i: Int) {
		untyped __lua__("if not i then i = p; p = _ end"); // HACK: FIXED IN HAXE 4
		p.velocity = p.velocity.rotate(Math.PI * 2 / p.spawn_rate, Vec3.up());
		p.offset   = p.offset.rotate(Math.PI * 2 / p.spawn_rate, Vec3.up());
	}

	public static function implode_spiral(_: Dynamic, p: Emitter, i: Int) {
		untyped __lua__("if not i then i = p; p = _ end"); // HACK: FIXED IN HAXE 4

	}

	public static function implode_spiral_r(_: Dynamic, p: Emitter, i: Int) {
		untyped __lua__("if not i then i = p; p = _ end"); // HACK: FIXED IN HAXE 4

	}
}
