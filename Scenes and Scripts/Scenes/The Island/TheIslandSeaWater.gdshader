// Shader with rippling lake-like mini waves and full material settings

shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform sampler2D texture_refraction : filter_linear_mipmap, repeat_enable;
uniform float refraction : hint_range(-1.0, 1.0, 0.001);
uniform vec4 refraction_texture_channel;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform sampler2D texture_normal : hint_roughness_normal, filter_linear_mipmap, repeat_enable;
uniform float normal_scale : hint_range(-16.0, 16.0);
varying vec3 uv1_triplanar_pos;

uniform float uv1_blend_sharpness : hint_range(0.0, 150.0, 0.001);
varying vec3 uv1_power_normal;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

// Wave settings for mini ripples
uniform float wave_amplitude : hint_range(0.0, 1.0) = 0.1; // Maximum height of mini waves
uniform float wave_frequency : hint_range(0.1, 10.0) = 4.0; // Frequency of mini waves
uniform float wave_speed : hint_range(0.1, 5.0) = 1.0; // Speed of mini waves

// Additional wave layers for complexity
uniform float secondary_wave_amplitude : hint_range(0.0, 1.0) = 0.05;
uniform float secondary_wave_frequency : hint_range(0.1, 10.0) = 8.0;
uniform float secondary_wave_speed : hint_range(0.1, 5.0) = 1.5;

void vertex() {
    vec3 normal = MODEL_NORMAL_MATRIX * NORMAL;

    // Compute mini wave displacement
    float wave1 = sin(VERTEX.x * wave_frequency + TIME * wave_speed) * 
                  cos(VERTEX.z * wave_frequency + TIME * wave_speed);
    float wave2 = sin(VERTEX.z * secondary_wave_frequency + TIME * secondary_wave_speed) * 
                  cos(VERTEX.x * secondary_wave_frequency + TIME * secondary_wave_speed);

    float total_wave = wave1 * wave_amplitude + wave2 * secondary_wave_amplitude;
    VERTEX.y += total_wave;

    // Tangent and binormal calculation
    TANGENT = vec3(0.0, 0.0, -1.0) * abs(normal.x);
    TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.y);
    TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.z);
    TANGENT = inverse(MODEL_NORMAL_MATRIX) * normalize(TANGENT);

    BINORMAL = vec3(0.0, 1.0, 0.0) * abs(normal.x);
    BINORMAL += vec3(0.0, 0.0, -1.0) * abs(normal.y);
    BINORMAL += vec3(0.0, 1.0, 0.0) * abs(normal.z);
    BINORMAL = inverse(MODEL_NORMAL_MATRIX) * normalize(BINORMAL);

    // UV1 Triplanar: Enabled (with World Triplanar)
    uv1_power_normal = pow(abs(normal), vec3(uv1_blend_sharpness));
    uv1_triplanar_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz * uv1_scale + uv1_offset + TIME * 0.005;
    uv1_power_normal /= dot(uv1_power_normal, vec3(1.0)) * 1.5;
    uv1_triplanar_pos *= vec3(1.0, -1.0, 1.0);
}

vec4 triplanar_texture(sampler2D p_sampler, vec3 p_weights, vec3 p_triplanar_pos) {
    vec4 samp = vec4(0.0);
    samp += texture(p_sampler, p_triplanar_pos.xy) * p_weights.z;
    samp += texture(p_sampler, p_triplanar_pos.xz) * p_weights.y;
    samp += texture(p_sampler, p_triplanar_pos.zy * vec2(-1.0, 1.0)) * p_weights.x;
    return samp;
}

void fragment() {
    vec4 albedo_tex = triplanar_texture(texture_albedo, uv1_power_normal, uv1_triplanar_pos);
    ALBEDO = albedo.rgb * albedo_tex.rgb;

    float metallic_tex = dot(triplanar_texture(texture_metallic, uv1_power_normal, uv1_triplanar_pos), metallic_texture_channel);
    METALLIC = metallic_tex * metallic;
    SPECULAR = specular;

    vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
    float roughness_tex = dot(triplanar_texture(texture_roughness, uv1_power_normal, uv1_triplanar_pos), roughness_texture_channel);
    ROUGHNESS = roughness_tex * roughness;

    // Normal Map: Enabled
    NORMAL_MAP = triplanar_texture(texture_normal, uv1_power_normal, uv1_triplanar_pos).rgb;
    NORMAL_MAP_DEPTH = normal_scale;

    // Refraction: Enabled (with normal map texture)
    vec3 unpacked_normal = NORMAL_MAP;
    unpacked_normal.xy = unpacked_normal.xy * 2.0 - 1.0;
    unpacked_normal.z = sqrt(max(0.0, 1.0 - dot(unpacked_normal.xy, unpacked_normal.xy)));
    vec3 ref_normal = normalize(mix(
            NORMAL,
            TANGENT * unpacked_normal.x + BINORMAL * unpacked_normal.y + NORMAL * unpacked_normal.z,
            NORMAL_MAP_DEPTH));
    vec2 ref_ofs = SCREEN_UV - ref_normal.xy * dot(triplanar_texture(texture_refraction, uv1_power_normal, uv1_triplanar_pos), refraction_texture_channel) * refraction;

    float ref_amount = 1.0 - albedo.a * albedo_tex.a;
    EMISSION += textureLod(screen_texture, ref_ofs, ROUGHNESS * 8.0).rgb * ref_amount * EXPOSURE;
    ALBEDO *= 1.0 - ref_amount;
    // Force transparency on the material (required for refraction).
    ALPHA = 1.0;
}
