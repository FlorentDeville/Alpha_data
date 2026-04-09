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

SamplerState rayIntensitySample;
Texture2D rayIntensity;

float3 fresnelSchlick(float cosTheta, float3 F0)
{
    return F0 + (1.0 - F0) * pow(clamp(1.0 - cosTheta, 0.0, 1.0), 0.4);
}

float4 main(VS_Output input) : SV_TARGET
{
	float3 normal = normalize(input.normal);
	float3 view = normalize(cameraPosition - input.worldPosition.xyz);
	float cosTheta = max(dot(normal, view), 0.0);
	float3 F0 = float3(0.04, 0.04, 0.04);
	float3 fresnel = fresnelSchlick(cosTheta, F0);
	fresnel = saturate(fresnel);

	float colorIntensity = rayIntensity.Sample(rayIntensitySample, input.uv).r;
	float4 color = diffuse;// * colorIntensity;
	
	float offset = (sin(time * frequency) * amplitude);

	const float PI = 3.14159265;

	float alphaValue = alpha.Sample(alphaSample, input.uv).r;

	//color.a = alphaValue * (1 - fresnel.x) * colorIntensity;
	color.a = alphaValue * colorIntensity;
	return color;
}
