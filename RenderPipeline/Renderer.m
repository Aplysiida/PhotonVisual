//
//  ViewRenderer.m
//  RenderPipeline
//
//  Created by robertvict on 21/04/23.
//

#import "Renderer.h"

@implementation Renderer
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView
{
    self = [super init];
    if(self) {
        _device = mtkView.device;
        _commandQueue = [_device newCommandQueue];
    }
    
    //setup PSO
    
    //link shaders
    
    //id<MTLFunction> fragmentShader = [defaultLibrary newFunctionWithName:@"fragmentShader"];
    
    return self;
}

- (void)drawInMTKView:(MTKView *)view
{
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if(renderPassDescriptor == nil) {   //can't draw if don't know render pass
        return;
    }
    
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    //issue draw calls here
    [commandEncoder endEncoding];
    
    //Get drawable of output render pass
    id<MTLDrawable> drawable = view.currentDrawable;
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size
{
    [self drawInMTKView:view];
}

@end
