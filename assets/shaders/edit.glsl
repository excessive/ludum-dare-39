#ifdef VERTEX
uniform mat4 u_model, u_view, u_projection;

vec4 position(mat4 mvp, vec4 vertex_position) {
	return u_projection * u_view * u_model * vertex_position;
}
#endif

#ifdef PIXEL
uniform vec3 u_color;

vec4 effect(vec4 _, Image tex, vec2 uv, vec2 sc) {
	return vec4(u_color.rgb, 1);
}
#endif
