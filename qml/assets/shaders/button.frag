#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float resolutionX;
    float resolutionY;
    float boxHalfWidth;
    float boxHalfHeight;
    float insetShadowSize;
    float pressed;
    float radiusTopLeft;
    float radiusTopRight;
    float radiusBottomRight;
    float radiusBottomLeft;
};

float sdRoundBox(vec2 p, vec2 b, vec4 r) {
    float rad = (p.x < 0.0)
        ? ((p.y < 0.0) ? r.x : r.w)
        : ((p.y < 0.0) ? r.y : r.z);
    vec2 q = abs(p) - b + rad;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - rad;
}

vec4 over(vec4 dst, vec4 src) {
    float a = src.a + dst.a * (1.0 - src.a);
    vec3 rgb = a > 0.0 ? (src.rgb * src.a + dst.rgb * dst.a * (1.0 - src.a)) / a : vec3(0.0);
    return vec4(rgb, a);
}

void main() {
    vec2 resolution = vec2(resolutionX, resolutionY);
    vec2 boxHalfSize = vec2(boxHalfWidth, boxHalfHeight);
    vec4 radii = vec4(radiusTopLeft, radiusTopRight, radiusBottomRight, radiusBottomLeft);

    vec2 fragPos = qt_TexCoord0 * resolution;
    vec2 p = fragPos - resolution * 0.5;

    float dBox = sdRoundBox(p, boxHalfSize, radii);
    float boxAA = 0.5;
    float boxCoverage = 1.0 - smoothstep(-boxAA, boxAA, dBox);

    vec4 outerResult = vec4(0.0);
    vec4 insetResult = vec4(0.0);

    if (pressed > 0.5) {
        {
            float spread = 1.0;
            vec4 r = max(radii - spread, 0.0);
            float d = sdRoundBox(p, boxHalfSize - vec2(spread), r);
            float aa = 0.5;
            insetResult = over(insetResult, vec4(vec3(0.0), 0.45 * smoothstep(-aa, aa, d)));
        }
        {
            float spread = 1.0 + insetShadowSize;
            vec4 r = max(radii - spread, 0.0);
            float d = sdRoundBox(p, boxHalfSize - vec2(spread), r);
            float aa = 0.5;
            insetResult = over(insetResult, vec4(vec3(0.0), 0.15 * smoothstep(-aa, aa, d)));
        }
        {
            float spread = 0.0; float blur = 8.0; float offsetY = 2.0;
            vec4 r = max(radii - spread, 0.0);
            float d = sdRoundBox(p - vec2(0.0, offsetY), boxHalfSize - vec2(spread), r);
            insetResult = over(insetResult, vec4(vec3(0.0), 0.57 * smoothstep(-blur, blur, d)));
        }
        {
            float spread = -1.0;
            vec4 r = max(radii + spread, 0.0);
            float d = sdRoundBox(p, boxHalfSize + vec2(spread), r);
            float aa = 0.5;
            outerResult = over(outerResult, vec4(vec3(1.0), 0.02 * (1.0 - smoothstep(-aa, aa, d))));
        }
    } else {
        {
            float spread = -1.0; float blur = 4.0; float offsetY = 2.0;
            vec4 r = max(radii + spread, 0.0);
            float d = sdRoundBox(p - vec2(0.0, offsetY), boxHalfSize + vec2(spread), r);
            outerResult = over(outerResult, vec4(vec3(0.0), 0.14 * (1.0 - smoothstep(-blur, blur, d))));
        }
        {
            float spread = -2.7; float blur = 4.0; float offsetY = 2.0;
            vec4 r = max(radii + spread, 0.0);
            float d = sdRoundBox(p - vec2(0.0, offsetY), boxHalfSize + vec2(spread), r);
            outerResult = over(outerResult, vec4(vec3(0.0), 0.27 * (1.0 - smoothstep(-blur, blur, d))));
        }
        {
            float spread = -5.6; float blur = 4.0; float offsetY = 4.0;
            vec4 r = max(radii + spread, 0.0);
            float d = sdRoundBox(p - vec2(0.0, offsetY), boxHalfSize + vec2(spread), r);
            outerResult = over(outerResult, vec4(vec3(0.0), 0.37 * (1.0 - smoothstep(-blur, blur, d))));
        }

        outerResult.a *= (1.0 - boxCoverage);

        {
            float spread = 0.0; float blur = 4.0; float offsetY = -2.0;
            vec4 r = max(radii - spread, 0.0);
            float d = sdRoundBox(p - vec2(0.0, offsetY), boxHalfSize - vec2(spread), r);
            insetResult = over(insetResult, vec4(vec3(0.0), 0.35 * smoothstep(-blur, blur, d)));
        }
        {
            float spread = 2.0; float offsetY = -insetShadowSize;
            vec4 r = max(radii - spread, 0.0);
            float d = sdRoundBox(p - vec2(0.0, offsetY), boxHalfSize - vec2(spread), r);
            float aa = 0.5;
            insetResult = over(insetResult, vec4(vec3(0.0), 0.26 * smoothstep(-aa, aa, d)));
        }
        {
            float spread = 1.0;
            vec4 r = max(radii - spread, 0.0);
            float d = sdRoundBox(p, boxHalfSize - vec2(spread), r);
            float aa = 0.5;
            insetResult = over(insetResult, vec4(vec3(0.0), 0.3 * smoothstep(-aa, aa, d)));
        }
        {
            float offsetY = 1.0;
            float d = sdRoundBox(p - vec2(0.0, offsetY), boxHalfSize, radii);
            float aa = 0.5;
            insetResult = over(insetResult, vec4(vec3(1.0), 0.1 * smoothstep(-aa, aa, d)));
        }
    }

    vec4 clippedInset = vec4(insetResult.rgb, insetResult.a * boxCoverage);
    vec4 result = over(outerResult, clippedInset);

    fragColor = vec4(result.rgb * result.a, result.a) * qt_Opacity;
}
