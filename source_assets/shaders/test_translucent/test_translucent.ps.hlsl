/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../test_translucent/test_translucent.hlsli"

#include "../Lighting.hlsl"

#include "BaseTypes.hlsl"
#include "CBufferLights.hlsl"
#include "CBufferPerFrame.hlsl"

cbuffer PerMaterial
{
	float alpha;
};

SamplerState diffuseSample;
Texture2D diffuse;

float4 main(VS_Output input) : SV_TARGET
{
	float3 normal = normalize(input.normal);

	float4 diffuseColor = diffuse.SampleLevel(diffuseSample, input.uv, 0);
	float4 ambientColor = diffuseColor;

	float4 color = ambientColor + diffuseColor;
	
	if(numLights != 0)
	{
		float3 viewDir = normalize(cameraPosition - input.vertex.xyz);
		color = CalculateLitColor(ambientColor, diffuseColor, lightArray, input.lightSpacePosition, input.worldPosition, input.normal, viewDir, shadowMap, shadowMapSampler, numLights);
	}
	
	color.a = alpha;
	return color;
}
