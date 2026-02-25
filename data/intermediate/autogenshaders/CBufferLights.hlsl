/********************************************************************/
/* © 2025 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************/

#ifndef CBUFFER_LIGHTS_HLSL
#define CBUFFER_LIGHTS_HLSL

#include "LightTypes.hlsl"

#pragma pack_matrix(row_major)

cbuffer CBufferLights
{
	int numLights;
	Light lightArray[MAX_LIGHT_COUNT];
};

Texture2D shadowMap[MAX_LIGHT_COUNT];
SamplerState shadowMapSampler;

#endif // ifndef CBUFFER_LIGHTS_HLSL 
