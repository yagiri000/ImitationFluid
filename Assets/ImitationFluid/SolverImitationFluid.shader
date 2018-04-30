Shader "Custom/SolverImitationFluid"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		Cull Off
		LOD 100

		Pass
		{
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
				fixed4 col = tex2D(_MainTex, i.uv);

				fixed4 colR = tex2D(_MainTex, i.uv
				+ float2(sin(col.g * 10) * 0.001, cos(col.b * 10) * 0.001)
				+ float2(
					sin(sin(i.uv.y * 5) * 10) * 0.001,
					sin(cos(i.uv.x * 5) * 10) * 0.001
					));

				fixed4 colG = tex2D(_MainTex, i.uv
				+ float2(sin(col.b * 10) * 0.001, cos(col.r * 10) * 0.001)
				+ float2(
					sin(sin(i.uv.y * 10) * 10) * 0.001,
					cos(sin(i.uv.x * 10) * 10) * 0.001
					));

				fixed4 colB = tex2D(_MainTex, i.uv
				+ float2(sin(col.r * 10) * 0.001, cos(col.g * 10) * 0.001)
				+ float2(
					sin(cos(i.uv.y * 3) * 30) * 0.001,
					cos(cos(i.uv.x * 3) * 30) * 0.001
					));

				const float rDecrement = 1.5 / 255.0;
				const float gDecrement = 2.1 / 255.0;
				const float bDecrement = 1.9 / 255.0;
				colR.r -= rDecrement;
				colG.g -= gDecrement;
				colB.b -= bDecrement;

				return float4(colR.r, colG.g, colB.b, 1.0);
			}
			ENDCG
		}
	}
}
