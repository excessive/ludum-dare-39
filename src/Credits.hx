import love.Love;
import love.event.EventModule as Event;
import love.graphics.GraphicsModule as Lg;
import timer.Timer;
import timer.TweenMethod;

class Credits {
	public static function init() {
		Main.unbind();

		Timer.after(5, function(fn) {
			Event.quit();
		});

		Love.update = update;
		Love.draw   = draw;
	}

	public static function update(dt: Float) {
		Timer.update(dt);
	}

	public static function draw() {
		Lg.print("you won!", 0, 0);
	}
}
