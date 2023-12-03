void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from -1.0 to 1.0)
    vec2 uv = 2.0 * (fragCoord - 0.5 * iResolution.xy) / min(iResolution.x, iResolution.y);
    float color = 0.0f;
    float radium = 0.3;

    if (length(uv) < radium) {
        color = 1.0;
    }

    // Output to screen
    fragColor = vec4(vec3(color), 1.0);
}
