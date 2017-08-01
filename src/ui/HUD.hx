package ui;

import love.graphics.GraphicsModule as Lg;
import love.graphics.DrawMode;
import systems.Render.setColor;
import timer.Timer;
import timer.TweenMethod;

@:publicFields
class HUD {
	static var dead = false;
	static var font: love.graphics.Font;
	static var fonti: love.graphics.Font;
	static var notif_fade = 0.0;
	static var show = false;
	static var line: Null<String> = null;
	static var boss: Null<components.Enemy> = null;
	static var revealed = false;
	static var titlecard = {
		name: "The Boss",
		title: "",
		scale: 0,
		show: false
	}
	static function invuln(params: Dynamic) {
		var iframes: Float = params;
		var now = 0.0;
		Timer.during(iframes, function(dt) {
			now += dt;
			show = Std.int(now * 10) % 2 == 0;
		});
	}
	static function init() {
		Signal.register("killed player", function(params: Dynamic) {
			var e: Entity = cast params;
			dead = true;
			Timer.tween(0.25, HUD, { notif_fade: 1 }, TweenMethod.OutBack);
			Timer.after(2.25, function(fn) {
				Stage.spawn(e.player);
				Stage.init_stage();
			});
		});
		font = Lg.newFont("assets/fonts/animeace2_bld.ttf", 32);
		fonti = Lg.newFont("assets/fonts/animeace2_ital.ttf", 26);

		Signal.register("boss battle", function(_e: Dynamic) {
			var e: Entity = cast _e;
			boss = e.enemy;
		});
		Signal.register("boss enter", function(_e: Dynamic) {
			var e: Entity = cast _e;
			titlecard.name  = Language.get('${e.enemy.id}-name');
			titlecard.title = Language.get('${e.enemy.id}-title');
			titlecard.show  = true;
			Timer.script(function(wait) {
				Timer.tween(0.25, titlecard, { scale: 1 }, TweenMethod.OutBack);
				wait(5.0);
				Timer.tween(0.25, titlecard, { scale: 0 }, TweenMethod.OutBack);
				wait(0.25);
				titlecard.show = false;
			});
		});
		Signal.register("boss clear", function(e) {
			boss = null;
		});
		Signal.register("stage start", function(e) {
			notif_fade = 0.0;
			dead = false;
		});
		Signal.register("invulnerable", invuln);
		Signal.register("vulnerable", function(_) {
			show = false;
		});
		Signal.register("dialog", function(k: Dynamic) {
			var key: String = cast k;
			line = key;
			Timer.after(5, function(fn) {
				line = null;
			});
		});
		Signal.register("reveal", function(_) {
			revealed = true;
		});
	}
	static function draw() {
		var sw = Lg.getWidth();
		// var top = Anchor.top;
		var btm = Anchor.bottom;

		// splice the player out so it's just an enemy list

		if (show) {
			Lg.rectangle(Fill, 0, 0, 100, 100);
		}

		var oldf = Lg.getFont();
		Lg.setFont(font);

		if (dead) {
			setColor(0, 0, 0, 0.9);
			Lg.push();
			Lg.translate(0, Anchor.center_y);
			Lg.scale(1, notif_fade);
			Lg.rectangle(Fill, 0, -50, sw, 100);
			Lg.pop();
			var str = "FOILED";
			var width = font.getWidth(str);
			setColor(1, 1, 1, 1);
			Lg.print(str, Anchor.center_x - width / 2, Anchor.center_y - font.getHeight() / 2);
		}

		if (titlecard.show) {
			setColor(0, 0, 0, 0.9);
			Lg.push();
			Lg.translate(0, Anchor.center_y);
			Lg.scale(1, titlecard.scale);
			Lg.rectangle(Fill, 0, -50, sw, 100);
			var str = titlecard.name;
			var width = font.getWidth(str);
			setColor(1, 1, 1, 1);
			Lg.setFont(font);
			Lg.print(str, Anchor.center_x - width / 2, font.getHeight() / 2 + 5 - 25);

			str = '<${titlecard.title}>';
			width = fonti.getWidth(str);
			Lg.setFont(fonti);
			Lg.print(str, Anchor.center_x - width / 2, fonti.getHeight() / 2 - 5 - 45);
			Lg.setFont(font);
			Lg.pop();
		}

		if (line != null) {
			var text = Language.get(line);
			setColor(0, 0, 0, 1);
			var spread = 2;
			Lg.printf(text, Anchor.center_x - 400 - spread, Anchor.bottom - 200, 800);
			Lg.printf(text, Anchor.center_x - 400 + spread, Anchor.bottom - 200, 800);
			Lg.printf(text, Anchor.center_x - 400, Anchor.bottom - 200 - spread, 800);
			Lg.printf(text, Anchor.center_x - 400, Anchor.bottom - 200 + spread, 800);
			setColor(1, 1, 1, 1);
			Lg.printf(text, Anchor.center_x - 400, Anchor.bottom - 200, 800);
		}

		var p = null;
		World.filter(false, function(e: Entity) {
			if (e.player != null) {
				p = e.player;
			}
			return false;
		});
		if (p != null) {
			var spacing = font.getHeight();
			var name = Language.get("Erin-name");
			if (revealed) {
				// setColor(0.8, 0.8, 0.8, 1);
			}
			Lg.print('$name', Anchor.left, btm - spacing * 4);
			if (revealed) {
				setColor(0.95, 0.2, 0.1, 1);
				var wi = font.getWidth(name.substr(0, name.indexOf(" ")+1));
				Lg.print('${Language.get("Aaron-name")}', Anchor.left - 10, btm - spacing * 4 + 10, -Math.PI / 30);
				setColor(1, 1, 1, 1);
			}
			var title = Language.get("Erin-title");
			Lg.print('<$title>', Anchor.left, btm - spacing * 3);
			if (revealed) {
				setColor(0.95, 0.2, 0.1, 1);
				var wi = font.getWidth("<"+title.substr(0, title.indexOf(" ")+1));
				Lg.print('${Language.get("Aaron-title")}', Anchor.left + wi, btm - spacing * 3 - 10, Math.PI / 30);
				setColor(1, 1, 1, 1);
			}
			Lg.print('score ${p.score}', Anchor.left, btm - spacing * 2);
			Lg.print('shield ${p.max_battery / p.battery_drain_per_hit}', Anchor.left, btm - spacing);
		}
		if (boss != null) {
			setColor(0, 0, 0, 1);
			Lg.rectangle(Fill, Anchor.left - 2, Anchor.top - 2, Anchor.width + 4, 25 + 4);
			setColor(1, 0, 0, 1);
			Lg.rectangle(Fill, Anchor.left, Anchor.top, Anchor.width * (boss.hp / boss.max_hp), 25);
			setColor(1, 1, 1, 1);
			Lg.print(Std.string(boss.id), Anchor.left, Anchor.top + 10);
		}

		Lg.setFont(oldf);
	}
}
