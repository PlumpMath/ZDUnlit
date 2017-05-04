﻿/**
XRay Unlit Texture Animation Shader 
Copyright (c) 2017 zrelyydereva
This software is released under the MIT License.
*/
Shader "ZD/XRay/UnlitTextureAnimation"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_XRayTransparency("XRay Transparency",float) = 0.6
        _Scroll_X("Scroll X",float) = 0
		_Scroll_Y("Scroll Y",float) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent+250" }
		LOD 100

		Pass
		{
			ZTest LEqual
			ZWrite off
			Blend SrcAlpha OneMinusSrcAlpha
			Cull off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
            float _Scroll_X;
			float _Scroll_Y;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
                float2 scroll = _Time.y * float2(_Scroll_X , _Scroll_Y);
				fixed4 col = tex2D(_MainTex, i.uv+scroll);
                
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
		Pass
		{
			ZTest GEqual
			ZWrite off
			Blend SrcAlpha OneMinusSrcAlpha
			Cull off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _XRayTransparency;
            float _Scroll_X;
			float _Scroll_Y;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
                float2 scroll = _Time.y * float2(_Scroll_X , _Scroll_Y);
				fixed4 col = tex2D(_MainTex, i.uv+scroll);
				col.w *= _XRayTransparency;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
