/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#ifndef SKYBOX_BASE_HLSLI
#define SKYBOX_BASE_HLSLI

struct VS_Output
{
	float4 vertex : SV_Position; //screen space position
	float3 uvw : UV;
};

#endif // ifndef SKYBOX_BASE_HLSLI