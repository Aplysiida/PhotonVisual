//
//  Camera.m
//  RenderPipeline
//
//  Created by robertvict on 18/05/23.
//

#import <Foundation/Foundation.h>
#import "CameraController.h"

@implementation CameraController {
    //used to rotate camera around a point
    //based on sphere polar angles
    float _radius;
    float _pitch;
    float _yaw;
    //used for look at
    simd_float3 centre_pos;
    simd_float3 up_vec;
    simd_float3 front_vec;
}

-(nonnull instancetype) init {
    _sensitivity = 0.4f;
    centre_pos = (simd_float3){0.0f, 0.0f, 0.0f};
    up_vec = (simd_float3){0.0f, 1.0f, 0.0f};
    
    _radius = 2.0f;
    _pitch = 0.0f;
    _yaw = 0.0f;
    return self;
}

+(float) toRadians:(float)value
{
    return (value * M_PI)/180.0f;
}

-(void) updateAngles:(NSPoint) mouse_offset
{
    //convert offset to radians
    float pitch_diff = _sensitivity * mouse_offset.x;
    float yaw_diff = _sensitivity * mouse_offset.y;
    
    _pitch += [CameraController toRadians:pitch_diff];
    _yaw += [CameraController toRadians:yaw_diff];
}

-(simd_float3) getCamPos
{
    simd_float3 eye_pos = (simd_float3){    //convert sphere coordinates to cartesian
        _radius * sin(_pitch) * cos(_yaw),
        _radius * sin(_pitch) * sin(_yaw),
        _radius * cos(_pitch)
    };
   
    return eye_pos;
}

+(simd_float4x4) calcLookFromEye: (simd_float3)eye AtCentre: (simd_float3)centre WithUp: (simd_float3)up {
    //normalized
    simd_float3 front_n = simd_normalize(centre - eye);
    simd_float3 up_n = simd_normalize(up);
    
    simd_float3 s = simd_normalize(simd_cross(up_n, front_n));
    simd_float3 u = simd_normalize(simd_cross(front_n, s));
    
    simd_float3 translate = (simd_float3){
        -simd_dot(s, -eye),
        -simd_dot(u, -eye),
        -simd_dot(front_n, eye)
    };
   
    //based on gluLookAt
    return (simd_float4x4){ //remember simd initialises through columns not rows
        (simd_float4){s.x, u.x, -front_n.x, 0.0f},
        (simd_float4){s.y, u.y, -front_n.y, 0.0f},
        (simd_float4){s.z, u.z, -front_n.z, 0.0f},
        (simd_float4){translate.x, translate.y, translate.z, 1.0f}    //include translation to eye
    };
}

@end
