//***************************************************************************************
// color.hlsl by Frank Luna (C) 2015 All Rights Reserved.
//
// Transforms and colors geometry.
//***************************************************************************************
 
cbuffer cbPerObject : register(b0)
{
	float4x4 gWorld; 
};

cbuffer cbPass : register(b1)
{
    float4x4 gView;
    float4x4 gInvView;
    float4x4 gProj;
    float4x4 gInvProj;
    float4x4 gViewProj;
    float4x4 gInvViewProj;
    float3 gEyePosW;
    float cbPerObjectPad1;
    float2 gRenderTargetSize;
    float2 gInvRenderTargetSize;
    float gNearZ;
    float gFarZ;
    float gTotalTime;
    float gDeltaTime;
};

struct VertexIn
{
    float3 PosL : POSITION;
    float3 Normal : NORMAL;
    float4 Color : COLOR;
};

struct VertexOut
{
	float4 PosH  : SV_POSITION;
    float4 Color : COLOR;
};

// VertexOut VS(VertexIn vin)
// {
//	VertexOut vout;
	
	// Transform to homogeneous clip space.
    //float4 posW = mul(float4(vin.PosL, 1.0f), gWorld);
    //vout.PosH = mul(posW, gViewProj);
	
	// Just pass vertex color into the pixel shader.
    //vout.Color = float4(sin(gTotalTime), cos(gTotalTime), sin(gTotalTime), 1.0f);
    
    //return vout;
//}

VertexOut VS(VertexIn vin)
{
    VertexOut vout;
    vin.PosL.y -= 2.0f;
    //vin.PosL.z -= 5.0f;
    float4 posW = mul(float4(vin.PosL, 1.0f), gWorld);
    vout.PosH = mul(posW, gViewProj);

    // Spatial variation (controls pattern)
    float phase = posW.x + posW.y + posW.z;

    // Time animation
    float t = gTotalTime;

    // Black ↔ white wave
    float intensity = 0.5f + 0.5f * sin(phase + t);

    vout.Color = float4(intensity, intensity, intensity, 1.0f);
    return vout;
}

float4 PS(VertexOut pin) : SV_Target
{
    return pin.Color;
}


