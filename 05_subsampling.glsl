#define SCALER  5. * 2.
#define PI  3.14159265359
#define AA  4

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
    float t = 4. + 2. * cos(iTime);
    return sin(2. * PI / t * x);
}

float plot_func(in vec2 uv) {
    float y = func(uv.x);

    return smoothstep(-.03, .03, uv.y - y);
}

vec3 coordinate(vec2 uv)
{
    vec3 color = vec3(0.0);

    vec2 cell = fract(uv);

    vec2 revised_uv = floor(mod(uv, 2.));
    
    if (revised_uv.x == revised_uv.y) {
        color = vec3(.6);
    } else {
        color = vec3(.25);
    }

    color = mix(color, vec3(0., 0., 0.), smoothstep(1.1 * fwidth(uv.y), 0.9 * fwidth(uv.y), abs(uv.y)));
    color = mix(color, vec3(0., 0., 0.), smoothstep(1.1 * fwidth(uv.x), 0.9 * fwidth(uv.x), abs(uv.x)));

    return color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // Normalized pixel coordinates (from -1.0 to 1.0)
    vec2 uv = uv_trans(fragCoord);

    // Output to screen
    vec3 color = vec3(coordinate(uv));

    // Sub-sampling for function plot
    float sum = .0;
    for (int x = 0; x < AA; x++) {
        for (int y = 0; y < AA; y++) {
            vec2 offset = 2. * (vec2(x, y) - .5 * float(AA)) / float(AA);
            sum += plot_func(uv_trans(fragCoord + offset));
        }
    }
    
    sum = 1.0 - abs(2. * (sum / (float(AA * AA)) - .5));

    color = mix(color, vec3(1., .0, .0), sum);
    fragColor = vec4(color, 1.0);
}
