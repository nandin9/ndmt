//
//  Renderer.h
//  Metal01-Hello-Triangle
//
//  Created by nanding01 on 2025/6/24.
//

#ifndef Renderer_h
#define Renderer_h

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>

@interface Renderer : NSObject <MTKViewDelegate>
- (instancetype)initWithMTKView:(MTKView *)view;
@end

#endif /* Renderer_h */
