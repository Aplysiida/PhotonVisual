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
    out.pos = ndc_transform * float4(in.position, 1.0f);
    return out;
}

fragment float4 fragmentShader(VertexOutput in [[stage_in]],
                               constant float3 &colour [[buffer(0)]])
{
    return float4(colour,1.0);
}
