precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
  vec4 pixColor = texture2D(tex, v_texcoord);
  pixColor[0] *= 0.304;
  pixColor[1] *= 0.165;
  pixColor[2] *= 0.021;
  gl_FragColor = pixColor;
}
