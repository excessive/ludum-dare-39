#ifdef VERTEX
	uniform vec3 u_position;
	uniform mat4 u_view, u_projection;

	vec4 position(mat4 mvp, vec4 v_position) {
		mat4 model = mat4(1.0);
		model[3][0] = u_position.x;
		model[3][1] = u_position.y;
		model[3][2] = u_position.z;

		mat4 mv = u_view * model;
		mv[0][0] = 1.0;
		mv[0][1] = 0.0;
		mv[0][2] = 0.0;

		// ignore this part for cylindrical objects
		mv[1][0] = 0.0;
		mv[1][1] = 1.0;
		mv[1][2] = 0.0;

		mv[2][0] = 0.0;
		mv[2][1] = 0.0;
		mv[2][2] = 1.0;

		return u_projection * mv * v_position;
	}
#endif

#ifdef PIXEL
uniform vec3 u_white_point;
uniform float u_exposure;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 sc) {
	vec4 final = Texel(tex, uv) * color;
	return vec4((final.rgb / exp2(u_exposure)) * u_white_point * 1.25, final.a);
}
#endif
