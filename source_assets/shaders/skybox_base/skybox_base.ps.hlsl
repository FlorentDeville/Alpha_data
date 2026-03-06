/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../skybox_base/skybox_base.hlsli"

TextureCube cubemap : register(t0);
SamplerState samplerCubemap : register(s0);

float4 main(VS_Output input) : SV_TARGET
{
    float4 color = cubemap.Sample(samplerCubemap, input.uvw);
    return color;
}
