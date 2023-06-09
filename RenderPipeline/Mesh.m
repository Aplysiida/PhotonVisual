//
//  Mesh.m
//  RenderPipeline
//
//  Created by robertvict on 15/05/23.
//

#import "Mesh.h"

@implementation Mesh
{
    simd_float4x4 _world_pos;
}

-(nonnull instancetype) initFromStringData: (NSString*)string_data
{
    float (^float_rand)(void) = ^{return (float)((arc4random() * ((unsigned)RAND_MAX+1))/RAND_MAX);};    //return random float between 0 and 1
    
    NSArray<NSString*> *coordinates = [string_data componentsSeparatedByString:@", "];
    self.vertices = malloc(coordinates.count * sizeof(Vertex));
    self.vertex_count = coordinates.count;
    
    for(int i = 0; i < coordinates.count; i++) {
        NSArray *coor = [coordinates[i] componentsSeparatedByString:@" "];
        Vertex vertex = {MTLPackedFloat3Make([coor[0] floatValue], [coor[1] floatValue], [coor[2] floatValue])};
        self.vertices[i] = vertex;
    }
    _world_pos = matrix_identity_float4x4;
    _colour = MTLPackedFloat3Make(float_rand(), float_rand(), float_rand());
    
    return self;
}

-(void) dealloc {
    free(self.vertices);
}

+(NSArray*) parseDataFromFileLocation: (nonnull NSString*)filepath; //load data from file
{   NSError* error;
    NSString* file_contents;
    
    file_contents = [NSString stringWithContentsOfFile:filepath encoding:NSASCIIStringEncoding error:&error];
    NSAssert(file_contents, @"Failed to load file: %@", error);
    //split by new line
    NSArray<NSString*> *photon_trajectories = [file_contents componentsSeparatedByString:@"\n"];
    NSMutableArray *mesh_accumulator = [NSMutableArray arrayWithCapacity:photon_trajectories.count];
    
    for(int i = 0; i < photon_trajectories.count-1; i++) {    //final line generated by GenerateTrajectories.swift is empty, ignore it
        Mesh *mesh = [[Mesh alloc] initFromStringData:photon_trajectories[i]];
        [mesh_accumulator insertObject:mesh atIndex:i];
    }
    
    NSArray *meshes = [NSArray arrayWithArray:mesh_accumulator];
    return meshes;
}

@end
    
