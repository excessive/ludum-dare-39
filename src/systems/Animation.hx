package systems;

import math.Vec3;
import math.Mat4;

class Animation extends System {
	override function filter(e: Entity) {
		return e.animation != null;
	}

	override function process(e: Entity, dt: Float) {
		var anim = e.animation;
		if (anim.timeline != null) {
			anim.timeline.update(dt);
			for (track in anim.timeline.iter_tracks()) {
				var anim = anim.timeline.animations[cast track.name];
				// ui.Helpers.any_value(track.name, track);
				// ui.Helpers.any_value(track.name, anim.length);

				// BUG: frame skipping can happen if these aren't sequential
				if (track.frame != track.marker) {
					track.marker = track.frame;
					var marker: Null<String> = anim.markers[track.frame];
					if (marker != null) {
						trace("event", marker);
					}
				}
			}
		}
	}
}
