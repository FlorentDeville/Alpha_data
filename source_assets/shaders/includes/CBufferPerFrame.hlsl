/********************************************************************/
/* © 2025 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************/

#ifndef CBUFFER_PER_FRAME_HLSL
#define CBUFFER_PER_FRAME_HLSL

#pragma pack_matrix(row_major)

cbuffer PerFrame
{
	matrix viewMatrix;
	matrix projMatrix;
	float3 cameraPosition;
};

#endif // ifndef CBUFFER_PER_FRAME_HLSL 