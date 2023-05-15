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
    id<MTLRenderPipelineState> _pipelineState;
    id<MTLCommandQueue> _commandQueue;
    
    //resources
    MTLVertexDescriptor *_vertexDesc;
    id<MTLBuffer> _vertexBuffer;
    id<MTLBuffer> _uniformBuffer;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView
{
    self = [super init];
    if(self) {
        NSError *error;
        _device = mtkView.device;
      
        //load uniforms
        
        //load data
        Vertex path[] = {
            {{0,0,0}},
            {{0,1,1}},
            {{0,2,0}}
        };
        [self loadPhotonsPath];
        
        //setup vertex desc
        _vertexDesc = [[MTLVertexDescriptor alloc] init];
        _vertexDesc.attributes[0].format = MTLVertexFormatFloat3;
        _vertexDesc.attributes[0].bufferIndex = 0;
        _vertexDesc.attributes[0].offset = 0;
        _vertexDesc.layouts[0].stride = sizeof(MTLVertexFormatFloat3);
        
        //setup uniforms
        ;
        //_uniformBuffer = [];
        
        //link shaders
        id<MTLLibrary> shaderDefaultLibrary = [_device newDefaultLibrary];
        id<MTLFunction> vertexShader = [shaderDefaultLibrary newFunctionWithName:@"vertexShader"];
        id<MTLFunction> fragmentShader = [shaderDefaultLibrary newFunctionWithName:@"fragmentShader"];
        
        //setup PSO
        MTLRenderPipelineDescriptor *pipelineStateDesc = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDesc.label = @"Render Pipeline";
        pipelineStateDesc.vertexFunction = vertexShader;
        pipelineStateDesc.fragmentFunction = fragmentShader;
        pipelineStateDesc.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        pipelineStateDesc.vertexDescriptor = _vertexDesc;
        
        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDesc error:&error];
        NSAssert(_pipelineState, @"Failed to create pipeline state: %@", error);
        
        //create command queue
        _commandQueue = [_device newCommandQueue];
    }
    
    return self;
}

-(void) initializeUniforms
{
    //define uniform data
    //int length = sizeof(Uniform)*3; //taking into account metal's
    
    
    //_uniformBuffer = [_device newBufferWithLength:length options:MTLCPUCacheModeDefaultCache];
    //memcpy();
}

- (void)loadPhotonsPath
{
    //for now load 1 photon trajectory
    Vertex path[] = {
        {{0,0,0}},
        {{2,1,1}},
        {{0,2,0}}
    };
    int length = sizeof(Vertex) * 3;
    _vertexBuffer = [_device newBufferWithLength:length options:MTLCPUCacheModeWriteCombined];
    memcpy(_vertexBuffer.contents, path, length);
    
}

- (void)loadData:(Vertex *)vertices withVertexNum:(int)vertexNum
{
    size_t vertices_size = vertexNum * sizeof(Vertex);
    memcpy(_vertexBuffer.contents, vertices, vertices_size) ;
}

- (void)createVertexDesc : (nonnull MTLVertexDescriptor*) vertexDesc
{
    //define vertex desc
    //just store vertex positions for now
    vertexDesc = [[MTLVertexDescriptor alloc] init];
    vertexDesc.attributes[0].format = MTLVertexFormatFloat3;
    vertexDesc.attributes[0].bufferIndex = 0;
    vertexDesc.attributes[0].offset = 0;
    vertexDesc.layouts[0].stride = sizeof(MTLVertexFormatFloat3);
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
    [commandEncoder setRenderPipelineState:_pipelineState];
    [commandEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0]; //vertices
    [commandEncoder setVertexBuffer:_uniformBuffer offset:0 atIndex:1]; //uniforms
    [commandEncoder drawPrimitives:MTLPrimitiveTypeLineStrip vertexStart:0 vertexCount:3];
    
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
