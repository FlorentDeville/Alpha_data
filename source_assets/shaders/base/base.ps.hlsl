/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../Lighting.hlsl"

#include "BaseTypes.hlsl"
#include "CBufferLights.hlsl"
#include "CBufferPerFrame.hlsl"

cbuffer PerMaterial
{
	color ambientColor;
	color diffuseColor;
	color specularColor;
	float specularPower;
};

struct VS_Output
{
	float4 vertex : SV_Position; //screen space
	float4 worldPosition : TEXCOORD0; //world space
	float4 lightSpacePosition[MAX_LIGHT_COUNT] : TEXCOORD1; //light space
	float3 color : COLOR;
	float2 uv : UV;
	float3 normal : NORMAL;
};

float4 main(VS_Output input) : SV_TARGET
{
	float3 normal = normalize(input.normal);
	
	float4 color = float4(0, 0, 0, 1);
	
	if(numLights == 0)
	{
		color = ambientColor;
		return color;
	}

	float3 viewDir = normalize(cameraPosition - input.vertex.xyz);
	
	color = CalculateLitColor(ambientColor, diffuseColor, lightArray, input.lightSpacePosition, input.worldPosition, input.normal, viewDir, shadowMap, shadowMapSampler, numLights);

	return color;
}
