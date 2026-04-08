/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "CBufferPerObject.hlsl"
#include "CBufferPerFrame.hlsl"

#include "../test_translucent/test_translucent.hlsli"

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
	
	output.worldPosition = mul(pos, worldMatrix);
	output.vertex = mul(output.worldPosition, viewMatrix);
	output.vertex = mul(output.vertex, projMatrix);
	
	float4 normal = float4(input.normal, 0);
	output.normal = mul(normal, worldMatrix).xyz;

	output.uv = input.uv;

	[unroll]
	for(int ii = 0; ii < MAX_LIGHT_COUNT; ++ii)
		output.lightSpacePosition[ii] = mul(output.worldPosition, lightSpaceMatrix[ii]);

	return output;
}
