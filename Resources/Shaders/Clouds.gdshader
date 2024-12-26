shader_type spatial;
render_mode unshaded;

uniform sampler3D cloud_noise_texture;
uniform float CloudNoiseUVTiling : hint_range(0.001, 5.0) = 2.0;
uniform float CloudNoiseTilingMagnitude : hint_range(0.0, 1.0, 0.001) = 0.3;
uniform float cloud_threshold : hint_range(0.0, 1.0) = 1.0;
uniform float cloud_threshold_multiplier: hint_range(0.00, 10.00) = 6.5;
uniform int GPUKiller : hint_range(1, 512, 0.1) = 64;
uniform float GPUSaver : hint_range(0.01, 3.0, 0.01) = 0.8;
uniform float cloud_scroll_speed = 0.022;
uniform vec3 minBounds = vec3(-4096.0, 256.0, -4096.0);
uniform vec3 maxBounds = vec3(4096.0, 576.0, 4096.0);

uniform sampler3D detail_noise_texture;
uniform float DetailNoiseInfluenceOnFinalResult: hint_range(0.0, 256.0) = 32.0;
uniform float detail_scroll_speed : hint_range(-10.0, 10.0) = -4.0;
uniform float DetailNoiseUVTiling : hint_range(0.0, 32.0) = 6.0;
uniform vec3 light_direction = vec3(0.1, -0.1, 0.1);
uniform vec3 cloud_movement_direction = vec3(0.0007, -0.0007, 0.0007);
uniform float cloud_movement_speed = 0;
uniform float cloudMovementMagnitude: hint_range(0.0, 1.0, 0.001) = 0.01;
uniform float LightCorrection = 1.5;
uniform float cloud_alpha = 256.0;
uniform vec3 cloud_color : source_color = vec3(0.7, 0.4, 0.4);

float sample_detail_noise(vec3 position) {
    return texture(detail_noise_texture, position).r;
}

float sample_cloud(vec3 position) {
    // Add the cloud movement vector and scroll the noise texture.
    vec3 movementOffset = cloud_movement_speed * cloud_movement_direction * TIME * cloudMovementMagnitude;
    vec3 mainScrollingOffset = cloud_scroll_speed * cloud_movement_direction * TIME ;
    vec3 detailScrollingOffset = detail_scroll_speed * cloud_movement_direction * TIME;  // separate scrolling for detail

    vec3 mainOffsetPos = position + mainScrollingOffset + movementOffset;
    vec3 detailOffsetPos = position + detailScrollingOffset + movementOffset; // Different offset for detail noise

    float main_cloud = texture(cloud_noise_texture, mainOffsetPos).r;
    float detail = sample_detail_noise(detailOffsetPos * DetailNoiseUVTiling * 2.0);
    return mix(main_cloud, detail, DetailNoiseInfluenceOnFinalResult);
}


float raymarch(vec3 ro_model, vec3 rd_model, vec2 intersections) {
    float total_density = 0.0;
    float accumulated_density = 5.0;  // Used for the moving average
    float shadowing_factor = 0.5; // Adjust this value for stronger/weaker shadowing
    float t = intersections.x;  // start from the entry point
    float max_t = intersections.y;  // march up to the exit point

    for (int i = 0; i < GPUKiller && t < max_t; i++) {
        vec3 pos_model = ro_model + t * rd_model;
        float density = sample_cloud(pos_model * CloudNoiseUVTiling * CloudNoiseTilingMagnitude);

        // Self-shadowing based on accumulated density
        density *= 1.0 - shadowing_factor * accumulated_density;

        float depth_factor = (t - intersections.x) / (intersections.y - intersections.x);
        float orientation_factor = max(0.0, dot(normalize(rd_model), light_direction));
        float shadow_factor = mix(LightCorrection, 0.35, orientation_factor) * mix(0.05, 0.05, depth_factor);

        // Calculate the attenuation based on the direction to the light
        float light_attenuation = 2.5 - max(0.5, dot(normalize(rd_model), -light_direction));
        light_attenuation = pow(light_attenuation, 3.0);

        density = smoothstep(cloud_threshold * cloud_threshold_multiplier, cloud_threshold, density);
        density *= shadow_factor;
        density *= 0.8 - LightCorrection * light_attenuation; // Apply the attenuation

        total_density += density * GPUSaver;
        accumulated_density = mix(accumulated_density, total_density, 0.1);  // Update the running average using a mix function. The 0.1 value is an arbitrary blend factor; adjust it as necessary.
        t += GPUSaver;
    }
    return total_density;
}

// Return both entry and exit intersections with the mesh
vec2 getRayIntersections(vec3 ro, vec3 rd) {
    vec3 t1 = (minBounds - ro) / rd;
    vec3 t2 = (maxBounds - ro) / rd;

    vec3 tmin = min(t1, t2);
    vec3 tmax = max(t1, t2);

    float t_near = max(max(tmin.x, tmin.y), tmin.z);
    float t_far = min(min(tmax.x, tmax.y), tmax.z);

    if (t_near > t_far || t_far < 0.0) {
        return vec2(-1.0, -1.0); // No intersection
    }

    return vec2(t_near, t_far);
}

void fragment() {
    vec3 ro_world = INV_VIEW_MATRIX[3].xyz;
    vec4 clipPos = vec4((FRAGCOORD.xy / VIEWPORT_SIZE.xy) * 2.0 - 1.0, FRAGCOORD.z, 1.0);
    vec4 viewPos = INV_PROJECTION_MATRIX * clipPos;
    vec3 rd_world = normalize(viewPos.xyz / viewPos.w);
    rd_world = mat3(INV_VIEW_MATRIX) * rd_world;

    vec2 intersections = getRayIntersections(ro_world, rd_world);

    // Check if there's no intersection
    if (intersections.x == -1.0) {
        discard;
    }

    vec3 ro_model = mat3(inverse(MODEL_MATRIX)) * (ro_world - MODEL_MATRIX[3].xyz);
    vec3 rd_model = mat3(inverse(MODEL_MATRIX)) * rd_world;

    float cloud_intensity = raymarch(ro_model, rd_model, intersections);

    ALBEDO = cloud_color * cloud_intensity;
    ALPHA = cloud_intensity/cloud_alpha;
}
