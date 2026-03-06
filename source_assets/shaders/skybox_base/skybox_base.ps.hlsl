/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#include "../skybox_base/skybox_base.hlsli"

TextureCube cubemap : register(t0);
SamplerState samplerCubemap : register(s0);

float4 main(VS_Output input) : SV_TARGET
{
    float3 dir = input.worldPosition.xyz;
    float3 uvw = normalize(dir);
    float4 color = cubemap.Sample(samplerCubemap, uvw);
    return color;
}
