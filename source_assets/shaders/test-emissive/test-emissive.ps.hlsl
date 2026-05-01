/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../test-emissive/test-emissive.hlsli"

#include "BaseTypes.hlsl"

cbuffer PerMaterial
{
	color ambientColor;
	float intensity;
};

SamplerState s1;
Texture2D t1;

float4 main(VS_Output input) : SV_TARGET
{
	return ambientColor * intensity;
}
