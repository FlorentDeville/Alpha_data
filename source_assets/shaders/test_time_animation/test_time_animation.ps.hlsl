/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../test_time_animation/test_time_animation.hlsli"

#include "../Lighting.hlsl"

#include "BaseTypes.hlsl"
#include "CBufferLights.hlsl"
#include "CBufferPerFrame.hlsl"

cbuffer PerMaterial
{
	color ambient;
	color diffuse;
	float frequency;
	float amplitude;
};

float4 main(VS_Output input) : SV_TARGET
{
	float3 normal = normalize(input.normal);

	float factor = sin(time * frequency) * amplitude;
	float4 realAmbient = ambient * factor;
	float4 realDiffuse = diffuse * factor;

	float4 color = realAmbient;
	if(numLights != 0)
	{
		float3 viewDir = normalize(cameraPosition - input.vertex.xyz);
		color = CalculateLitColor(realAmbient, realDiffuse, lightArray, input.lightSpacePosition, input.worldPosition, input.normal, viewDir, shadowMap, shadowMapSampler, numLights);
	}
	
	return color;
}
