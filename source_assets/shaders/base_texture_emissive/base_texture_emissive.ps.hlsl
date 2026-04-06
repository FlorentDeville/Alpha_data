/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../Lighting.hlsl"

#include "BaseTypes.hlsl"
#include "CBufferLights.hlsl"
#include "CBufferPerFrame.hlsl"

cbuffer PerMaterial
{
	float ambientIntensity;
	float glowFrequency;
	float glowAmplitudeMin;
	float glowAmplitudeMax;
	color glowColor;
};

struct VS_Output
{
	float4 vertex : SV_Position; //screen space position
	float4 worldPosition : TEXCOORD0; //world space
	float4 lightSpacePosition[MAX_LIGHT_COUNT] : TEXCOORD1; //light space
	float3 color : COLOR;
	float2 uv : TEXCOORD9;
	float3 normal : NORMAL;
};

SamplerState diffuseSampler;
Texture2D diffuse;

SamplerState emissiveSampler;
Texture2D emissiveMask;

float4 main(VS_Output input) : SV_TARGET
{
	float3 normal = normalize(input.normal);
	
	float4 texColor = diffuse.SampleLevel(diffuseSampler, input.uv, 0);

	float4 glowMask = emissiveMask.SampleLevel(emissiveSampler, input.uv, 0);

	float glowAmplitudeRange = glowAmplitudeMax - glowAmplitudeMin;
	float4 glowFactor = glowMask * ((sin(time * glowFrequency) * glowAmplitudeRange) + glowAmplitudeMin);

	float4 emissive = glowFactor * glowColor;

	float4 ambient = texColor * ambientIntensity;
	float4 diffuse = texColor;
	//float4 color = ambient + diffuse + emissive;

	if(numLights == 0)
	{
		return ambient + diffuse + emissive;
	}

	float3 viewDir = normalize(cameraPosition - input.vertex.xyz);
	float4 color = CalculateLitColor(ambient, diffuse, lightArray, input.lightSpacePosition, input.worldPosition, input.normal, viewDir, shadowMap, shadowMapSampler, numLights);

	return color + emissive;
}
