//
//  DataTypes.h
//  RenderPipeline
//
//  Created by robertvict on 3/05/23.
//
#import <Metal/Metal.h>

#ifndef ShaderTypes_h
#define ShaderTypes_h

typedef struct {
    MTLPackedFloat3 position;
} Vertex;

typedef struct {
    simd_float4x4 modelMat;
    simd_float4x4 viewMat;
    simd_float4x4 projectionMat;
} Uniform;

#endif /* DataTypes_h */
