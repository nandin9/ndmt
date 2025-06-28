//
//  ShaderTypes.h
//  Metal02-depth-testing
//
//  Created by nanding01 on 2025/6/28.
//

#ifndef AAPLShaderTypes_h
#define AAPLShaderTypes_h

#include <simd/simd.h>

/// Buffer index values shared between shader and C code to ensure that Metal
/// shader buffer inputs match Metal API buffer set calls.
typedef enum AAPLVertexInputIndex
{
    AAPLVertexInputIndexVertices = 0,
    AAPLVertexInputIndexViewport = 1,
} AAPLVertexInputIndex;

/// This structure defines the layout of each vertex in the array of vertices
/// set as an input to the Metal vertex shader. Because this header is shared
/// between the shader and C code, you ensure that the layout of the vertex
/// array matches the layout that the vertex shader expects.
typedef struct
{
    vector_float3 position;
    vector_float4 color;
} AAPLVertex;

#endif /* AAPLShaderTypes_h */
