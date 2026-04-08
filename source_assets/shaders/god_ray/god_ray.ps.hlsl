/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../god_ray/god_ray.hlsli"

#include "../Lighting.hlsl"

#include "BaseTypes.hlsl"
#include "CBufferLights.hlsl"
#include "CBufferPerFrame.hlsl"

cbuffer PerMaterial
{
	color diffuse;
};

SamplerState alphaSample;
Texture2D alpha;

float4 main(VS_Output input) : SV_TARGET
{
	float3 normal = normalize(input.normal);

	float4 ambientColor = diffuse;

	float4 color = diffuse + ambientColor;
	
	if(numLights != 0)
	{
		float3 viewDir = normalize(cameraPosition - input.vertex.xyz);
		color = CalculateLitColor(ambientColor, diffuse, lightArray, input.lightSpacePosition, input.worldPosition, input.normal, viewDir, shadowMap, shadowMapSampler, numLights);
	}
	
	//float4 alphaValue = alpha.Sample(alphaSample, input.uv);
	//color.a = alphaValue.r;
	return color;
}
