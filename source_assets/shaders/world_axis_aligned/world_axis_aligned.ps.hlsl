/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../world_axis_aligned/world_axis_aligned.hlsli"

#include "../Lighting.hlsl"

#include "BaseTypes.hlsl"
#include "CBufferLights.hlsl"
#include "CBufferPerFrame.hlsl"

cbuffer PerMaterial
{
	float scale;
	float ambientIntensity;
};

SamplerState s1;
Texture2D t1;

float4 main(VS_Output input) : SV_TARGET
{
	float3 normal = normalize(input.normal);

	float2 uv;
	if(abs(normal.x) > max(abs(normal.y), abs(normal.z)))
		uv = input.worldPosition.zy;
	else if(abs(normal.y) > max(abs(normal.x), abs(normal.z)))
		uv = input.worldPosition.xz;
	else
		uv = input.worldPosition.xy;

	uv = uv * scale;

	float4 texColor = t1.SampleLevel(s1, uv, 0);

	float4 ambient = texColor * ambientIntensity;
	float4 diffuse = texColor;
	
	float4 color = ambient + diffuse;
	if(numLights != 0)
	{
		float3 viewDir = normalize(cameraPosition - input.vertex.xyz);
		color = CalculateLitColor(ambient, diffuse, lightArray, input.lightSpacePosition, input.worldPosition, input.normal, viewDir, shadowMap, shadowMapSampler, numLights);
	}
	
	return color;
}
