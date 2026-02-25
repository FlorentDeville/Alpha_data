/********************************************************************************/
/* Copyright (C) 2026 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

#ifndef LIGHTING_HLSL
#define LIGHTING_HLSL

#include "Math.hlsl"
#include "LightTypes.hlsl"

float4 CalculateDirectionalLight(float3 ambient, float3 diffuse, Light dirLight, float3 normal, float3 view, float shadowIntensity)
{
	float3 lightVec = normalize(-dirLight.direction); // Invert the light direction to get L

	// Calculate the dot product and clamp it to a non-negative value using saturate()
	float diffuseStrength = saturate(dot(normal, lightVec));
	float3 finaDiffuseColor = diffuseStrength * dirLight.diffuse * diffuse;
	
	// Calculate the dot product of the normal and the halfway vector
	//float3 halfVec = normalize(lightVec + view); // Calculate the halfway vector
	//float specularStrength = pow(saturate(dot(normal, halfVec)), specularPower);
	//float3 finalSpecularColor = specularStrength * dirLight.specular * specularColor.xyz;
	
	//calculate ambient
	float3 finalAmbientColor = dirLight.ambient * ambient;

	float3 totalLight = finalAmbientColor + (finaDiffuseColor * shadowIntensity);

	return float4(totalLight, 1);
}

float4 CalculatePointLight(float3 ambient, float3 diffuse, Light pointLight, float4 fragPosition, float3 normal)
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
    float3 finalAmbient = pointLight.ambient * ambient * attenuation * backfaceIntensity;
    float3 finalDiffuse = pointLight.diffuse * diffuse * attenuation * backfaceIntensity;
	
    return float4(finalAmbient + finalDiffuse, 1);
}

float4 CalculateSpotLight(float3 ambient, float3 diffuse, Light spotLight, float4 fragPosition, float3 normal, float shadowIntensity)
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
    float3 finalAmbient = spotLight.ambient * ambient * attenuation * intensity;
    float3 finalDiffuse = spotLight.diffuse * diffuse * attenuation * intensity;
	//TODO : specular	

    return float4(finalAmbient + (finalDiffuse * shadowIntensity), 1);
}

float CalculateSpotLightShadowIntensity(Light spotLight, float4 lightSpacePos, float3 fragWorldPos, Texture2D shadowMap, SamplerState shadowMapSampler)
{
	float3 projCoords = lightSpacePos.xyz / lightSpacePos.w;

	//here projCoords.x is in [-1, 1]. But projCoords.y is in [1, -1]
	projCoords.x = projCoords.x * 0.5 + 0.5;
	projCoords.y = (projCoords.y * -1) * 0.5 + 0.5;

	//float shadowCasterDistance = shadowMap[lightIndex].SampleLevel(shadowMapSampler, projCoords.xy, 0).r;
    float shadowCasterDistance = shadowMap.SampleLevel(shadowMapSampler, projCoords.xy, 0).r;
	float fragDistance = distance(spotLight.position, fragWorldPos);
	float shadowIntensity = fragDistance > shadowCasterDistance ? 0 : 1;
	return shadowIntensity;
}

float CalculateDirLightShadowIntensity(float4 lightSpacePos, Texture2D shadowMap, SamplerState shadowMapSampler)
{
	float3 projCoords = lightSpacePos.xyz / lightSpacePos.w;
	float currentDepth = projCoords.z;

	//here projCoords.x is in [-1, 1]. But projCoords.y is in [1, -1]
	projCoords.x = projCoords.x * 0.5 + 0.5;
	projCoords.y = (projCoords.y * -1) * 0.5 + 0.5;

	const float bias = -0.0001;

	//percentage-closer filtering : sample values around the location nd average the values
	uint2 shadowMapSize;
	shadowMap.GetDimensions(shadowMapSize.x, shadowMapSize.y);
	float2 texelSize = 1.0 / shadowMapSize;

	float shadowIntensity = 0;
	for(int x = -1; x <= 1; ++x)
	{
		for(int y = -1; y <= 1; ++y)
		{
			float2 shadowUV = projCoords.xy + float2(x, y) * texelSize;
			float shadowCasterDepth = shadowMap.SampleLevel(shadowMapSampler, shadowUV, 0).r;
			shadowIntensity += currentDepth - bias > shadowCasterDepth ? 0 : 1;        
		}    
	}
	shadowIntensity /= 9.0;

	return shadowIntensity;
}

/*
Apply all the lights and shadow maps to the ambient and diffuse color
*/
float4 CalculateLitColor(float4 ambient, float4 diffuse, Light lightArray[MAX_LIGHT_COUNT], float4 lightSpacePosition[MAX_LIGHT_COUNT], 
						float4 fragWorldPos, float3 normal, float3 viewDir, Texture2D shadowMaps[MAX_LIGHT_COUNT], SamplerState shadowMapSampler, int numLights)
{
	float4 color = float4(0, 0, 0, 1);

	for(int ii = 0; ii < numLights; ++ii)
	{
		if(lightArray[ii].type == DIRECTIONAL_LIGHT)
		{
			float shadowIntensity = CalculateDirLightShadowIntensity(lightSpacePosition[ii], shadowMaps[ii], shadowMapSampler);
			color += CalculateDirectionalLight(ambient.xyz, diffuse.xyz, lightArray[ii], normal, viewDir, shadowIntensity);
		}
		else if(lightArray[ii].type == POINT_LIGHT)
		{
			float shadowIntensity = 0;
			color += CalculatePointLight(ambient.xyz, diffuse.xyz, lightArray[ii], fragWorldPos, normal);
		}
		else if(lightArray[ii].type == SPOT_LIGHT)
		{
			float shadowIntensity = CalculateSpotLightShadowIntensity(lightArray[ii], lightSpacePosition[ii], fragWorldPos.xyz, shadowMaps[ii], shadowMapSampler);
			color += CalculateSpotLight(ambient.xyz, diffuse.xyz, lightArray[ii], fragWorldPos, normal, shadowIntensity);
		}
	}

	return color;
}

#endif
