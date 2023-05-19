//
//  Camera.m
//  RenderPipeline
//
//  Created by robertvict on 18/05/23.
//

#import <Foundation/Foundation.h>
#import "CameraController.h"

@implementation CameraController {
    simd_float4x4 _cam_position;
    simd_float4x4 _cam_rotation;
}

-(nonnull instancetype) init {
    _cam_position = matrix_identity_float4x4;
    _cam_rotation = matrix_identity_float4x4;
    
    return self;
}

-(void) updatePosition:(simd_float3) position
{
    _cam_position = (simd_float4x4){{
        {1.0f, 0.0f, 0.0f, position[0]},
        {0.0f, 1.0f, 0.0f, position[1]},
        {0.0f, 0.0f, 1.0f, position[2]},
        {0.0f, 0.0f, 0.0f, 1.0f}}};
}

-(simd_float4x4) getCamTransformation
{
    simd_float4x4 mat = matrix_identity_float4x4;
    mat = matrix_multiply(mat, _cam_position);
    mat = matrix_multiply(mat, _cam_rotation);
    
    return mat;
}

@end
