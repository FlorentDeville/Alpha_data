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

static const float PI = 3.14159265359f;

float EaseInSine(float x)
{
  return 1 - cos((x * PI) / 2);
}

float EaseOutSine(float x)
{
  return sin((x * PI) / 2);
}

float EaseOutQuad(float x)
{
	return 1 - (1 - x) * (1 - x);
}

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

float4 CalculatePointLight(Light pointLight, float4 fragPosition, float3 normal)
{
	//backface detection
	float3 lightDir = normalize(fragPosition.xyz - pointLight.position); //vector from the light source to the fragment
	float NDotL = dot(lightDir, normal);
	float backfaceIntensity = clamp(NDotL, -1, 0) * -1;

	//attenuation
	float distance = length(pointLight.position - fragPosition.xyz);
	float attenuation = 1.0 / (pointLight.constantAttenuation + pointLight.linearAttenuation * distance + 
    		    pointLight.quadraticAttenuation * (distance * distance));
				
	//TODO : specular
	
	//final color
    float3 finalAmbient = pointLight.ambient * ambientColor.xyz * attenuation * backfaceIntensity;
    float3 finalDiffuse = pointLight.diffuse * diffuseColor.xyz * attenuation * backfaceIntensity;
	
    return float4(finalAmbient + finalDiffuse, 1);
}

float4 CalculateSpotLight(Light spotLight, float4 fragPosition, float3 normal)
{
	float3 lightDir = normalize(fragPosition.xyz - spotLight.position); //vector from the light source to the fragment

	float NDotL = dot(lightDir, normal);
	float backfaceIntensity = clamp(NDotL, -1, 0) * -1;

	float theta = dot(lightDir, normalize(spotLight.direction)); //cos of the angle between the light direction and the fragment

	//cutoff intensity
	float cosOuterCutOff = cos(spotLight.outerCutOff);
	float deltaCutOff = cos(spotLight.cutOff) - cosOuterCutOff;
	float intensity = clamp((theta - cosOuterCutOff) / deltaCutOff, 0.0, 1.0); //interpolate between cutOff and outerCutOff
	intensity = EaseOutQuad(intensity) * backfaceIntensity;

	//attenuation
	float distance = length(spotLight.position - fragPosition.xyz);
	float attenuation = 1.0 / (spotLight.constantAttenuation + spotLight.linearAttenuation * distance + 
    		    spotLight.quadraticAttenuation * (distance * distance));

	//final color
    float3 finalAmbient = spotLight.ambient * ambientColor.xyz * attenuation * intensity;
    float3 finalDiffuse = spotLight.diffuse * diffuseColor.xyz * attenuation * intensity;
	//TODO : specular	

    return float4(finalAmbient + finalDiffuse, 1);
}

float4 main(VS_Output input) : SV_TARGET
{
	float3 normal = normalize(input.normal);
	
	float4 color = float4(0, 0, 0, 1);
	
	if(numLights == 0)
		color = ambientColor;
	
	//float3 normalDir = normalize(normal);
	float3 viewDir = normalize(cameraPosition - input.vertex.xyz);
	
	for(int ii = 0; ii < numLights; ++ii)
	{
		if(lightArray[ii].type == DIRECTIONAL_LIGHT)
		{
			color += CalculateDirectionalLight(lightArray[ii], normal, viewDir);
		}
		else if(lightArray[ii].type == POINT_LIGHT)
		{
			color += CalculatePointLight(lightArray[ii], input.worldPosition, normal);
		}
		else if(lightArray[ii].type == SPOT_LIGHT)
		{
			color += CalculateSpotLight(lightArray[ii], input.worldPosition, normal);
		}
	}
	
    return diffuseColor * color;
}
