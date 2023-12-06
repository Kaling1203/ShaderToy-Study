#define SCALER  5. * 2.

vec2 uv_trans(in vec2 cord) {
    return SCALER * (cord - 0.5 * iResolution.xy) / min(iResolution.x, iResolution.y);
}

float line_SDF_2D(in vec2 p, in vec2 a, in vec2 b, in float w) {
    float f = 0.;
    vec2 ba = b - a;
    vec2 pa = p - a;
    float proj = clamp(dot(pa, ba) / dot(ba, ba), 0., 1.);
    float d = length(proj * ba - pa);
    if (d <= w) {
        f = 1.;
    }

    return f;
}

vec3 coordinate(vec2 uv)
{
    vec3 color = vec3(0.0);

    vec2 cell = fract(uv);

    // Output to screen
    if (cell.x < fwidth(uv.x) || cell.y < fwidth(uv.y)) {
        color = vec3(1.0, 1.0, 1.0);
    }

    if (abs(uv.y) < fwidth(uv.y)) {
        color = vec3(1.0, 0, 0);
    }

    if (abs(uv.x) < fwidth(uv.x)) {
        color = vec3(0., 1., 0.);
    }

    return color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // Normalized pixel coordinates (from -1.0 to 1.0)
    vec2 uv = uv_trans(fragCoord);

    // Output to screen
    vec3 color = vec3(coordinate(uv));
    color = mix(color, vec3(1., 1., 0.), 
                    line_SDF_2D(uv, vec2(-3., -1.), vec2(1., 4.), fwidth(uv.x)));
    fragColor = vec4(color, 1.0);
}
