/********************************************************************/
/* © 2025 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************/

#ifndef CBUFFER_LIGHTS_HLSL
#define CBUFFER_LIGHTS_HLSL

#pragma pack_matrix(row_major)

struct Light
{
	float3 position;
	float3 direction;
	float coneAngle; // only used for spot light
	int type; //0 : directional, 1 : point, 2 : spot
};

cbuffer CBufferLights
{
	int numLights;
	Light lightArray[8];
};

#endif // ifndef CBUFFER_LIGHTS_HLSL 
