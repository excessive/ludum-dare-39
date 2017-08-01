package components;

import love.math.MathModule.random as rand;
import math.Vec2;
import math.Vec3;
import math.Utils;

@:publicFields
class InstanceData {
	var despawn_time: Float;
	var position: Vec3;
	var velocity: Vec3;
	var rotation: Float;

	inline function new(pos: Vec3, vel: Vec3, offset: Vec3, despawn: Float, radius: Float, spread: Float) {
		this.despawn_time = despawn;
		this.position     = pos + new Vec3(
			(2*rand()-1)*radius + offset.x,
			(2*rand()-1)*radius + offset.y,
			0
		);
		this.velocity     = new Vec3(
			vel.x + (2 * rand()-1) * spread,
			vel.y + (2 * rand()-1) * spread,
			vel.z + (2 * rand()-1) * spread
		);

		var dir = new Vec2(this.velocity.x, this.velocity.y);

		if (offset.y != 0) {
			this.velocity *= -1;
			this.rotation = dir.angle_to() + Math.PI / 2 * -1;
		} else {
			this.rotation = dir.angle_to() + Math.PI / 2;
		}
	}
}

typedef BucketData = Array<{
	var position: Vec3;
	var index: Int;
}>;

@:publicFields
class ParticleData {
	static var map_size: Int = 64;
	static var bucket_size: Int = 4;
	static var bucket_count: Int = Std.int(Math.pow(map_size / bucket_size, 2));

	var last_spawn_time: Float = 0.0;
	var particles: Array<InstanceData> = [];
	var buckets = new Array<BucketData>();
	var index: Int = 0;

	inline function new() {}
	static inline function hash(pos: Vec3): Int {
		var bx: Int = Math.floor(Utils.clamp(pos.x + map_size / 2, 0, map_size) / bucket_size);
		var by: Int = Math.floor(Utils.clamp(pos.y + map_size / 2, 0, map_size) / bucket_size);
		return bx + by * Math.floor(map_size / bucket_size);
	}
}

typedef ParticleLifetime = { min: Float, max: Float }

typedef Emitter = {
	@:optional var user_data: Dynamic;
	@:optional var time: Float;
	@:optional var tween: Float;
	@:optional var name: String;
	var batch: love.graphics.SpriteBatch;
	var emitting: Bool;
	var color: Vec3;
	var data: ParticleData;
	var lifetime: ParticleLifetime;
	var limit: Int;
	var pulse: Float;
	var spawn_radius: Float;
	var spawn_rate: Int;
	var radius: Float;
	var spread: Float;
	var velocity: Vec3;
	var offset: Vec3;
	var scale: Float;
	var update: Null<Emitter->Int->Void>;
}
