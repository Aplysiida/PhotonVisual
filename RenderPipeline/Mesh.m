//
//  Mesh.m
//  RenderPipeline
//
//  Created by robertvict on 15/05/23.
//

#import "Mesh.h"

@implementation Mesh
{
    Vertex *_vertices; //NSArray doesn't support structures so have to use this
    simd_float4x4 _world_pos;
    simd_float3 _colour;
}

-(nonnull instancetype) initFromStringData: (NSString*)string_data
{
    NSArray<NSString*> *coordinates = [string_data componentsSeparatedByString:@", "];
    _vertices = malloc(coordinates.count * sizeof(Vertex));
    
    for(int i = 0; i < coordinates.count; i++) {
        NSArray *coor = [coordinates[i] componentsSeparatedByString:@" "];
        Vertex vertex = {simd_make_float3([coor[0] floatValue], [coor[1] floatValue], [coor[2] floatValue])};
        _vertices[i] = vertex;
    }
    _world_pos = matrix_identity_float4x4;
    _colour = simd_make_float3(1.0, 0.0, 0.0);  //red for now
    
    return self;
}

-(void) dealloc {
    free(_vertices);
}

+(void) parseData: (nonnull NSArray<Mesh*>*)meshes FromFileLocation: (nonnull NSString*)filepath; //load data from file
{   NSError* error;
    NSString* file_contents;
    
    file_contents = [NSString stringWithContentsOfFile:filepath encoding:NSASCIIStringEncoding error:&error];
    NSAssert(file_contents, @"Failed to load file: %@", error);
    //split by new line
    NSArray<NSString*> *photon_trajectories = [file_contents componentsSeparatedByString:@"\n"];
    NSMutableArray *mesh_accumulator = [NSMutableArray arrayWithCapacity:photon_trajectories.count];
    
    for(int i = 0; i < photon_trajectories.count; i++) {
        Mesh *mesh = [[Mesh alloc] initFromStringData:photon_trajectories[i]];
        [mesh_accumulator insertObject:mesh atIndex:i];
    }
    
    meshes = [NSArray arrayWithObjects:mesh_accumulator, nil];
}

@end
