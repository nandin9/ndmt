//
//  Renderer.h
//  Metal02-depth-testing
//
//  Created by nanding01 on 2025/6/28.
//

@import MetalKit;

@interface Renderer : NSObject<MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

@property float topVertexDepth;
@property float leftVertexDepth;
@property float rightVertexDepth;

@end
