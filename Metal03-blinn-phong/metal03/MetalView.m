//
//  MetalView.m
//  metal03
//
//  Created by nanding01 on 2025/6/29.
//

#import "MetalView.h"
#import "Renderer.h"

@implementation MetalView {
    Renderer *_renderer;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect device:MTLCreateSystemDefaultDevice()];
    if (self) {
        self.colorPixelFormat = MTLPixelFormatBGRA8Unorm;
        _renderer = [[Renderer alloc] initWithMetalView:self];
        self.delegate = _renderer;
    }
    return self;
}
@end
