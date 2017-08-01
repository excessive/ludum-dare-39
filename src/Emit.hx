import components.Emitter;
import love.graphics.GraphicsModule as Lg;
import love.math.MathModule as Lm;
import love.graphics.SpriteBatchUsage;
import math.Vec3;

class Emit {
	public static function make(params: Dynamic): Emitter {
		var limit = params.limit != null? params.limit : 1000;

		return {
			name: params.name,
			batch: Lg.newSpriteBatch(params.image, limit, SpriteBatchUsage.Stream),
			color: params.color != null? params.color : new Vec3(Lm.random(0, 100) / 100, Lm.random(0, 100) / 100, Lm.random(0, 100) / 100),
			data: new ParticleData(),
			limit: limit,
			lifetime: params.lifetime != null? { min: params.lifetime, max: params.lifetime } : { min: 15, max: 15 },
			pulse: params.pulse != null? params.pulse : 0.0,
			spawn_radius: params.spawn_radius != null? params.spawn_radius : 0,
			spawn_rate: params.spawn_rate != null? params.spawn_rate : 10,
			spread: params.spread != null? params.spread : 0.0,
			offset: params.offset != null? params.offset : new Vec3(),
			scale: 1,
			radius: params.radius != null? params.radius : 0.15,
			emitting: false,
			velocity: params.velocity != null? params.velocity : new Vec3(0, 0, 0),
			user_data: params.user_data,
			update: params.update
		};
	}

	public static var particles = {
		arrow:    Lg.newImage("assets/textures/arrow.png"),
		particle: Lg.newImage("assets/textures/particle.png"),
		bullet:   Lg.newImage("assets/textures/bullet.png"),
		orb:      Lg.newImage("assets/textures/orb.png"),
		petal:    Lg.newImage("assets/textures/petal.png"),
		feather:  Lg.newImage("assets/textures/feather.png"),
		card:     Lg.newImage("assets/textures/card.png"),
		thorn:    Lg.newImage("assets/textures/thorn.png")
	};

	public static var colors = {
		sakura_l:    new Vec3(1.00, 0.47, 0.80),
		sakura_r:    new Vec3(1.00, 0.80, 0.93),
		rose_l:      new Vec3(0.35, 0.00, 0.00),
		rose_r:      new Vec3(0.88, 0.00, 0.00),
		sky_blue:    new Vec3(0.00, 0.54, 1.00),
		pale_yellow: new Vec3(1.00, 1.00, 0.65),
		thorn:       new Vec3(0.10, 0.57, 0.00),
		red:         new Vec3(1.00, 0.00, 0.00),
		green:       new Vec3(0.00, 1.00, 0.00),
		blue:        new Vec3(0.00, 0.00, 1.00)
	};

	public static var sakura_l = {
		name:       "Sakura L",
		image:      particles.petal,
		color:      colors.sakura_l,
		pulse:      0.5,
		spawn_rate: 5,
		update:     Pattern.explode_hypno,
		user_data:  { swap: 1, swap_rate: 10, ring: 0 },
		velocity:   new Vec3(0.025, 2.0, 0)
	};

	public static var sakura_r = {
		name:       "Sakura R",
		image:      particles.petal,
		color:      colors.sakura_r,
		pulse:      0.5,
		spawn_rate: 5,
		update:     Pattern.explode_hypno,
		user_data:  { reverse: true, swap: 1, swap_rate: 10, ring: 0 },
		velocity:   new Vec3(-0.025, -2.0, 0)
	};

	public static var fast_galaxy_l = {
		name:       "Fast Galaxy L",
		image:      particles.orb,
		color:      colors.sakura_l,
		pulse:      0.35,
		spawn_rate: 9,
		update:     Pattern.explode_galaxy,
		user_data:  { spin_rate: 7, ring: 0 },
		velocity:   new Vec3(-0.025, -3, 0)
	};

	public static var fast_galaxy_r = {
		name:       "Fast Galaxy R",
		image:      particles.orb,
		color:      colors.sakura_r,
		pulse:      0.35,
		spawn_rate: 9,
		update:     Pattern.explode_galaxy,
		user_data:  { reverse: true, spin_rate: 7, ring: 0 },
		velocity:   new Vec3(-0.025, -3, 0)
	};

	public static var rose_l = {
		name:       "Rose L",
		image:      particles.petal,
		color:      colors.rose_l,
		pulse:      0.2,
		spawn_rate: 13,
		update:     Pattern.explode_galaxy,
		user_data:  { spin_rate: 5, ring: 0 },
		velocity:   new Vec3(0.025, 3, 0)
	};

