/********************************************************************/
/* © 2021 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************/

#include "../includes/CBufferPerObject.hlsl"
#include "../includes/CBufferPerFrame.hlsl"

struct VS_Input
{
	float3 vertex : POSITION;
	float3 color : COLOR;
	float2 uv : UV;
	float3 normal : NORMAL;
};

struct VS_Output
{
	float4 vertex : SV_Position;
	float3 color : COLOR;
	float2 uv : UV;
	float3 normal : NORMAL;
};

VS_Output main( VS_Input input )
{
	VS_Output output;

	float4 pos = float4(input.vertex, 1.f);
	//output.vertex = mul(pos, worldViewProj);
	//output.vertex = mul(viewMatrix, output.vertex);
	//output.vertex = mul(projMatrix, output.vertex);
	
	output.vertex = mul(pos, worldMatrix);
	output.vertex = mul(output.vertex, viewMatrix);
	output.vertex = mul(output.vertex, projMatrix);
	
	output.uv = input.uv;
	output.color = input.color;
	
	float4 normal = float4(input.normal, 0);
	output.normal = mul(normal, worldMatrix).xyz;
	return output;
}
