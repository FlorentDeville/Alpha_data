/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../vertex_color_base/vertex_color_base.hlsli"

#include "CBufferPerFrame.hlsl"
#include "CBufferPerObject.hlsl"
#pragma pack_matrix(row_major)

struct VS_Input
{
	float3 vertex : POSITION;
	float3 color : COLOR;
	float2 uv : UV;
	float3 normal : NORMAL;
};

VS_Output main( VS_Input input )
{
	VS_Output output;

	float4 pos = float4(input.vertex, 1.f);
	output.vertex = mul(pos, worldMatrix);
	output.vertex = mul(output.vertex, viewMatrix);
	output.vertex = mul(output.vertex, projMatrix);

    output.color = input.color;

	return output;
}
