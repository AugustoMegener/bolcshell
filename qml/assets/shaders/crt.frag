
// The MIT License (MIT)

// Copyright (c) 2015 Wesley LaFerriere

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "GLSL-CRT"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#version 440

#ifdef GL_ES
#define LOWP lowp
precision mediump float;
#else
#define LOWP
#endif

layout(std140, binding = 0) uniform buf {
    float crtCurveAmntX;
    float crtCurveAmntY;
};

layout(location = 0) in LOWP vec4 v_color;
layout(location = 1) in vec2 v_texCoords;

layout(binding = 1) uniform sampler2D u_texture;

layout(location = 0) out vec4 fragColor;

#define CRT_CASE_BORDR 0.0125
#define SCAN_LINE_MULT 1250.0

void main()
{
    vec2 tc = v_texCoords;

    // Distance from center
    float dx = abs(0.5 - tc.x);
    float dy = abs(0.5 - tc.y);

    // Square it to smooth the edges
    dx *= dx;
    dy *= dy;

    // CRT curve distortion
    tc.x -= 0.5;
    tc.x *= 1.0 + (dy * crtCurveAmntX);
    tc.x += 0.5;

    tc.y -= 0.5;
    tc.y *= 1.0 + (dx * crtCurveAmntY);
    tc.y += 0.5;

    // Texture sample
    vec4 cta = texture(u_texture, tc);

    // Scanlines
    cta.rgb += sin(tc.y * SCAN_LINE_MULT) * 0.02;

    // Outside screen cutoff
    if (tc.y > 1.0 || tc.x < 0.0 || tc.x > 1.0 || tc.y < 0.0)
        cta = vec4(0.0);

    fragColor = cta * v_color;
}
