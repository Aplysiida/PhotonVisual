//
//  ViewRenderer.h
//  RenderPipeline
//
//  Created by robertvict on 21/04/23.
//

#import <AppKit/AppKit.h>
#import <MetalKit/MetalKit.h>
#import <Metal/Metal.h>

#import "Mesh.h"
#import "ShaderTypes.h"

@interface MeshGPU : NSObject
    //@property MTLVertexDescriptor *vert_desc;
    @property unsigned long vert_count;
    @property id<MTLBuffer> vert_buffer;
    @property id<MTLBuffer> uniform_buffer;
@end

@interface Renderer : NSObject<MTKViewDelegate>
-(nonnull instancetype)initWithMetalKitView : (nonnull MTKView *)mtkView withMeshes:(nonnull NSArray<Mesh*>*)meshes;
-(void) initializeUniforms;
@end
