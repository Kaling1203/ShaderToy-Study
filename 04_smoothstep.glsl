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
    
    f = smoothstep(w, 0.95 * w, d);

    return f;
}

float func(in float x) {
    return smoothstep(1., 0., x);
}

float plot_func(in vec2 uv) {
    float f = 0.;

    for (float x = 0.; x < iResolution.x; x += 1.) {
        float start_x = uv_trans(vec2(x, 0.)).x;
        float end_x = uv_trans(vec2(x + 1., 0.)).x;
        f += line_SDF_2D(uv, vec2(start_x, func(start_x)), vec2(end_x, func(end_x)), fwidth(uv.x));
    }

    return f;
}

vec3 coordinate(vec2 uv)
{
    vec3 color = vec3(0.0);

    vec2 cell = fract(uv);

    color = vec3(smoothstep(4. * fwidth(uv.x), 3.9 * fwidth(uv.x), cell.x));
    color += vec3(smoothstep(4. * fwidth(uv.y), 3.9 * fwidth(uv.y), cell.y));

    color.gb *= smoothstep(3.9 * fwidth(uv.y), 4.0 * fwidth(uv.y), abs(uv.y));
    color.rg *= smoothstep(3.9 * fwidth(uv.x), 4.0 * fwidth(uv.x), abs(uv.x));

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
