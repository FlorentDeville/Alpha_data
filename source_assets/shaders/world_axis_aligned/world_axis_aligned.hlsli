/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#ifndef WORLD_AXIS_ALIGNED
#define WORLD_AXIS_ALIGNED

#include "../Lighting.hlsl"

struct VS_Output
{
	float4 vertex : SV_Position; //screen space position
	float4 worldPosition : TEXCOORD0; //world space
	float4 lightSpacePosition[MAX_LIGHT_COUNT] : TEXCOORD1; //light space
	float3 normal : NORMAL;
};

#endif //ifndef WORLD_AXIS_ALIGNED