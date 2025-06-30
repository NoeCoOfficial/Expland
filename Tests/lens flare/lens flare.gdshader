//////////////////////////////////////////////////////////////////
//by Marcel Klee - WuotanStudios - 2024
//used in project "RIAD - Reborn in a Dungeon"
//A first person - story driven - action game [WIP]
//
//For more infos follow me on:
//Twitter: https://x.com/WuotanStudios
//Bluesky: https://bsky.app/profile/wuotanstudios.bsky.social
//Striked: https://striked.gg/app/space/29-riad/news-about-riad
//www.wuotanstudios.com
//////////////////////////////////////////////////////////////////

shader_type canvas_item;

render_mode blend_add;

uniform lowp sampler2D Screen_Sample : hint_screen_texture, filter_linear_mipmap_anisotropic;
uniform lowp sampler2D FlareMult;
uniform lowp sampler2D FlareMult2;
uniform lowp sampler2D LensDirt; // Added lens dirt texture

uniform vec2 SunScreenUV;
uniform float Blur = 2.5; //Blur the Flare after Threshold
uniform float FlareThreshold;
uniform float Thresholdsmoothness = 0.2; //Smooth the Threshold+Blur result
uniform int Flares = 3; //Flare Amount
uniform float FlareSpacing; //Testing-Status
uniform float FlareDistance = 0.5;  //Testing-Status
uniform float LensThickness = 1.0;  //Testing-Status

uniform float Intensity; //Intensity of the Flare Effect
uniform float Saturation_ = 5.0; // Saturate the lensflare effect
uniform float visibility = 1.0; //Effect visibility by using alpha

uniform float MinFlareIntensity = 0.0;  // Minimal brightness
uniform float MaxFlareIntensity = 1.0;  // Maximum brightness

uniform float RainbowIntensity = 1.0; // Intensity of rainbow effect

uniform float LensDirtIntensity = 1.0; // Added lens dirt intensity

vec3 ApplyThreshold(vec3 color, float threshold){
    return color * smoothstep(threshold - Thresholdsmoothness, threshold + Thresholdsmoothness, length(color));
}

vec3 AdjustSaturation(vec3 color, float saturation) {
    float gray = dot(color, vec3(0.299, 0.587, 0.114)); // Luminance Calculation - NTSC-Standard
    return mix(vec3(gray), color, saturation);
}

// Convert from RGB to HSV and back
vec3 RGBToHSV(vec3 color) {
    float cmax = max(color.r, max(color.g, color.b));
    float cmin = min(color.r, min(color.g, color.b));
    float delta = cmax - cmin;
    
    float h = 0.0;
    if (delta != 0.0) {
        if (cmax == color.r) {
            h = mod(((color.g - color.b) / delta), 6.0);
        } else if (cmax == color.g) {
            h = ((color.b - color.r) / delta) + 2.0;
        } else {
            h = ((color.r - color.g) / delta) + 4.0;
        }
    }
    h /= 6.0;

    float s = (cmax == 0.0) ? 0.0 : delta / cmax;
    float v = cmax;

    return vec3(h, s, v);
}

vec3 HSVToRGB(vec3 hsv) {
    float h = hsv.x * 6.0;
    float s = hsv.y;
    float v = hsv.z;

    int i = int(h);
    float f = h - float(i);
    float p = v * (1.0 - s);
    float q = v * (1.0 - f * s);
    float t = v * (1.0 - (1.0 - f) * s);

    if (i == 0) return vec3(v, t, p);
    else if (i == 1) return vec3(q, v, p);
    else if (i == 2) return vec3(p, v, t);
    else if (i == 3) return vec3(p, q, v);
    else if (i == 4) return vec3(t, p, v);
    else return vec3(v, p, q);
}

// Rainbow Effect Function (Hue Shifting)
vec3 ApplyRainbowEffect(vec3 color, float factor) {
    vec3 hsv = RGBToHSV(color); // Convert to HSV
    hsv.x = mod(hsv.x + factor * RainbowIntensity, 1.0); // Adjust hue based on factor
    return HSVToRGB(hsv); // Convert back to RGB
}

void fragment(){
    vec2 center = vec2(0.5);
    
    // FlareVector points from sun to center, flare elements spread along this line (opposite direction of sun)
    vec2 FlareVector = (center - SunScreenUV) * FlareSpacing;
    vec3 FinalFlare = vec3(0.0);
    
    for (int i = 0; i < Flares; ++i){
        vec2 SUV = fract(SCREEN_UV + FlareVector * float(i));
        float Dist = distance(SUV, center);
        float Weight = 1.0 - smoothstep(0.0, 0.75, Dist);
        vec3 BlurredScreen = texture(Screen_Sample, SUV, Blur).rgb;
        
        BlurredScreen = ApplyThreshold(BlurredScreen, FlareThreshold);
        
        FinalFlare += BlurredScreen * Weight;
    }
    
    FinalFlare *= texture(FlareMult, SCREEN_UV).rgb;
    FinalFlare *= texture(FlareMult2, SCREEN_UV).rgb;
    FinalFlare *= Intensity;
    FinalFlare = clamp(FinalFlare, vec3(MinFlareIntensity), vec3(MaxFlareIntensity));

    // Adjust saturation once, after all flare calculations
    FinalFlare = AdjustSaturation(FinalFlare, Saturation_);
    
    // Rainbow effect based on distance from sun position, not center
    float factor = distance(SCREEN_UV, SunScreenUV);
    FinalFlare = ApplyRainbowEffect(FinalFlare, factor);

    // ----------- Lens Dirt addition -----------
    vec3 dirt = texture(LensDirt, SCREEN_UV).rgb;
    FinalFlare += dirt * LensDirtIntensity * FinalFlare;

    COLOR.rgb = FinalFlare;
    COLOR.a = visibility;
}
