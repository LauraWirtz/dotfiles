#version 300 es

precision mediump float;
in vec2 v_texcoord;
out vec4 FragColor;
uniform sampler2D tex;

void main() {
  vec4 pixColor = texture2D(tex, v_texcoord);
  pixColor[0] *= 0.80;
  pixColor[1] *= 0.72;
  pixColor[2] *= 0.63;
  FragColor = pixColor;
}
