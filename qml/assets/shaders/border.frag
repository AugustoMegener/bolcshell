#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float thickness;
    float innerRadius;
    float w;
    float h;
    vec4 borderColor;
    float innerThickness;
    vec4 innerColor;
    float shadowSize;
    vec4 shadowColor;
};
float sdRoundedBox(vec2 p, vec2 center, vec2 halfSize, float r) {
    vec2 d = abs(p - center) - halfSize + vec2(r);
    return length(max(d, vec2(0.0))) + min(max(d.x, d.y), 0.0) - r;
}
float sdBox(vec2 p, vec2 center, vec2 halfSize) {
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, vec2(0.0))) + min(max(d.x, d.y), 0.0);
}
void main() {
    vec2 pos = qt_TexCoord0 * vec2(w, h);
    vec2 center = vec2(w, h) * 0.5;

    float outer = sdBox(pos, center, center);
    float inner = sdRoundedBox(pos, center, center - vec2(thickness), innerRadius);

    float coreRadius = max(innerRadius - innerThickness, 0.0);
    vec2 coreHalfSize = center - vec2(thickness + innerThickness);

    float innerLine = sdRoundedBox(pos, center, coreHalfSize, coreRadius);
    float shadowDist = -sdRoundedBox(pos, center, coreHalfSize, coreRadius);
    float safeShadowSize = max(shadowSize, 0.001);

    float borderAlpha = smoothstep(0.5, -0.5, outer) * smoothstep(0.0, 1.0, inner);
    float innerAlpha = smoothstep(1.0, 0.0, inner) * smoothstep(0.0, 1.0, innerLine);
    float shadowAlpha = (1.0 - smoothstep(0.0, safeShadowSize, shadowDist)) * (1.0 - borderAlpha - innerAlpha);

    vec4 col = borderColor * borderAlpha + innerColor * innerAlpha * (1.0 - borderAlpha);
    col = mix(col, shadowColor, shadowAlpha * shadowColor.a * (1.0 - borderAlpha - innerAlpha));
    fragColor = col * qt_Opacity;
}
