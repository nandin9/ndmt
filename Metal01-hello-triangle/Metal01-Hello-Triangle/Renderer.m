//
//  Renderer.m
//  Metal01-Hello-Triangle
//
//  Created by nanding01 on 2025/6/24.
//

#import "Renderer.h"

typedef struct {
    vector_float2 position;
    vector_float4 color;
} Vertex;

@implementation Renderer {
    id<MTLDevice> _device;
    id<MTLRenderPipelineState> _pipelineState;
    id<MTLCommandQueue> _commandQueue;
    id<MTLBuffer> _vertexBuffer;
}

- (instancetype)initWithMTKView:(MTKView *)view {
    self = [super init];
    if (self) {
        _device = view.device;
        _commandQueue = [_device newCommandQueue];
        [self setupPipelineWithView:view];
        [self setupVertices];
    }
    return self;
}

- (void)setupPipelineWithView:(MTKView *)view {
    NSError *error = nil;
    id<MTLLibrary> library = [_device newDefaultLibrary];
    id<MTLFunction> vertexFunc = [library newFunctionWithName:@"vertex_main"];
    id<MTLFunction> fragmentFunc = [library newFunctionWithName:@"fragment_main"];

    MTLRenderPipelineDescriptor *desc = [[MTLRenderPipelineDescriptor alloc] init];
    desc.vertexFunction = vertexFunc;
    desc.fragmentFunction = fragmentFunc;
    desc.colorAttachments[0].pixelFormat = view.colorPixelFormat;
    
    MTLVertexDescriptor *vertexDescriptor = [[MTLVertexDescriptor alloc] init];

    // position attribute
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;

    // color attribute
    vertexDescriptor.attributes[1].format = MTLVertexFormatFloat4;
    vertexDescriptor.attributes[1].offset = sizeof(vector_float4);
    vertexDescriptor.attributes[1].bufferIndex = 0;

    // 设置 buffer layout
    vertexDescriptor.layouts[0].stride = sizeof(Vertex); // 2(position) + 4(color)
    NSLog(@"%d, %d, %d", sizeof(Vertex), sizeof(vector_float2), sizeof(vector_float4));
    vertexDescriptor.layouts[0].stepFunction = MTLVertexStepFunctionPerVertex;
    
    desc.vertexDescriptor = vertexDescriptor;

    _pipelineState = [_device newRenderPipelineStateWithDescriptor:desc error:&error];
    if (error) {
        NSLog(@"Failed to create pipeline state: %@", error);
    }
}

- (void)setupVertices {
    Vertex vertices[] = {
        { { 0.0,  0.5  }, { 1.0, 0.0, 0.0, 1.0 } },
        { { -0.5, -0.5 }, { 0.0, 1.0, 0.0, 1.0 } },
        { { 0.5, -0.5  }, { 0.0, 0.0, 1.0, 1.0 } }
    };
    _vertexBuffer = [_device newBufferWithBytes:vertices
                                         length:sizeof(vertices)
                                        options:MTLResourceStorageModeShared];
    //NSLog(@"%d, %d, %d", sizeof(vertices), sizeof(vector_float2), sizeof(vector_float4));
}

- (void)drawInMTKView:(MTKView *)view {
    id<CAMetalDrawable> drawable = view.currentDrawable;
    if (!drawable) return;

    MTLRenderPassDescriptor *desc = view.currentRenderPassDescriptor;
    if (!desc) return;

    id<MTLCommandBuffer> buffer = [_commandQueue commandBuffer];
    id<MTLRenderCommandEncoder> encoder = [buffer renderCommandEncoderWithDescriptor:desc];

    [encoder setRenderPipelineState:_pipelineState];
    [encoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
    [encoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
    [encoder endEncoding];

    [buffer presentDrawable:drawable];
    [buffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    // No-op for triangle
}

@end

