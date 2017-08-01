import math.Vec3;
import components.Transform;
import components.Drawable;

enum EnemyId {
	Trash;
	Blossom;
	Lily;
	Iris;
	Rose;
}

class EnemyList {
	public static function spawn(id: EnemyId) {
		var e: Entity = {};
		e.enemy =  {
			id: id,
			attach: [],
			hp: 100,
			max_hp: 100,
			alive: true, // used by the reaper
			delay: 5,
			iframe: false,
			speed: 10,
			script: function(e) {}
		};
		// TODO: use spawn points
		e.transform = new Transform(new Vec3(0.0, 0.0, 0.0));
		e.drawable =  new Drawable("assets/models/old/tree.iqm");

		World.add(e);
	}
}
