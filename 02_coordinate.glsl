vec3 Coordinate(vec2 uv)
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
        color = vec3(0.0, 1.0, 0.0);
    }

    return color;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from -5.0 to 5.0)
    vec2 uv = 10.0 * (fragCoord - 0.5 * iResolution.xy) / min(iResolution.x, iResolution.y);
    
    fragColor = vec4(Coordinate(uv), 1.0);
}
