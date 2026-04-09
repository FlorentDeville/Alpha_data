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

float3 fresnelSchlick(float cosTheta, float3 F0)
{
    // F0 is the surface reflection at normal incidence
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}
// Usage:
// float3 F = fresnelSchlick(max(dot(normal, view), 0.0), surfaceColor);

float4 main(VS_Output input) : SV_TARGET
{
	float3 normal = normalize(input.normal);
	//float3 view = normalize(cameraPosition - input.worldPosition.xyz); //point to camera 

	//float3 F0 = float3(0.04, 0.04, 0.04);
	//float3 F = fresnelSchlick(max(dot(normal, view), 0.0), F0);

	float4 diffuseColor = diffuse; //* float4(F, 1);
	float4 ambientColor = diffuse;

	float4 color = diffuseColor + ambientColor;
	
	if(numLights != 0)
	{
		float3 viewDir = normalize(cameraPosition - input.vertex.xyz);
		color = CalculateLitColor(ambientColor, diffuseColor, lightArray, input.lightSpacePosition, input.worldPosition, input.normal, viewDir, shadowMap, shadowMapSampler, numLights);
	}

	float offset = (sin(time * frequency) * amplitude);

	float alphaValue = alpha.Sample(alphaSample, input.uv + (float2)offset).r;
	color.a = alphaValue;
	return color;
}
