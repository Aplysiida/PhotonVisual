//
//  Shaders.metal
//  RenderPipeline
//
//  Created by robertvict on 24/04/23.
//

#include <metal_stdlib>
using namespace metal;

//uniforms
struct Uniforms {
    float4x4 view_mat;
    float4x4 proj_mat;
};

//vertex arguments
struct VertexInput {
    float3 position [[ attribute(0) ]];
};

struct VertexOutput {
    float4 pos [[ position ]];
};

vertex VertexOutput vertexShader(VertexInput in [[ stage_in ]]
                                 )
{
    float4 coor_ndc = float4(in.position[0], in.position[1], in.position[2], 1.0);
    //coor_ndc = uniforms.proj_mat * uniforms.view_mat * coor_ndc;
    
    VertexOutput out;
    out.pos = coor_ndc;
    return out;
}

fragment float4 fragmentShader(VertexOutput in [[stage_in]])
{
    return float4(1.0,0.0,0.0,1.0);
}
