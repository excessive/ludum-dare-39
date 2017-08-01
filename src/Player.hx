import ui.*;
import imgui.Window;
import imgui.Widget;
import anim9.Anim9;
import anim9.Anim9.Anim9Track;

import components.Drawable;
import components.BoneCapsule;
import components.Emitter;

import math.Vec3;
import components.Transform;

class Player extends System {
	public var score:       Int = 0;
	public var shield:      Bool = false;
	public var can_dodge:   Bool  = true;
	public var hp:          Float = 1;
	public var speed:       Float = 6;
	public var dodge_speed: Float = 24;
	public var iframes:     Float = 0;
	public var max_iframes: Float = 2;
	public var fire_rate:   Float = 20;
	public var max_battery: Float = 1.0;
	public var battery:     Float = 1.0;
	public var battery_drain_per_hit: Float = 0.25;
	public var max_damage:  Float = 1000;
	public var damage:      Float = 1000;
	public var regen_speed: Float = 0.25; // battery/s
	public var radius:      Vec3  = new Vec3(0.25, 0.25, 0.75);
	public var spawn_point: Vec3;
	public var last_move:   Null<Vec3>;
	public var tracks = new Map<String, Anim9Track>();

	function mk_track(tl: Anim9, name: String): Null<Anim9Track> {
		if (this.tracks.exists(name)) {
			return this.tracks[name];
		}
		var track: Anim9Track = tl.new_track(name);

		if (track != null) {
			this.tracks[name] = track;
		}

		return track;
	}

	public function get_track(tl: Anim9, name: String): Anim9Track {
		var track = mk_track(tl, name);
		if (track != null) {
			return track;
		}
		else {
			Log.write(Log.Level.System, "Animation not found: " + name);
			return mk_track(tl, "idle");
		}
	}

	public function new() {
		super();
	}

	override public function filter(e: Entity) {
		if (e.player != null) {
			return true;
		}
		return false;
	}

	public static function spawn(at: Vec3, player: Player, emitter: Array<Emitter>) {
		player.spawn_point = at.copy();
		World.add({
			player: player,
			emitter: emitter,
			transform: new Transform(at),
			drawable: new Drawable("assets/models/player.iqm"),
			// animation: {
			// 	filename: "assets/models/player.iqm",
			// 	anims: [
			// 		"assets/animations/run.iqm"
			// 	],
			// 	timeline: null
			// },
			capsules: {
				push: [],
				hit: [],
				hurt: [
					new BoneCapsule("root", 1.5, 0.125)
				]
			}
		});
		Main.player = player;
		Signal.register("killed enemy", function(e) {
			player.score += 2200;
		});
		Signal.register("stage start", function(e) {
			player.iframes = 0;
			player.max_battery = 1;
			player.can_dodge = true;
			player.hp = 1;
		});
	}

	override public function process(e: Entity, dt: Float) {
		Debug.cursor = e.transform.position.copy();
#if imgui
		PlayerDebugWindow.draw(e);
#end
	}
}
