//
//  Camera.m
//  RenderPipeline
//
//  Created by robertvict on 18/05/23.
//

#import <Foundation/Foundation.h>
#import "Camera.h"

@implementation Camera {
    simd_float3 cam_position;
}

-(nonnull instancetype) init {
    _current_position = simd_make_float3(0.0f);
    return self;
}

-(simd_float4x4) getCamTransformation
{
    simd_float4x4 mat;
    return mat;
}

@end
