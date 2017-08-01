import components.*;
import math.Vec3;

enum NPCId {
	WorldExit;
	WorldReturn;
	Home;
}

typedef NPC = {
	var id: NPCId;
}

typedef AttachedDrawable = {
	var filename: String;
	var bone: String;
	var mesh: Null<iqm.Iqm.IqmFile>;
	var offset: Vec3;
}

typedef NodeGraph = {}

typedef Entity = {
	@:optional var attachments: Array<AttachedDrawable>;
	@:optional var animation:   Animation;
	@:optional var drawable:    Drawable;
	@:optional var enemy:       Enemy;
	@:optional var npc:         NPC;
	@:optional var emitter:     Array<Emitter>;
	@:optional var player:      Player;
	@:optional var transform:   Transform;

	@:optional var capsules: {
		push: Array<BoneCapsule>,
		hit: Array<BoneCapsule>,
		hurt: Array<BoneCapsule>
	};

	@:noCompletion
	@:optional var scripts: Array<NodeGraph>;
}
