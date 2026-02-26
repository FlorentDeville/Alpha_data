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
	float4 vertex : SV_Position; //screen space position
	float4 worldPosition : TEXCOORD0; //world space
	float4 lightSpacePosition[MAX_LIGHT_COUNT] : TEXCOORD1; //light space
	float3 color : COLOR;
	float2 uv : TEXCOORD9;
	float3 normal : NORMAL;
};

SamplerState s1;
Texture2D t1;
Texture2D t2;

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
	
	float4 diffuse = t1.SampleLevel(s1, input.uv, 0);

	float4 ambient = ambientColor * diffuse;
	diffuse = diffuse * diffuseColor;
	
	color = CalculateLitColor(ambient, diffuse, lightArray, input.lightSpacePosition, input.worldPosition, input.normal, viewDir, shadowMap, shadowMapSampler, numLights);

	
	float4 texel2 = t2.SampleLevel(s1, float2(0, 0), 0);
	//float4 texel2 = float4(0, 0, 0, 0);
	color = color + texel2;

	return color;
}
