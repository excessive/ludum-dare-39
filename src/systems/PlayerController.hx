package systems;

#if imgui
import imgui.Input;
import imgui.Widget;
#end

import math.Vec3;
import math.Utils;
import GameInput.Action;
import timer.Timer;
import timer.TweenMethod;

@:publicFields
class PlayerController extends System {
	static var now: Float = 0;

	override function filter(e: Entity) {
		if (e.player != null && e.transform != null) {
			return true;
		}
		return false;
	}

	inline function show_debug() {
		return Main.showing_menu(Main.WindowType.PlayerDebug);
	}

	function update_animation(e: Entity, move: Vec3, accel: Vec3, dt: Float) {
		if (e.animation.timeline == null) {
			return;
		}
	}

	override function process(e: Entity, dt: Float) {
		now += dt;

#if imgui
		if (Input.get_want_capture_keyboard()) {
			return;
		}
#end

		// Move
		var speed: Float = e.player.speed;
		var move = new Vec3();

		var stick = GameInput.move_xy();
		move.x = stick.x;
		move.y = stick.y;

		move = -move;

		var ml = move.length();
		if (ml > 1) {
			move.normalize();
			ml = 1;
		}

		if (e.player.hp <= 0) {
			ml = 0;
		}

		e.transform.velocity = move * Utils.min(ml, 1) * speed * ml;
		var next_position = e.transform.position.copy();
		e.transform.velocity += (next_position - e.transform.position) / dt;

		var p = e.player;
		if (p.can_dodge && GameInput.is_down(Action.Dodge) && ml > 0) {
			var len = 0.5;
			p.iframes = len;
			var base_speed = p.speed;
			p.speed = p.dodge_speed;
			p.can_dodge = false;
			p.max_battery -= p.battery_drain_per_hit;
			Timer.tween(len, p, {
				speed: base_speed
			}, OutCubic);
			Timer.after(len, function(f) {
				p.can_dodge = p.max_battery > 0;
				p.speed = base_speed;
			});
		}

		// Attacks
		e.emitter[0].emitting = GameInput.is_down(Action.Shoot) && p.hp > 0;

		p.shield = GameInput.is_down(Action.Shield) && p.max_battery > 0 && p.hp > 0;
		e.emitter[1].emitting = p.shield || (!p.can_dodge && p.max_battery > 0);

		var firing = false;
		var emit = e.emitter[0];
		if (emit.emitting) {
			firing = true;
		}
		emit.spawn_rate = Std.int(p.fire_rate);
		// emit.spawn_rate = Math.ceil(p.fire_rate * Math.pow(p.battery, 1/2));
		// emit.spawn_rate = Std.int(Utils.max(emit.spawn_rate, 2));

		if (!firing) {
			// p.battery = Utils.min(p.max_battery, p.battery + dt * p.regen_speed);
		}

		p.damage = Utils.min(p.max_damage, p.max_damage * Math.pow(p.battery, 1/2));
		p.damage = Utils.max(p.damage, p.max_damage / 4);

		if (p.iframes > 0) {
			p.iframes = Utils.max(0, p.iframes - dt);
			if (p.iframes <= 0) {
				Signal.emit("vulnerable");
			}
		}

		var pos = e.transform.position;
		var range = 10;
		pos.x = Utils.clamp(pos.x, -range, range);
		pos.y = Utils.clamp(pos.y, -range, range);
	}
}
