/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#ifndef VERTEX_COLOR_BASE_HLSLI
#define VERTEX_COLOR_BASE_HLSLI

struct VS_Output
{
	float4 vertex : SV_Position; //screen space position
	float3 color : TEXCOORD0;
};

#endif // ifndef VERTEX_COLOR_HLSLI