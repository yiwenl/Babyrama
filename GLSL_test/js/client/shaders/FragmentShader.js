precision mediump float;
uniform vec4 u_multiplier;

void main() {
  gl_FragColor = vec4(1,1,1,1) * u_multiplier;  // green
}