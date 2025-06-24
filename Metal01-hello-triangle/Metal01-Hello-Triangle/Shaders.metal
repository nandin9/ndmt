//
//  Shaders.metal
//  Metal01-Hello-Triangle
//
//  Created by nanding01 on 2025/6/24.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float2 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct Varying {
    float4 position [[position]];
    float4 color;
};

vertex Varying vertex_main(Vertex in [[stage_in]]) {
    Varying out;
    out.position = float4(in.position, 0, 1);
    out.color = in.color;
    return out;
}

fragment float4 fragment_main(Varying in [[stage_in]]) {
    return in.color;
}
