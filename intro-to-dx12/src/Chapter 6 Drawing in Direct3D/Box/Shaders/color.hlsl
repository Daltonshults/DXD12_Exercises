//***************************************************************************************
// color.hlsl by Frank Luna (C) 2015 All Rights Reserved.
//
// Transforms and colors geometry.
//***************************************************************************************

cbuffer cbPerObject : register(b0)
{
    float4x4 gWorldViewProj;
    float4 gPulseColor;
    float gTime;
};

struct VertexPosIn
{
    float3 PosL : POSITION;
    // float4 Color : COLOR;
};

struct VertexColorIn
{
    float4 Color : COLOR;
};

struct VertexOut
{
    float4 PosH : SV_POSITION;
    float4 Color : COLOR;
};

VertexOut VS(VertexPosIn vposin, VertexColorIn vcolin)
{
    VertexOut vout;
	
	// Transform to homogeneous clip space.
    vout.PosH = mul(float4(vposin.PosL, 1.0f), gWorldViewProj);
	
	// Just pass vertex color into the pixel shader.
    vout.Color = vcolin.Color;
    
    return vout;
}

float4 PS(VertexOut pin) : SV_Target
{
    const float pi = 3.14159;
    
    float s = 0.5f * sin(2 * gTime - 0.25f * pi + pin.PosH.x) + 0.5f;
    
    float4 c = lerp(pin.Color, gPulseColor, s);
    return c;
}

