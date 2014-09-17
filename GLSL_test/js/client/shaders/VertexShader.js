
attribute vec2 a_position;
attribute vec2 a_texturePos;

uniform vec2 u_resolution;

varying vec2 v_texturePos;

void main() {
	vec2 clipSpace = ((a_position / u_resolution * 2.0) - 1.0) * vec2(1, -1);
	gl_Position = vec4(clipSpace, 0, 1);
	v_texturePos = a_texturePos;
}
