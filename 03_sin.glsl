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

float func(in float f) {
    return sin(f + iTime);
}

float plot_func(in vec2 uv) {
    float f = 0.;

    for (float x = 0.; x < iResolution.x; x += 1.) {
        float start_x = uv_trans(vec2(x, 0.)).x;
        float end_x = uv_trans(vec2(x + 10., 0.)).x;
        f += line_SDF_2D(uv, vec2(start_x, func(start_x)), vec2(end_x, func(end_x)), fwidth(uv.x));
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
                    plot_func(uv));
    fragColor = vec4(color, 1.0);
}
