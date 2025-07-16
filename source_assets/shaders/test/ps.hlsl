/********************************************************************/
/* © 2025 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************/

#include "CBufferLights.hlsl" 
#include "CBufferPerFrame.hlsl" 
#include "BaseTypes.hlsl"

cbuffer PerMaterial 
{ 
};

struct VS_Output
{
	float4 vertex : SV_Position;
	float3 color : COLOR;
	float2 uv : UV;
	float3 normal : NORMAL;
};

float4 main(VS_Output input) : SV_TARGET 
{ 
	return color(1, 0, 0, 1);
}

