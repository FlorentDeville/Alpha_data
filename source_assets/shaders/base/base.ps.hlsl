/********************************************************************/
/* � 2021 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************/

#include "BaseTypes.hlsl"
#include "CBufferLights.hlsl"
#include "CBufferPerFrame.hlsl"

cbuffer PerMaterial
{
	color ambientColor;
	color diffuseColor;
	color specularColor;
	float specularPower;
};

struct VS_Output
{
	float4 vertex : SV_Position; //screen space
	float4 worldPosition : TEXCOORD0; //world space
	float3 color : COLOR;
	float2 uv : UV;
	float3 normal : NORMAL;
};

float4 CalculateDirectionalLight(Light dirLight, float3 normal, float3 view)
{
	float3 lightVec = normalize(-dirLight.direction); // Invert the light direction to get L

	// Calculate the dot product and clamp it to a non-negative value using saturate()
	float diffuseStrength = saturate(dot(normal, lightVec));
	float3 finaDiffuseColor = diffuseStrength * dirLight.diffuse * diffuseColor.xyz;
	
	float3 halfVec = normalize(lightVec + view); // Calculate the halfway vector

	// Calculate the dot product of the normal and the halfway vector
	float specularStrength = pow(saturate(dot(normal, halfVec)), specularPower);
	float3 finalSpecularColor = specularStrength * dirLight.specular * specularColor.xyz;
	
	float3 finalAmbientColor = dirLight.ambient * ambientColor.xyz;
	//float3 totalLight = finalAmbientColor + finaDiffuseColor + finalSpecularColor;
	float3 totalLight = finalAmbientColor + finaDiffuseColor;

	return float4(totalLight, 1);

	//float4 finalColor = float4(totalLight, 1.0) * textureColor;
}

float4 CalculatePointLight(Light pointLight, float4 fragPosition)
{
	//attenuation
	float distance = length(pointLight.position - fragPosition.xyz);
	float attenuation = 1.0 / (pointLight.constantAttenuation + pointLight.linearAttenuation * distance + 
    		    pointLight.quadraticAttenuation * (distance * distance));
				
	//TODO specular
	
	//final color
    float3 finalAmbient = pointLight.ambient * ambientColor.xyz * attenuation;
    float3 finalDiffuse = pointLight.diffuse * diffuseColor.xyz * attenuation;
	
    return float4(finalAmbient + finalDiffuse, 1);
}

float4 main(VS_Output input) : SV_TARGET
{
	float3 normal = normalize(input.normal);
	
	float4 color = float4(0, 0, 0, 1);
	
	if(numLights == 0)
		color = ambientColor;
	
	float3 normalDir = normalize(normal);
	float3 viewDir = normalize(cameraPosition - input.vertex.xyz);
	
	for(int ii = 0; ii < numLights; ++ii)
	{
		if(lightArray[ii].type == DIRECTIONAL_LIGHT)
		{
			color += CalculateDirectionalLight(lightArray[ii], normalDir, viewDir);
		}
		else if(lightArray[ii].type == POINT_LIGHT)
		{
			color += CalculatePointLight(lightArray[ii], input.worldPosition);
		}
		
		//float3 lightDir = normalize(lightArray[ii].direction - input.vertex.xyz);
		//float3 lightDir = normalize(lightArray[ii].direction);
		//float3 viewDir = normalize(cameraPosition - input.vertex.xyz);
		//float3 reflectionDir = reflect(-lightArray[ii].direction, normal);
		//reflectionDir = normalize(reflectionDir);
		
		//float NdotL = max(0.0f, dot(normal, lightDir));
		//float RdotV = max(0.0f, dot(reflectionDir, viewDir));

		//float4 ambient = ambientColor;
		//float4 diffuse = diffuseColor * NdotL;
		//float4 specular = specularColor * pow(RdotV, specularPower);

		//color += ambient + diffuse + specular;
		//color += diffuse + specular;
	}
	
    return diffuseColor * color;
}
