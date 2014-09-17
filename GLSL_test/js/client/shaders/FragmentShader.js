precision mediump float;

// multiplier
uniform vec4 u_multiplier;
// percent displayed
uniform float u_percentDisplay;

// texture 
uniform sampler2D u_image;
// texture coordonate
varying vec2 v_texturePos;

void main() {

	if (v_texturePos.x >= u_percentDisplay) {
		gl_FragColor = texture2D(u_image, v_texturePos) * u_multiplier;	
	} else {
		gl_FragColor = texture2D(u_image, v_texturePos);
	}
	
}