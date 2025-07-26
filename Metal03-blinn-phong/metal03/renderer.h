//
//  renderer.h
//  metal03
//
//  Created by nanding01 on 2025/6/29.
//

#ifndef renderer_h
#define renderer_h

#import <MetalKit/MetalKit.h>

@interface Renderer : NSObject <MTKViewDelegate>
- (instancetype)initWithMetalView:(MTKView *)view;
@end


#endif /* renderer_h */
