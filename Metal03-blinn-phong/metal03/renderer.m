//
//  renderer.m
//  metal03
//
//  Created by nanding01 on 2025/6/29.
//

#import "Renderer.h"
#import <simd/simd.h>

@implementation Renderer {
    id<MTLDevice> _device;
    id<MTLRenderPipelineState> _pipeline;
    id<MTLCommandQueue> _queue;
    vector_float2 _resolution;
    float _time;
}

- (instancetype)initWithMetalView:(MTKView *)view {
    self = [super init];
    if (self) {
        _device = view.device;
        _queue = [_device newCommandQueue];
        _resolution = (vector_float2){view.drawableSize.width, view.drawableSize.height};

        id<MTLLibrary> lib = [_device newDefaultLibrary];
        MTLRenderPipelineDescriptor *desc = [MTLRenderPipelineDescriptor new];
        desc.vertexFunction = [lib newFunctionWithName:@"vertex_main"];
        desc.fragmentFunction = [lib newFunctionWithName:@"fragment_main"];
        desc.colorAttachments[0].pixelFormat = view.colorPixelFormat;
        _pipeline = [_device newRenderPipelineStateWithDescriptor:desc error:nil];
    }
    return self;
}

- (void)drawInMTKView:(MTKView *)view {
    _time += 1.0 / 60.0;
    _resolution = (vector_float2){view.drawableSize.width, view.drawableSize.height};

    id<MTLCommandBuffer> cmd = [_queue commandBuffer];
    MTLRenderPassDescriptor *rpd = view.currentRenderPassDescriptor;
    if (!rpd) return;

    id<MTLRenderCommandEncoder> enc = [cmd renderCommandEncoderWithDescriptor:rpd];
    [enc setRenderPipelineState:_pipeline];
    [enc setVertexBytes:&_resolution length:sizeof(_resolution) atIndex:0];
    [enc setFragmentBytes:&_resolution length:sizeof(_resolution) atIndex:0];
    [enc setFragmentBytes:&_time length:sizeof(_time) atIndex:1];
    [enc drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
    [enc endEncoding];

    [cmd presentDrawable:view.currentDrawable];
    [cmd commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    _resolution = (vector_float2){size.width, size.height};
}
@end
