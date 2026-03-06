/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../skybox_base/skybox_base.hlsli"

#include "CBufferPerFrame.hlsl"
#pragma pack_matrix(row_major)

struct VS_Input
{
	float3 vertex : POSITION;
	float3 color : COLOR;
	float2 uv : UV;
	float3 normal : NORMAL;
};

float4x4 makeTranslationMatrix(float3 translation)
{
    return float4x4(
        1.0f, 0.0f, 0.0f, 0.f,
        0.0f, 1.0f, 0.0f, 0.f,
        0.0f, 0.0f, 1.0f, 0.f,
        translation.x, translation.y, translation.z, 1.0f
    );
}

float4x4 makeUniformScaleMatrix(float scale)
{
    return float4x4(
        scale, 0.0f, 0.0f, 0.f,
        0.0f, scale, 0.0f, 0.f,
        0.0f, 0.0f, scale, 0.f,
        0.f, 0.f, 0.f, 1.0f
    );
}

VS_Output main( VS_Input input )
{
	VS_Output output;

	float4 pos = float4(input.vertex, 1.f);
	
    matrix translation = makeTranslationMatrix(cameraPosition);
    output.vertex = mul(pos, translation);
	output.vertex = mul(output.vertex, viewMatrix);
	output.vertex = mul(output.vertex, projMatrix);
    output.uvw = input.vertex.xyz;

	return output;
}
