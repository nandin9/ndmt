//
//  Shaders.metal
//  Metal02-depth-testing
//
//  Created by nanding01 on 2025/6/28.
//

#include <metal_stdlib>

using namespace metal;

#include "ShaderTypes.h"

/// Vertex shader outputs and fragment shader inputs.
struct RasterizerData
{
    float4 clipSpacePosition [[position]];
    float4 color;
};

/// Vertex shader.
vertex RasterizerData
vertexShader(uint                      vertexID     [[ vertex_id ]],
             const device AAPLVertex * vertices     [[ buffer(AAPLVertexInputIndexVertices) ]],
             constant vector_uint2   & viewportSize [[ buffer(AAPLVertexInputIndexViewport) ]])
{
    RasterizerData out;
    
    // Initialize the output clip space position.
    out.clipSpacePosition = vector_float4(0.0, 0.0, 0.0, 1.0);
    
    // Input positions are specified in 2D pixel dimensions relative to the
    // upper-left corner of the viewport.
    float2 pixelPosition = float2(vertices[vertexID].position.xy);
    
    // Use a float viewport to translate input positions from pixel space
    // coordinates into a [-1, 1] coordinate range.
    const vector_float2 floatViewport = vector_float2(viewportSize);

    // Initialize the output clip-space position.
    out.clipSpacePosition = vector_float4(0.0, 0.0, 0.0, 1.0);
    
    // 这里是把像素坐标转换成 Clip Space 坐标（范围从 [-1,1]）
    // 比如左上角是 (-1,1)，右下角是 (1,-1)
    const vector_float2 topDownClipSpacePosition = (pixelPosition.xy / (floatViewport.xy / 2.0)) - 1.0;
    
    // Metal 的坐标是 y 轴向上，而我们给的是从上往下的像素坐标
    // 所以这里把 y 取反，就对齐 Metal 坐标系了
    out.clipSpacePosition.y = -1 * topDownClipSpacePosition.y;
    out.clipSpacePosition.x = topDownClipSpacePosition.x;
    
    out.clipSpacePosition.z = vertices[vertexID].position.z;
    
    // Pass the input color straight to the output color.
    out.color = vertices[vertexID].color;
    
    return out;
}

/// Fragment shader.
fragment float4 fragmentShader(RasterizerData in [[stage_in]])
{
    // Return the color that set in the vertex shader.
    return in.color;
}

