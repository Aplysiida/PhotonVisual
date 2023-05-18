//
//  Shaders.metal
//  RenderPipeline
//
//  Created by robertvict on 24/04/23.
//

#include <metal_stdlib>
using namespace metal;

//vertex arguments
struct VertexInput {
    float3 position [[ attribute(0) ]];
};

struct VertexOutput {
    float4 pos [[ position ]];
};

vertex VertexOutput vertexShader(VertexInput in [[ stage_in ]],
                                 constant float4x4 &ndc_transform [[buffer(1)]])
{
    VertexOutput out;
    out.pos = ndc_transform * float4(in.position, 1.0);
    return out;
}

fragment float4 fragmentShader(VertexOutput in [[stage_in]])
{
    return float4(1.0,0.0,0.0,1.0);
}
