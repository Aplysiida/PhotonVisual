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
    //metal
    id<MTLDevice> _device;
    MTKView *_view;
    id<MTLRenderPipelineState> _pipelineState;
    id<MTLCommandQueue> _commandQueue;
    
    //resources
    id<MTLBuffer> _ndcUniformBuffer;
    
    NSArray<MeshGPU*>* meshes_data;    //carrays of meshes to deal with
    MTLVertexDescriptor *_vertexDesc;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)view// withMeshes:(nonnull NSArray<Mesh*>*)meshes
{
    self = [super init];
    if(self)
    {
        _device = view.device;
        _view = view;
    }
    return self;
}

-(void) loadMetalWithMeshes:(NSArray<Mesh *> *)meshes
{
    NSError *error;
    NSMutableArray<MeshGPU*> *meshes_accumulator = [NSMutableArray arrayWithCapacity:meshes.count];
    //load data
    for(int i = 0; i < meshes.count; i++) {
        [meshes_accumulator insertObject:[self loadMesh:meshes[i]] atIndex:i];
    }
    meshes_data = [NSArray arrayWithArray:meshes_accumulator];
    [self initializeUniformBuffer:_view];
        
    //setup vertex desc
    _vertexDesc = [[MTLVertexDescriptor alloc] init];
    _vertexDesc.attributes[0].format = MTLVertexFormatFloat3;
    _vertexDesc.attributes[0].bufferIndex = 0;
    _vertexDesc.attributes[0].offset = 0;
    _vertexDesc.layouts[0].stride = sizeof(Vertex); //byte size 12
        
    //link shaders
    id<MTLLibrary> shaderDefaultLibrary = [_device newDefaultLibrary];
    id<MTLFunction> vertexShader = [shaderDefaultLibrary newFunctionWithName:@"vertexShader"];
    id<MTLFunction> fragmentShader = [shaderDefaultLibrary newFunctionWithName:@"fragmentShader"];
        
    //setup PSO
    MTLRenderPipelineDescriptor *pipelineStateDesc = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDesc.label = @"Render Pipeline";
    pipelineStateDesc.vertexFunction = vertexShader;
    pipelineStateDesc.fragmentFunction = fragmentShader;
    pipelineStateDesc.colorAttachments[0].pixelFormat = _view.colorPixelFormat;
    pipelineStateDesc.vertexDescriptor = _vertexDesc;
    
    _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDesc error:&error];
    NSAssert(_pipelineState, @"Failed to create pipeline state: %@", error);
    
    //create command queue
    _commandQueue = [_device newCommandQueue];
}

-(simd_float4x4) makePerspectiveWithFOV: (float)fov_radians andAspectRatio: (float)aspect_ratio withNear: (float)near andFar: (float)far {
    //set width and height from fov
    float height = near * tan(fov_radians * 0.5f);
    float width = height * aspect_ratio;
    
    float r = width; //right
    float t = height; //top
    
    return simd_matrix(
                    (simd_float4){near/r, 0.0f, 0.0f, 0.0f},
                    (simd_float4){0.0f, near/t, 0.0f, 0.0f},
                    (simd_float4){0.0f, 0.0f, (far)/(far-near), 1.0f},
                    (simd_float4){0.0f, 0.0f, -(far*near)/(far-near), 0.0f});
    
}

-(simd_float4x4) makeOrthographic: (nonnull MTKView*)view withNear: (float)near andFar: (float)far {
    float aspect_ratio = view.drawableSize.width/view.drawableSize.height;
    
    float r = aspect_ratio; //right
    float t = 1.0f; //top
   
    return simd_matrix(
                       (simd_float4){1.0f/r, 0.0f, 0.0f, 0.0f},
                       (simd_float4){0.0f, 1.0f/t, 0.0f, 0.0f},
                       (simd_float4){0.0f, 0.0f, 1.0f/(far-near), -near/(far-near)},
                       (simd_float4){0.0f, 0.0f, 0.0f, 1.0f});
}

-(simd_float4x4) initializeNDCMatrix:(nonnull MTKView*) view withProjection: (Projections) selected_proj andView: (simd_float4x4) view_mat
{
    simd_float4x4 proj_mat = matrix_identity_float4x4;
    switch(selected_proj) {
        case Perspective:
            proj_mat = [self makePerspectiveWithFOV:M_PI/3.0f
                                     andAspectRatio:view.drawableSize.width/view.drawableSize.height withNear:0.001f andFar:100.0f];
            break;
        default:    //orthographic
            proj_mat = [self makeOrthographic:view withNear:0.001f andFar:100.0f];
    };
    
    return matrix_multiply(proj_mat, view_mat);
}

-(void) initializeUniformBuffer: (MTKView*)view {
    //setup uniforms
    simd_float4x4 ndc_mat = [self initializeNDCMatrix:view withProjection:_selected_projection andView:matrix_identity_float4x4];
    unsigned long buff_len = sizeof(simd_float4x4);
    //upload to uniform buffer
    _ndcUniformBuffer = [_device newBufferWithLength:buff_len options:MTLResourceStorageModeShared];
    memcpy(_ndcUniformBuffer.contents, &ndc_mat, buff_len);
}

-(void)updateView: (simd_float4x4) view_mat
{
    simd_float4x4 new_mat = [self initializeNDCMatrix:_view withProjection:_selected_projection andView:view_mat];
    memcpy(_ndcUniformBuffer.contents, &new_mat, sizeof(simd_float4x4));
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

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size
{
    //update projection matrix
    if(_ndcUniformBuffer != NULL) {
        simd_float4x4 ndc_mat = [self initializeNDCMatrix:view withProjection:_selected_projection andView:matrix_identity_float4x4];
        memcpy(_ndcUniformBuffer.contents, &ndc_mat, sizeof(simd_float4x4));
    }
    
    [self drawToView:view];
}

-(void) drawToView:(MTKView *)view
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
   
    [commandEncoder setVertexBuffer:_ndcUniformBuffer offset:0 atIndex:1];
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

@end
