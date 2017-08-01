import math.Vec3;
import math.Quat;
import math.Mat4;
import math.Utils;
#if imgui
import ui.CameraDebugWindow;
#end
import love.math.MathModule.random as rand;

class Camera {
	public var fov: Float = 75;
	public var orbit_offset = new Vec3();
	public var offset = new Vec3();
	public var position = new Vec3();
	public var orientation = Quat.from_angle_axis(Math.PI / 2, Vec3.unit_x());
	public var direction = new Vec3();
	public var view: Mat4;
	public var projection: Mat4;
	public var clip_distance: Float = 999;
	public var near: Float = 1.0;
	public var far: Float = 6000.0;
	var clip_minimum: Float = 4;
	var clip_bias: Float    = 3;

	var up = Vec3.unit_z();
	var mouse_sensitivity: Float = 0.2;
	var pitch_limit_up: Float = 0.9;
	var pitch_limit_down: Float = 0.9;

	public var shake = 0;
	var tween = null;

	public function new(position: Vec3) {
		this.position   = position;

		this.view       = new Mat4();
		this.projection = new Mat4();

		this.direction = this.orientation.apply_forward();

		Signal.register("killed enemy", function(_) {
			this.shake = 3;
			if (this.tween != null) {
				timer.Timer.cancel(this.tween);
			}
			this.tween = timer.Timer.tween(0.5, this, { shake: 0 }, timer.TweenMethod.OutQuad);
		});
		Signal.register("killed player", function(_) {
			this.shake = 5;
			if (this.tween != null) {
				timer.Timer.cancel(this.tween);
			}
			this.tween = timer.Timer.tween(1.0, this, { shake: 0 }, timer.TweenMethod.OutQuad);
		});
	}

	public function rotate_xy(mx: Float, my: Float) {
		var sensitivity = this.mouse_sensitivity;
		var mouse_direction = {
			x: Utils.rad(-mx * sensitivity),
			y: Utils.rad(-my * sensitivity)
		};

		// get the axis to rotate around the x-axis.
		var axis = Vec3.cross(this.direction, this.up);
		axis.normalize();

		// First, we apply a left/right rotation.
		this.orientation = Quat.from_angle_axis(mouse_direction.x, this.up) * this.orientation;

		// Next, we apply up/down rotation.
		// up/down rotation is applied after any other rotation (so that other rotations are not affected by it),
		// hence we post-multiply it.
		var new_orientation = this.orientation * Quat.from_angle_axis(mouse_direction.y, Vec3.unit_x());
		var new_pitch       = Vec3.dot(new_orientation * Vec3.unit_y(), this.up);

		// Don't rotate up/down more than this.pitch_limit.
		// We need to limit pitch, but the only reliable way we're going to get away with this is if we
		// calculate the new orientation twice. If the new rotation is going to be over the threshold and
		// Y will send you out any further, cancel it out. This prevents the camera locking up at +/-PITCH_LIMIT
		if (new_pitch >= this.pitch_limit_up) {
			mouse_direction.y = Math.min(0, mouse_direction.y);
		}
		else if (new_pitch <= -this.pitch_limit_down) {
			mouse_direction.y = Math.max(0, mouse_direction.y);
		}

		this.orientation = this.orientation * Quat.from_angle_axis(mouse_direction.y, Vec3.unit_x());

		// Apply rotation to camera direction
		this.direction = this.orientation.apply_forward();
	}

	public function update(w: Float, h: Float) {
		var aspect = Math.max(w / h, h / w);
		var aspect_inv = Math.min(w / h, h / w);
		var target = this.position + this.direction;

		this.view.identity();
		this.view *= Mat4.translate(this.orbit_offset);
		this.view = Mat4.look_at(this.position, target, Vec3.unit_z()) * this.view;

		var clip = -(Math.max(this.clip_distance, this.clip_minimum) - this.clip_bias);
		clip = Math.max(this.offset.z, clip);
		this.view *= Mat4.translate(new Vec3(this.offset.x, this.offset.y, clip));

#if imgui
		CameraDebugWindow.draw(this);
#end

		var range = 10;
		// this.projection = Mat4.from_perspective(this.fov * aspect_inv, aspect, this.near, this.far);
		this.projection = Mat4.translate(new Vec3(rand()*shake, rand()*shake, 0));
		this.projection *= Mat4.from_ortho(-range*aspect, range*aspect, range, -range, -100, 100);

		var vp = this.view * this.projection;
		World.update_visible(vp.to_frustum());
	}
}
