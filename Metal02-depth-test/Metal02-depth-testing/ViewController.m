//
//  ViewController.m
//  Metal02-depth-testing
//
//  Created by nanding01 on 2025/6/28.
//

#import "ViewController.h"
#import "Renderer.h"

@implementation ViewController
{
    MTKView *_view;
    Renderer *_renderer;
    
    __weak IBOutlet NSTextField *_topVertexDepthLabel;
    __weak IBOutlet NSTextField *_leftVertexDepthLabel;
    __weak IBOutlet NSTextField *_rightVertexDepthLabel;
    __weak IBOutlet NSSlider *_topVertexDepthSlider;
    __weak IBOutlet NSSlider *_leftVertexDepthSlider;
    __weak IBOutlet NSSlider *_rightVertexDepthSlider;
}


- (IBAction)setTopVertexDepth:(NSSlider *)slider
{
    _renderer.topVertexDepth = slider.floatValue;
    _topVertexDepthLabel.stringValue = [NSString stringWithFormat:@"%.2f", _renderer.topVertexDepth];
    
}
- (IBAction)setLeftVertexDepth:(NSSlider *)slider
{
    _renderer.leftVertexDepth = slider.floatValue;
    _leftVertexDepthLabel.stringValue = [NSString stringWithFormat:@"%.2f", _renderer.leftVertexDepth];
}

- (IBAction)setRightVertexDepth:(NSSlider *)slider
{
    _renderer.rightVertexDepth = slider.floatValue;
    _rightVertexDepthLabel.stringValue = [NSString stringWithFormat:@"%.2f", _renderer.rightVertexDepth];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _view = (MTKView *)self.view;
    _view.device = MTLCreateSystemDefaultDevice();

    NSAssert(_view.device, @"Metal is not supported on this device");

    _renderer = [[Renderer alloc] initWithMetalKitView:_view];

    NSAssert(_renderer, @"Renderer failed initialization");

    // Initialize the renderer with the view size.
    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];

    _view.delegate = _renderer;
    
    _renderer.topVertexDepth = _topVertexDepthSlider.floatValue;
    _topVertexDepthLabel.stringValue = [NSString stringWithFormat:@"%.2f", _renderer.topVertexDepth];
    
    _renderer.rightVertexDepth = _rightVertexDepthSlider.floatValue;
    _rightVertexDepthLabel.stringValue = [NSString stringWithFormat:@"%.2f", _renderer.rightVertexDepth];
    
    _renderer.leftVertexDepth = _leftVertexDepthSlider.floatValue;
    _leftVertexDepthLabel.stringValue = [NSString stringWithFormat:@"%.2f", _renderer.leftVertexDepth];
    
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
