Shader /*ase_name*/ "Hidden/Templates/INabStudio/BetterFog" /*end*/
{
	Properties
	{
		/*ase_props*/
	}

	SubShader
	{
		Cull Off 
		ZWrite Off 
		ZTest Always


		/*ase_pass*/
		Pass
		{
			Name "Fog Factor"
			CGPROGRAM

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			/*ase_pragma*/
		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				/*ase_vdata:p=p;uv0=tc0*/
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				/*ase_interp(2,):sp=sp.xyzw;uv0=tc0.xy;uv1=tc1;uv2=tc2*/
			};

			/*ase_globals*/

			/*ase_funcs*/

			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v /*ase_vert_input*/ )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				/*ase_local_var:spn*/float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				/*ase_vert_code:v=ASEAttributesDefault;o=ASEVaryingsDefault*/

				return o;
			}

			float4 Frag (ASEVaryingsDefault i /*ase_frag_input*/ ) : SV_Target
			{
				/*ase_local_var:spn*/float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				/*ase_frag_code:i=ASEVaryingsDefault*/

				float4 color = /*ase_frag_out:Frag Color;Float4*/float4(0,0,0,0)/*end*/;
				
				return color;
			}
			ENDCG
		}

		/*ase_pass*/
		Pass
		{
			/*ase_main_pass*/
			Name "Screen Fog Blend"
			CGPROGRAM

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			/*ase_pragma*/
		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				/*ase_vdata:p=p;uv0=tc0*/
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				/*ase_interp(2,):sp=sp.xyzw;uv0=tc0.xy;uv1=tc1;uv2=tc2*/
			};

			/*ase_globals*/

			/*ase_funcs*/

			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v /*ase_vert_input*/ )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				/*ase_local_var:spn*/float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				/*ase_vert_code:v=ASEAttributesDefault;o=ASEVaryingsDefault*/

				return o;
			}

			float4 Frag (ASEVaryingsDefault i /*ase_frag_input*/ ) : SV_Target
			{
				/*ase_local_var:spn*/float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				/*ase_frag_code:i=ASEVaryingsDefault*/

				float4 color = /*ase_frag_out:Frag Color;Float4*/float4(0,0,0,0)/*end*/;
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}