	public static var rose_r = {
		name:       "Rose R",
		image:      particles.petal,
		color:      colors.rose_r,
		pulse:      0.2,
		spawn_rate: 13,
		update:     Pattern.explode_galaxy,
		user_data:  { spin_rate: 5, ring: 0 },
		velocity:   new Vec3(-0.025, -3, 0)
	};

	public static var thorn = {
		name:       "Thorn",
		image:      particles.thorn,
		color:      colors.thorn,
		pulse:      0.5,
		spawn_rate: 13,
		radius:     0.125,
		update:     Pattern.explode_pulse,
		user_data:  { alt: true, ring: 0 },
		velocity:   new Vec3(0.025, 6.0, 0)
	};

	public static var galaxy = {
		name:       "Galaxy",
		image:      particles.orb,
		color:      colors.thorn,
		pulse:      0.75,
		spawn_rate: 7,
		update:     Pattern.explode_galaxy,
		user_data:  { reverse: true, spin_rate: 5, ring: 0 },
		velocity:   new Vec3(0.025, 2.0, 0)
	};

	public static var fast_spiral_l = {
		name:       "Fast Spiral L",
		image:      particles.orb,
		spawn_rate: 10,
		update:     Pattern.explode_spiral,
		user_data:  {},
		velocity:   new Vec3(0.025, 4.0, 0.0)
	};

	public static var fast_spiral_r = {
		name:       "Fast Spiral R",
		image:      particles.orb,
		spawn_rate: 10,
		update:     Pattern.explode_spiral,
		user_data:  { reverse: true },
		velocity:   new Vec3(0.025, 4.0, 0.0)
	};

	public static var twin_spiral_l = {
		name:       "Twin Spiral L",
		color:      Emit.colors.sakura_l,
		image:      particles.particle,
		spawn_rate: 15,
		update:     Pattern.explode_spiral,
		user_data:  {},
		velocity:   new Vec3(0.025, 4.0, 0.0)
	};

	public static var twin_spiral_r = {
		name:       "Twin Spiral R",
		color:      Emit.colors.sakura_r,
		image:      particles.particle,
		spawn_rate: 15,
		update:     Pattern.explode_spiral,
		user_data:  {},
		velocity:   new Vec3(0.025, -4.0, 0.0)
	};

	public static var thorn_in = {
		name:       "Thorn In",
		image:      particles.thorn,
		lifetime:   5.5,
		pulse:      2,
		spawn_rate: 11,
		offset:     11,
		update:     Pattern.implode_pulse,
		user_data:  { alt: true },
		velocity:   new Vec3(0.025, 5.0, 0.0)
	};

	public static var spiral_l = {
		image:      particles.orb,
		spawn_rate: 13,
		update:     Pattern.explode_spiral,
		user_data:  {},
		velocity:   new Vec3(0.025, 5.0, 0.0)
	};

	public static var spiral_r = {
		image:      particles.orb,
		spawn_rate: 13,
		update:     Pattern.explode_spiral,
		user_data:  { reverse: true },
		velocity:   new Vec3(0.025, 5.0, 0.0)
	};

	public static var pulse = {
		image:      particles.orb,
		pulse:      0.75,
		spawn_rate: 19,
		update:     Pattern.explode_pulse,
		user_data:  { alt: true, ring: 0 },
		velocity:   new Vec3(0.025, 2.0, 0)
	};

	public static var impulse = {
		image:      particles.thorn,
		color:      colors.thorn,
		spawn_rate: 30,
		lifetime:   4,
		offset:     new Vec3(0, 40, 0),
		pulse:      1,
		update:     Pattern.implode_pulse,
		velocity:   new Vec3(0.15, 10.0, 0.0)
	};

	public static var pause_l = {
		image:      particles.orb,
		pulse:      0.5,
		spawn_rate: 7,
		update:     Pattern.explode_galaxy,
		user_data:  { reverse: true, spin_rate: 7, ring: 0 },
		velocity:   new Vec3(0.025, 3.0, 0)
	};

	public static var pause_c = {
		image:      particles.orb,
		pulse:      0.5,
		spawn_rate: 15,
		update:     Pattern.explode_pulse,
		user_data:  { alt: true, ring: 0 },
		velocity:   new Vec3(0.025, 3.0, 0)
	};

	public static var pause_r = {
		image:      particles.orb,
		pulse:      0.5,
		spawn_rate: 7,
		update:     Pattern.explode_galaxy,
		user_data:  { spin_rate: 7, ring: 0 },
		velocity:   new Vec3(0.025, 3.0, 0)
	};
}
