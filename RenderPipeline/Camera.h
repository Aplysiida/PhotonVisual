//
//  Camera.h
//  RenderPipeline
//
//  Created by robertvict on 18/05/23.
//

#import <simd/simd.h>

#ifndef Camera_h
#define Camera_h

@interface Camera : NSObject

-(nonnull instancetype) init;
-(simd_float4x4) getCamTransformation;

@end

#endif /* Camera_h */
