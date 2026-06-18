/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../dash_circle/dash_circle.hlsli"

#include "../Lighting.hlsl"

#include "BaseTypes.hlsl"
#include "CBufferLights.hlsl"
#include "CBufferPerFrame.hlsl"

cbuffer PerMaterial
{
	float innerCircleRadius;
	float outerCircleRadius;
	
	float gradientLength;

	color diffuse;
};

float4 main(VS_Output input) : SV_TARGET
{
	float2 center = float2(0.5, 0.5);
	float distanceFromCenter = length(input.uv - center);

	if(distanceFromCenter < innerCircleRadius || distanceFromCenter > outerCircleRadius)
		discard;

	float alpha = diffuse.a;

	float innerDistance = distanceFromCenter - innerCircleRadius;
	float outerDistance = outerCircleRadius - distanceFromCenter;

	if(innerDistance < gradientLength)
		alpha = diffuse.a * (innerDistance / gradientLength);
	else if(outerDistance < gradientLength)
		alpha = diffuse.a * (outerDistance / gradientLength);

	//here I know I'm inside the visible part
	color output = diffuse;
	output.a = alpha;
	return output;
}
