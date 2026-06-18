/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#ifndef DASH_CIRCLE
#define DASH_CIRCLE

#include "../Lighting.hlsl"

struct VS_Output
{
	float4 vertex : SV_Position; //screen space position
	float2 uv : TEXCOORD0;
};

#endif //ifndef DASH_CIRCLE
