package systems;

import imgui.Input;
import love.mouse.MouseModule as Mouse;
import components.Transform;
import math.Vec3;
import GameInput.Action;

@:publicFields
class Collision extends System {
	var player: Null<Entity>;

	override function filter(e: Entity) {
		if (e.player != null) {
			this.player = e;
		}

		if (e.transform != null) {
			return true;
		}

		return false;
	}

	static function line(v0: Vec3, v1: Vec3, r: Float, g: Float, b: Float) {
		if (Main.showing_menu(Main.WindowType.PlayerDebug)) {
			Debug.line(v0, v1, r, g, b);
		}
	}

	static function in_front_of(p: Transform, e: Transform, max_distance: Float) {
		var dir = p.orientation * -Vec3.unit_y();

		var p2e = e.position - p.position;
		p2e.normalize();

		if (Vec3.dot(p2e, dir) > 0.0) {
			var in_range = Vec3.distance(p.position, e.position) <= max_distance;
			var offset = new Vec3(0, 0, 0.001);
			if (in_range) {
				line(p.position + offset, p.position + p2e + offset, 0, 1, 0.5);
			}
			else {
				line(p.position + offset, p.position + p2e + offset, 1, 0, 0.5);
			}
			return in_range;
		}

		return false;
	}

	override function update(entities: Array<Entity>, dt: Float) {
		if (Input.get_want_capture_keyboard()) {
			return;
		}

		if (this.player == null) {
			return;
		}

		var p = this.player;
		var dir = p.transform.orientation * -Vec3.unit_y();
		line(p.transform.position, p.transform.position + dir, 1, 1, 0);

		// Save the pigs!
		for (e in entities) {
			if (e == this.player) {
				continue;
			}

			if (e.npc != null) {
				var i = p.player.open_menus.indexOf(e.npc.id);
				var offset = new Vec3(0, 0, -0.001);
				line(p.transform.position + offset, e.transform.position + offset, 0.75, 0.5, 0.0);
				if (in_front_of(p.transform, e.transform, 3)) {
					if (i < 0 && GameInput.pressed(Action.Interact)) {
						p.player.open_menus.push(e.npc.id);
						Mouse.setRelativeMode(false);
						return;
					}
				} else {
					if (i >= 0) {
						p.player.open_menus.splice(i, 1);
						if (p.player.open_menus.length == 0) {
							Mouse.setRelativeMode(true);
						}
					}
				}
			}

			// press space when you're less than 3m away to kill a bitch
			if (e.enemy != null) {
				line(p.transform.position, e.transform.position, 1.0, 0.0, 0.0);
			}
			// if (GameInput.pressed(Action.AttackPrimary) && e.enemy != null) {
			// 	if (in_front_of(p.transform, e.transform, 3)) {
			// 		// p.player.quest.kill(p, e);
			// 		return;
			// 	}
			// }
		}
	}
}
