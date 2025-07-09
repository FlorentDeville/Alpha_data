/********************************************************************/
/* © 2021 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************/

#include "../includes/BaseTypes.hlsl"
#include "../includes/CBufferLights.hlsl"
#include "../includes/CBufferPerFrame.hlsl"

cbuffer PerMaterial
{
	color ambientColor;
	color diffuseColor;
	color specularColor;
	float specularPower;
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
	float3 normal = normalize(input.normal);
    //float3 lightDir = normalize(lightArray[0].direction - input.vertex.xyz);
	float3 lightDir = normalize(lightArray[0].direction);
    float3 viewDir = normalize(cameraPosition - input.vertex.xyz);
    float3 reflectionDir = reflect(-lightArray[0].direction, normal);
	reflectionDir = normalize(reflectionDir);
	
    float NdotL = max(0.0f, dot(normal, lightDir));
    float RdotV = max(0.0f, dot(reflectionDir, viewDir));

    float4 ambient = ambientColor;
    float4 diffuse = diffuseColor * NdotL;
    float4 specular = specularColor * pow(RdotV, specularPower);

    float4 color = ambient + diffuse + specular;
    return diffuseColor * color;
}
