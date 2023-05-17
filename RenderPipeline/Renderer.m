//
//  ViewRenderer.m
//  RenderPipeline
//
//  Created by robertvict on 21/04/23.
//

#import "Renderer.h"

@implementation MeshGPU
@end

@implementation Renderer
{
    id<MTLDevice> _device;
    id<MTLRenderPipelineState> _pipelineState;
    id<MTLCommandQueue> _commandQueue;
    
    //resources
    NSArray<MeshGPU*>* meshes_data;    //carrays of meshes to deal with
    MTLVertexDescriptor *_vertexDesc;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView withMeshes:(nonnull NSArray<Mesh*>*)meshes
{
    self = [super init];
    if(self) {
        NSError *error;
        _device = mtkView.device;
      
        NSMutableArray<MeshGPU*> *meshes_accumulator = [NSMutableArray arrayWithCapacity:meshes.count];
        //load data
        for(int i = 0; i < meshes.count; i++) {
            [meshes_accumulator insertObject:[self loadMesh:meshes[i]] atIndex:i];
        }
        meshes_data = [NSArray arrayWithArray:meshes_accumulator];
        
        //setup vertex desc
        _vertexDesc = [[MTLVertexDescriptor alloc] init];
        _vertexDesc.attributes[0].format = MTLVertexFormatFloat3;
        _vertexDesc.attributes[0].bufferIndex = 0;
        _vertexDesc.attributes[0].offset = 0;
        _vertexDesc.layouts[0].stride = sizeof(Vertex); //byte size 12
        
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

- (MeshGPU*)loadMesh:(Mesh*)mesh
{
    //create and upload vertex buffer
    unsigned long vert_count = mesh.vertex_count;
    unsigned long vert_buff_len = sizeof(MTLPackedFloat3) * vert_count;
    id<MTLBuffer> vertexBuffer = [_device newBufferWithLength:vert_buff_len options:MTLResourceStorageModeShared];
    memcpy(vertexBuffer.contents, mesh.vertices, vert_buff_len);
    
    //define uniform buffer for colour/world mat
    
    MeshGPU *mesh_gpu = [[MeshGPU alloc] init];
    mesh_gpu.vert_count = vert_count;
    mesh_gpu.vert_buffer = vertexBuffer;
    return mesh_gpu;
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
    commandEncoder.label = @"My Command Encoder";
    [commandEncoder pushDebugGroup:@"Draw calls"];  //checking draw calls output
    [commandEncoder setRenderPipelineState:_pipelineState];
    
    //draw each mesh
    for(MeshGPU *mesh in meshes_data) {
        [commandEncoder setVertexBuffer:mesh.vert_buffer offset:0 atIndex:0];
        [commandEncoder drawPrimitives:MTLPrimitiveTypeLineStrip vertexStart:0 vertexCount:mesh.vert_count];
    }
    
    [commandEncoder popDebugGroup];
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
