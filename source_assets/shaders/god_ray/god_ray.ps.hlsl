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
	float frequency;
	float amplitude;
};

SamplerState alphaSample;
Texture2D alpha;

float4 main(VS_Output input) : SV_TARGET
{
	float3 normal = normalize(input.normal);

	float4 diffuseColor = diffuse; //* float4(F, 1);
	float4 ambientColor = diffuse;

	float4 color = diffuseColor + ambientColor;
	
	if(numLights != 0)
	{
		float3 viewDir = normalize(cameraPosition - input.vertex.xyz);
		color = CalculateLitColor(ambientColor, diffuseColor, lightArray, input.lightSpacePosition, input.worldPosition, normal, viewDir, shadowMap, shadowMapSampler, numLights);
	}

	float offset = (sin(time * frequency) * amplitude);

	const float PI = 3.14159265;

	float alphaV = sin(input.uv.y * PI);
	float alphaValue = alpha.Sample(alphaSample, input.uv + float2(offset, 0)).r;
	color.a = alphaValue * alphaV;
	return color;
}
