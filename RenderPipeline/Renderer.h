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

//enums
typedef enum {
    Perspective,
    Orthographic
} Projections;


@interface MeshGPU : NSObject
    //@property MTLVertexDescriptor *vert_desc;
    @property unsigned long vert_count;
    @property id<MTLBuffer> vert_buffer;
    @property id<MTLBuffer> uniform_buffer;
@end

@interface Renderer : NSObject

@property Projections selected_projection;

-(nonnull instancetype)initWithMetalKitView : (nonnull MTKView *)view;
//-(nonnull instancetype)initWithMetalKitView : (nonnull MTKView *)mtkView;// withMeshes:(nonnull NSArray<Mesh*>*)meshes;
-(void) loadMetalWithMeshes:(nonnull NSArray<Mesh*>*) meshes;

-(simd_float4x4) makePerspectiveWithFOV: (float)fov_radians andAspectRatio: (float)aspect_ratio withNear: (float)near andFar: (float)far;
-(simd_float4x4) makeOrthographic: (nonnull MTKView*)view withNear: (float)near andFar: (float)far;
-(simd_float4x4) initializeNDCMatrix:(nonnull MTKView*) view withProjection: (Projections) selected_proj andView: (simd_float4x4) view_mat;
-(void) initializeUniformBuffer: (nonnull MTKView*) view;

-(void) updateView: (simd_float4x4) view_mat;
-(void) mtkView:(nonnull MTKView*)view drawableSizeWillChange:(CGSize)size;
-(void) drawToView:(nonnull MTKView *) view;

-(MeshGPU*) loadMesh:(Mesh*) mesh;
@end
