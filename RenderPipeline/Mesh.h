//
//  Mesh.h
//  RenderPipeline
//
//  Created by robertvict on 15/05/23.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <simd/simd.h>

#import "ShaderTypes.h"

#ifndef Mesh_h
#define Mesh_h

@interface Mesh : NSObject

-(nonnull instancetype) initFromStringData: (nonnull NSString*)string_data;
-(void) dealloc;

+(void) parseData: (nonnull NSArray<Mesh*>*)meshes FromFileLocation: (nonnull NSString*)filepath; //load data from file
@end

#endif /* Mesh_h */
