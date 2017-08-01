varying vec3 f_normal;
varying float f_distance;

#ifdef VERTEX
attribute vec3 VertexNormal;

uniform mat4 u_view, u_projection;
uniform vec4 u_instance;

uniform float u_time;
uniform float u_wind_force;
// uniform float u_speed;

vec4 position(mat4 _, vec4 vertex) {
	float space_frequency = 0.3;
	float frequency = 1.0;
	float move_factor = 0.06;
	vec3 wind_dir = vec3(0.707, 0.707, 0.0);

	float scale = u_instance.w;
	float normal_bias = 0.75;
	f_normal = VertexNormal + vec3(0.0, normal_bias, 0.0);

	float max_dist = u_wind_force;
	float scale_dist = 10;

/*
	vec3 wpos = u_instance.xyz + vertex.xyz * vec3(scale);
	wpos.x += pow(cos(u_time * u_speed + wpos.x / 30.0), 2.0) * pow(1.0-VertexTexCoord.y, 3.0) * u_wind_force * u_instance.w;
	wpos.y += pow(sin(u_time * u_speed + wpos.y / 30.0), 1.0) * pow(1.0-VertexTexCoord.y, 3.0) * u_wind_force * u_instance.w;

	wpos.x -= pow(cos(u_time * u_speed + vertex.x * 2.0), 2.0) * pow(1.0-VertexTexCoord.y, 3.0) * (u_wind_force / 2.0) * u_instance.w;
	wpos.y -= pow(sin(u_time * u_speed + vertex.y * 2.0), 2.0) * pow(1.0-VertexTexCoord.y, 3.0) * (u_wind_force / 2.0) * u_instance.w;
*/
	vec3 wpos = u_instance.xyz + vertex.xyz * vec3(scale);
	if (vertex.z >= 0.1) {
		float len = length(vertex.xyz);
		wpos += move_factor * (sin(frequency * u_time + dot(wpos, wind_dir) * space_frequency - vertex.z*2.0) + 0.5) * wind_dir;
	}

	vec4 pos4 = vec4(wpos, 1.0);
	f_distance = length((u_view * pos4).xyz);

	return u_projection * u_view * pos4;
}

#endif

#ifdef PIXEL

uniform vec2 u_clips;
uniform vec3 u_light_direction;
uniform vec3 u_fog_color;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 sc) {
	vec3 light = normalize(u_light_direction);
	vec3 normal = normalize(f_normal);
	float shade = dot(normal, light);
	if (shade >= 0.0) {
		shade += 0.25;
	}
	else {
		shade *= -1.0;
		shade += 0.125;
	}
	shade = min(shade, 1.0);

	color += 0.025;

	// ambient
	vec3 top = vec3(0.2, 0.7, 1.0) * 3.0;
	vec3 bottom = vec3(0.30, 0.25, 0.35) * 2.0;
	vec3 ambient = mix(top, bottom, dot(normal, vec3(0.0, 0.0, -1.0)) * 0.5 + 0.5);
	ambient *= color.rgb;

	// combine diffuse with light info
	vec3 diffuse = Texel(tex, uv).rgb * color.rgb * vec3(shade * 10.0);
	diffuse += ambient;
	vec3 out_color = diffuse;

	// mix ambient beyond the terminator
	// vec3 out_color = mix(ambient.rgb, diffuse.rgb, clamp(dot(light, normal) + 0.2, 0.0, 1.0));

	// fog
	float scaled = (f_distance - u_clips.x) / (u_clips.y - u_clips.x);
	scaled = pow(scaled, 1.6);

	return vec4(mix(out_color.rgb, u_fog_color, scaled), pow(8.0-uv.y, 0.5));
}
#endif
