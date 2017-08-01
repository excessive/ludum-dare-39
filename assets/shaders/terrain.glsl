varying vec3 f_normal;
varying vec3 f_position;
varying float f_distance;

#ifdef VERTEX
attribute vec3 VertexNormal;

uniform mat4 u_model, u_view, u_projection;
uniform mat4 u_normal_mtx;

vec4 position(mat4 mvp, vec4 vertex) {
	f_normal = mat3(u_normal_mtx) * VertexNormal;
	f_position = vertex.xyz;
	f_distance = length((u_view * u_model * vertex).xyz);

	return u_projection * u_view * u_model * vertex;
}
#endif

#ifdef PIXEL
uniform vec3 u_light_direction;
uniform vec2 u_clips;
uniform vec3 u_fog_color;
uniform float u_time;
uniform float u_speed;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 sc) {
	vec3 light = normalize(u_light_direction);
	vec3 normal = normalize(f_normal);
	float shade = dot(normal, light);
	shade = max(shade, 0.0);

	color += 0.025;

	vec3 blending = abs(f_normal);
	blending = normalize(max(blending, 0.00001)); // Force weights to sum to 1.0
	float b = (blending.x + blending.y + blending.z);
	blending /= vec3(b);

	vec3 pos = f_position.xyz;
	pos.y -= u_time * u_speed;
	pos.y -= u_time * u_speed * (pos.z / 8.0);

	float scale = 0.25;
	vec4 xaxis = Texel(tex, pos.yz * scale);
	vec4 yaxis = Texel(tex, pos.xz * scale);
	vec4 zaxis = Texel(tex, pos.xy * scale);
	vec4 tripla1 = xaxis * blending.x + xaxis * blending.y + zaxis * blending.z;
	color.rgb = tripla1.rgb * color.rgb;

	// ambient
	vec3 top = vec3(0.2, 0.7, 1.0) * 3.0;
	vec3 bottom = vec3(0.30, 0.25, 0.35) * 2.0;
	vec3 ambient = mix(top, bottom, dot(normal, vec3(0.0, 0.0, -1.0)) * 0.5 + 0.5);
	ambient *= color.rgb;

	// combine diffuse with light info
	vec3 diffuse = color.rgb * (shade * 10.0);
	diffuse += ambient;

	// mix ambient beyond the terminator
	vec3 out_color = mix(ambient.rgb, diffuse.rgb, clamp(dot(light, normal) + 0.2, 0.0, 1.0));

	// fog
	float scaled = (f_distance - u_clips.x) / (u_clips.y - u_clips.x);
	scaled = pow(scaled, 1.8);

	return vec4(mix(out_color.rgb, u_fog_color, scaled), 1.0);
}
#endif
