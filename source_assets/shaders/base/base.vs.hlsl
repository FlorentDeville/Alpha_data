/********************************************************************/
/* � 2021 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************/

#include "CBufferPerObject.hlsl"
#include "CBufferPerFrame.hlsl"

struct VS_Input
{
	float3 vertex : POSITION;
	float3 color : COLOR;
	float2 uv : UV;
	float3 normal : NORMAL;
};

struct VS_Output
{
	float4 vertex : SV_Position; //screen space position
	float4 worldPosition : TEXCOORD0; //world space
	float4 lightSpacePosition : TEXCOORD1; //light space
	float3 color : COLOR;
	float2 uv : UV;
	float3 normal : NORMAL;
};

VS_Output main( VS_Input input )
{
	VS_Output output;

	float4 pos = float4(input.vertex, 1.f);
	
	output.worldPosition = mul(pos, worldMatrix);
	output.vertex = mul(output.worldPosition, viewMatrix);
	output.vertex = mul(output.vertex, projMatrix);
	
	output.uv = input.uv;
	output.color = input.color;
	
	float4 normal = float4(input.normal, 0);
	output.normal = mul(normal, worldMatrix).xyz;

	output.lightSpacePosition = mul(output.worldPosition, lightSpaceMatrix);

	return output;
}
