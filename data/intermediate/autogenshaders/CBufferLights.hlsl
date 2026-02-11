/********************************************************************/
/* © 2025 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************/

#ifndef CBUFFER_LIGHTS_HLSL
#define CBUFFER_LIGHTS_HLSL

#pragma pack_matrix(row_major)

#define MAX_LIGHT_COUNT 8 

#define DIRECTIONAL_LIGHT 0
#define POINT_LIGHT 1
#define SPOT_LIGHT 2

struct Light
{
	float3 position;
	float3 direction;

	float3 ambient;
	float3 diffuse;
	float3 specular;

	float constantAttenuation;
	float linearAttenuation;
	float quadraticAttenuation;

	float cutOff;

	int type; //0 : directional, 1 : point, 2 : spot
};

cbuffer CBufferLights
{
	int numLights;
	Light lightArray[MAX_LIGHT_COUNT];
};

#endif // ifndef CBUFFER_LIGHTS_HLSL 
