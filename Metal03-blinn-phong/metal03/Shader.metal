//
//  Shader.metal
//  metal03
//
//  Created by nanding01 on 2025/6/29.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex VertexOut vertex_main(uint vid [[vertex_id]]) {
    float2 pos[6] = {
        {-1.0, -1.0}, {1.0, -1.0}, {-1.0, 1.0},
        {-1.0, 1.0}, {1.0, -1.0}, {1.0, 1.0}
    };
    VertexOut out;
    out.position = float4(pos[vid], 0.0, 1.0);
    out.uv = (pos[vid] + 1.0) * 0.5;
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]],
                              constant float2 &resolution [[buffer(0)]],
                              constant float &time [[buffer(1)]]) {
    float2 fragCoord = in.uv * resolution;
    float3 color = float3(0.6);
    float2 cord = fragCoord / resolution;
    float3 center = float3(0.5, 0.5, 5.0);
    float radius = 0.3;
    float aspect_ratio = resolution.x / resolution.y;
    cord.x *= aspect_ratio;
    center.x *= aspect_ratio;

    if (length(cord - float2(center.x, center.y)) <= radius) {
        color = float3(0.8, 0.3, 1.0);
        float3 camera = float3(0.5, 0.5, 0.0);
        float3 point_light = float3(10.0 * sin(time * 0.5), 5.0, -1.0);
        float z = center.z - sqrt(radius * radius - pow(cord.y - center.y, 2.0));
        float3 curr = float3(cord, z);
        float3 normal = normalize(curr - center);
        float3 light = normalize(point_light - curr);
        float3 view = normalize(camera - curr);
        float3 h = normalize(light + view);
        float3 ambient = 0.1 * color;
        float3 diffuse = max(dot(normal, light), 0.0) * color;
        float3 specular = max(0.2 * pow(dot(normal, h), 200.0), 0.0) * color;
        color = ambient + diffuse + specular;
    } else {
        float sky = max(0.0, dot(float3(cord, 0.0), float3(0.0, 1.0, 0.0)));
        color = pow(sky, 1.0) * float3(0.5, 0.8, 1.0);
    }

    return float4(color, 1.0);
}
