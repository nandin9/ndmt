//
//  Renderer.m
//  Metal02-depth-testing
//
//  Created by nanding01 on 2025/6/28.
//

@import MetalKit;

#import "Renderer.h"
#import "ShaderTypes.h"

@implementation Renderer
{    
    id<MTLDevice>              _device;
    id<MTLCommandQueue>        _commandQueue;
    id<MTLRenderPipelineState> _pipelineState;
    
    // 同时处理深度和模板缓冲的状态对象
    id<MTLDepthStencilState> _depthState;
    
    // 保存视图的大小（宽高）
    vector_uint2             _viewportSize;
}

/// Initializes the renderer with the MetalKit view from which you obtain the Metal device.
- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView
{
    self = [super init];
    if(self)
    {
        _device = mtkView.device;
        
        mtkView.clearColor = MTLClearColorMake(0, 0, 0, 1);
        
        // 告诉 Metal 使用 32 位浮点深度格式来做深度测试
        mtkView.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
        
        // 每次渲染前，先把深度缓冲区所有像素值清空为 1.0（最大深度，最远）
        mtkView.clearDepth = 1.0;

        // 加载默认 shader 库，并获取 vertex 和 fragment shader 函数
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];
        
        // 设置渲染管线配置
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Render Pipeline";
        pipelineStateDescriptor.sampleCount = mtkView.sampleCount;
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        pipelineStateDescriptor.depthAttachmentPixelFormat = mtkView.depthStencilPixelFormat;
        pipelineStateDescriptor.vertexBuffers[AAPLVertexInputIndexVertices].mutability = MTLMutabilityImmutable;
        
        NSError *error;
        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];

        NSAssert(_pipelineState, @"Failed to create pipeline state: %@", error);
        
        // 设置深度测试描述，允许绘制比原来更近或者一样近的像素
        MTLDepthStencilDescriptor *depthDescriptor = [MTLDepthStencilDescriptor new];
        depthDescriptor.depthCompareFunction = MTLCompareFunctionLessEqual;
        depthDescriptor.depthWriteEnabled = YES;
        _depthState = [_device newDepthStencilStateWithDescriptor:depthDescriptor];
        
        // 创建一个命令队列command queue 用来提交渲染命令
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

#pragma mark - MTKView Delegate Methods

/// 当视图大小或者方向改变时会调用这个。
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
    // 记录新的视图大小
    // 渲染时会把这个数据传给顶点着色器用
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

/// 每帧调用
- (void)drawInMTKView:(nonnull MTKView *)view
{
    // 每次绘制都要创建一个命令缓冲区，用来打包 GPU 要做的事
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"Command Buffer";
    
    // 拿到当前的渲染通道描述（里面包含颜色和深度缓冲的目标）
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if(renderPassDescriptor != nil)
    {
        // 创建一个渲染编码器，之后所有的绘制命令都加进去
        id<MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"Render Encoder";
        
        // 设置要用的渲染管线状态（绑定 shader 等信息）
        [renderEncoder setRenderPipelineState:_pipelineState];
        
        // 设置深度状态，启用深度测试
        [renderEncoder setDepthStencilState:_depthState];
        
        // 把当前的 viewport 尺寸传给vertex shader.
        [renderEncoder setVertexBytes:&_viewportSize
                               length:sizeof(_viewportSize)
                              atIndex:AAPLVertexInputIndexViewport];
        
        // 准备一个灰色矩形（两个三角形拼起来），z 值设为 0.5，表示它在中间深度
        const AAPLVertex quadVertices[] =
        {
            { {                 100,                 100, 0.5 }, { 0.5, 0.5, 0.5, 1 } },
            { {                 100, _viewportSize.y-100, 0.5 }, { 0.5, 0.5, 0.5, 1 } },
            { { _viewportSize.x-100, _viewportSize.y-100, 0.5 }, { 0.5, 0.5, 0.5, 1 } },
            
            { {                 100,                 100, 0.5 }, { 0.5, 0.5, 0.5, 1 } },
            { { _viewportSize.x-100, _viewportSize.y-100, 0.5 }, { 0.5, 0.5, 0.5, 1 } },
            { { _viewportSize.x-100,                 100, 0.5 }, { 0.5, 0.5, 0.5, 1 } },
        };
        [renderEncoder setVertexBytes:quadVertices
                               length:sizeof(quadVertices)
                              atIndex:AAPLVertexInputIndexVertices];
        
        // 绘制出灰色矩形（两个三角形，总共 6 个点）
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:6];
        
        // 准备白色三角形的数据，z 值通过 UI 控件控制
        const AAPLVertex triangleVertices[] =
        {
            // Pixel positions (x, y) and clip depth (z),                           RGBA colors.
            { {                    200, _viewportSize.y - 200, _leftVertexDepth  }, { 1, 0, 0, 1 } },
            { {  _viewportSize.x / 2.0,                   200, _topVertexDepth   }, { 0, 1, 0, 1 } },
            { {  _viewportSize.x - 200, _viewportSize.y - 200, _rightVertexDepth }, { 0, 0, 1, 1 } }
        };
        [renderEncoder setVertexBytes:triangleVertices
                               length:sizeof(triangleVertices)
                              atIndex:AAPLVertexInputIndexVertices];
        
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:3];
        
        // 通知 GPU，渲染命令录完了
        [renderEncoder endEncoding];

        [commandBuffer presentDrawable:view.currentDrawable];
    }

    // 提交命令
    [commandBuffer commit];
}

@end
