//
//  ViewController.m
//  Metal01-Hello-Triangle
//
//  Created by nanding01 on 2025/6/24.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import "Renderer.h"

@interface ViewController ()
@property (nonatomic, strong) MTKView *mtkView;
@property (nonatomic, strong) Renderer *renderer;
@end

@implementation ViewController

- (void)loadView {
    self.view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 800, 600)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mtkView = [[MTKView alloc] initWithFrame:self.view.bounds];
    self.mtkView.device = MTLCreateSystemDefaultDevice();
    self.mtkView.colorPixelFormat = MTLPixelFormatBGRA8Unorm;
    self.mtkView.clearColor = MTLClearColorMake(0.2, 0.2, 0.2, 1.0);

    self.mtkView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:self.mtkView];

    self.renderer = [[Renderer alloc] initWithMTKView:self.mtkView];
    self.mtkView.delegate = self.renderer;
}

@end
