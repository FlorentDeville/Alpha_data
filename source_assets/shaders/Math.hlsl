/********************************************************************************/
/* Copyright (C) 2025 Florent Devillechabrol <florent.devillechabrol@gmail.com>	*/
/********************************************************************************/

static const float PI = 3.14159265359f;

#ifndef MATH_HLSL
#define MATH_HLSL

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

#endif //#ifndef MATH_HLSL
