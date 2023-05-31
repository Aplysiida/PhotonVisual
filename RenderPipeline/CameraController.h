//
//  Camera.h
//  RenderPipeline
//
//  Created by robertvict on 18/05/23.
//

#import <simd/simd.h>

#ifndef Camera_h
#define Camera_h

@interface CameraController : NSObject

@property float sensitivity;    //mouse sensitivity
@property float radius; //for zooming in and out
@property simd_float3 centre_point; //used for look at

-(nonnull instancetype) init;
+(float) toRadians:(float) value;
-(void) updateAngles:(NSPoint) mouse_offset;
-(simd_float3) getCamPos;
+(simd_float4x4) calcLookFromEye: (simd_float3)eye AtCentre: (simd_float3)centre WithUp: (simd_float3)up;

@end

#endif /* Camera_h */
