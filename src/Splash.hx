import love.Love;
import timer.Timer;
import timer.TweenMethod;
import love.audio.AudioModule as La;
import love.graphics.GraphicsModule as Lg;
import love.math.MathModule as Lm;
import systems.Render.setColor;
import ui.Anchor;

class Splash {
	static var delay = 5.5;
	static var overlay = {
		opacity: 1
	};
	static var logos = {
		l3d:   Lg.newImage("assets/splash/logo-love3d.png"),
		exmoe: Lg.newImage("assets/splash/logo-exmoe.png")
	};
	static var bgm = {
		volume: 0.5,
		music: La.newSource("assets/splash/love.ogg")
	}
	static var do_switch = false;
	static var lock = true;

	public static function init() {
		Love.update = update;
		Love.draw = draw;
		Love.keypressed = keypressed;

		Lg.setBackgroundColor(30, 30, 44, 255);

		Timer.after(0.25, function(f) {
			lock = false;
		});

		// BGM
		Timer.script(function(wait) {
			bgm.music.setVolume(bgm.volume);
			bgm.music.play();
			wait(delay);
			Timer.tween(1.5, bgm, { volume: 0 }, InQuad);
			wait(1.5);
			bgm.music.stop();
		});

		// Overlay fade
		Timer.script(function(wait) {
			Timer.tween(1.5, overlay, { opacity: 0 }, Cubic);
			wait(delay);
			Timer.tween(1.25, overlay, { opacity: 1 }, OutCubic);
			wait(1.5);
			do_switch = true;
		});
	}

	static function keypressed(key: String, scan: String, isrepeat: Bool) {
		if (lock) {
			return;
		}
		do_switch = true;
	}

	static function update(dt: Float) {
		Anchor.update();

		Timer.update(dt);
		bgm.music.setVolume(bgm.volume);

		if (do_switch) {
			bgm.music.stop();
			Love.update = null;
			Love.draw = null;
			Love.keypressed = null;
			Main.init();
		}
	}

	static function draw() {
		var cx = Anchor.center_x;
		var cy = Anchor.center_y;

		var lw = logos.exmoe.getWidth();
		var lh = logos.exmoe.getHeight();
		setColor(1, 1, 1, 1);
		Lg.draw(logos.exmoe, cx-lw/2, cy-lh/2 - 84);

		var lw = logos.l3d.getWidth();
		var lh = logos.l3d.getHeight();
		Lg.draw(logos.l3d, cx-lw/2, cy-lh/2 + 64);

		// Full screen fade, we don't care about logical positioning for this.
		setColor(0, 0, 0, overlay.opacity);
		Lg.rectangle(Fill, 0, 0, Lg.getWidth(), Lg.getHeight());
	}
}
