/********************************************************************/
/* © 2025 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************/

#ifndef CBUFFER_PER_OBJECT_HLSL
#define CBUFFER_PER_OBJECT_HLSL

#pragma pack_matrix(row_major)

#include "LightTypes.hlsl"

cbuffer PerObject
{
	matrix worldMatrix;
	matrix lightSpaceMatrix[MAX_LIGHT_COUNT];
};

#endif // ifndef CBUFFER_PER_OBJECT_HLSL 
