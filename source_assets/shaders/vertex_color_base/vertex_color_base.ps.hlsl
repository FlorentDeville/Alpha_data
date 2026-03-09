/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../vertex_color_base/vertex_color_base.hlsli"

float4 main(VS_Output input) : SV_TARGET
{
    float4 color = float4(input.color, 1);
    return color;
}
