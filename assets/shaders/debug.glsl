#ifdef VERTEX
uniform mat4 u_view, u_projection;

vec4 position(mat4 mvp, vec4 vertex_position) {
	return u_projection * u_view * vertex_position;
}
#endif

#ifdef PIXEL
uniform vec3 u_white_point;
uniform float u_exposure;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 sc) {
	return vec4((color.rgb / exp2(u_exposure)) * u_white_point, color.a);
}
#endif
