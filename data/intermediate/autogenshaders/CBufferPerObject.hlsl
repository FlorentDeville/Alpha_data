/********************************************************************/
/* © 2025 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************/

#ifndef CBUFFER_PER_OBJECT_HLSL
#define CBUFFER_PER_OBJECT_HLSL

#pragma pack_matrix(row_major)

cbuffer PerObject
{
	matrix worldMatrix;
};

#endif // ifndef CBUFFER_PER_OBJECT_HLSL 
