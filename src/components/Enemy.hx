package components;

typedef Enemy = {
	var id:     EnemyList.EnemyId;
	var hp:     Float;
	var max_hp: Float;
	var alive:  Bool;
	var delay:  Float;
	var script: Dynamic;
	var iframe: Bool;
	var speed:  Float;
	var attach: Array<Entity>;
	@:optional var boss: Bool;
}
