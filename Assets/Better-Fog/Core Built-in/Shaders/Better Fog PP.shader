// Made with Amplify Shader Editor v1.9.1.8
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/INabStudio/BetterFog"
{
	Properties
	{
		_FogColor("_FogColor", Color) = (0.8301887,0.8301887,0.8301887,0)
		UseRadialDistance("Use Radial Distance", Int) = 0
		_Height("_Height", Float) = 4
		_HeightDensity("_HeightDensity", Float) = 0.5
		_DistanceFogOffset("Distance Fog Offset", Float) = 0
		_SceneFogParams("_SceneFogParams", Vector) = (0,0,0,0)
		_SkyboxFill("_SkyboxFill", Range( 0 , 1)) = 0
		_EnergyLoss("_EnergyLoss", Float) = 0
		_FogIntensity("_FogIntensity", Range( 0 , 1)) = 1
		_FogType("FogType", Int) = 0
		_HeightFogType("_HeightFogType", Int) = 1
		[Toggle(_USEGRADIENT_ON)] _UseGradient("UseGradient", Float) = 0
		[Toggle(_USEDISTANCEFOG_ON)] _UseDistanceFog("UseDistanceFog", Float) = 0
		_Scale1("_Scale1", Float) = 0.05
		[Toggle(_USENOISE_ON)] _UseNoise("UseNoise", Float) = 0
		[Toggle(_USEHEIGHTFOG_ON)] _UseHeightFog("UseHeightFog", Float) = 0
		[Toggle(_USESKYBOXHEIGHTFOG_ON)] _UseSkyboxHeightFog("UseSkyboxHeightFog", Float) = 0
		[Toggle(_USESUNLIGHT_ON)] _UseSunLight("UseSunLight", Float) = 0
		_GradientEnd("GradientEnd", Float) = 100
		_GradientStart("GradientStart", Float) = 0
		_SunColor("_SunColor", Color) = (0.9019608,0.8478336,0.8,0)
		_SkyboxFogHardness("_SkyboxFogHardness", Range( 0 , 1)) = 0.692782
		_SkyboxFogIntesity("_SkyboxFogIntesity", Float) = 1
		_SkyboxFogOffset("_SkyboxFogOffset", Range( -1 , 1)) = 0.13
		_SunIntensity("_SunIntensity", Float) = 1
		_SunPower("_SunPower", Float) = 2
		_GradientTexture("GradientTexture", 2D) = "white" {}
		_NoiseTimeScale1("_NoiseTimeScale1", Float) = 1
		_NoiseSpeed1("_NoiseSpeed1", Vector) = (0,0,0,0)
		_Lerp1("_Lerp1", Float) = 0.4
		_NoiseDistanceEnd("_NoiseDistanceEnd", Float) = 0.4
		_NoiseIntensity("_NoiseIntensity", Float) = 1
		_NoiseEndHardness("_NoiseEndHardness", Float) = 6
		_UseNoiseHeight("_UseNoiseHeight", Int) = 0
		_UseNoiseDistance("_UseNoiseDistance", Int) = 0
		[Toggle(_USEFOGOFFSET_ON)] _UseFogOffset("UseFogOffset", Float) = 0
		[Toggle(_USECUSTOMDEPTH_ON)] _UseCustomDepth("UseCustomDepth", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Cull Off
		ZWrite Off
		ZTest Always


		
		Pass
		{
			Name "Fog Factor"
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#define ASE_NEEDS_FRAG_SCREEN_POSITION_NORMALIZED
			#pragma multi_compile __ _USESUNLIGHT_ON
			#pragma multi_compile __ _USEGRADIENT_ON
			#pragma multi_compile __ _USECUSTOMDEPTH_ON
			#pragma multi_compile __ _USENOISE_ON
			#pragma multi_compile __ _USEDISTANCEFOG_ON
			#pragma multi_compile __ _USESKYBOXHEIGHTFOG_ON
			#pragma multi_compile __ _USEHEIGHTFOG_ON
			#pragma multi_compile __ _USEFOGOFFSET_ON

		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				float4 ase_texcoord2 : TEXCOORD2;
			};

			uniform float4 _FogColor;
			uniform sampler2D _GradientTexture;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform sampler2D _CustomDepth;
			uniform float4 _CustomDepth_ST;
			uniform float _GradientStart;
			uniform float _GradientEnd;
			uniform float4 _SunColor;
			uniform float4x4 _InverseView;
			uniform float _SunPower;
			uniform float _SunIntensity;
			uniform int _UseNoiseDistance;
			uniform float _Scale1;
			uniform float3 _NoiseSpeed1;
			uniform float _NoiseTimeScale1;
			uniform float _Lerp1;
			uniform float _NoiseIntensity;
			uniform float _NoiseDistanceEnd;
			uniform float _NoiseEndHardness;
			uniform int _FogType;
			uniform int UseRadialDistance;
			uniform float _DistanceFogOffset;
			uniform float4 _SceneFogParams;
			uniform float _SkyboxFill;
			uniform float _SkyboxFogHardness;
			uniform float _SkyboxFogOffset;
			uniform float _SkyboxFogIntesity;
			uniform int _UseNoiseHeight;
			uniform int _HeightFogType;
			uniform float _HeightDensity;
			uniform float _Height;
			uniform float _FogIntensity;
			uniform sampler2D _FogOffset;
			uniform float4 _FogOffset_ST;


			//This is a late directive
			
			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			

			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				float3 ase_worldPos = mul(unity_ObjectToWorld, float4( (v.vertex).xyz, 1 )).xyz;
				o.ase_texcoord2.xyz = ase_worldPos;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.w = 0;

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float clampDepth610 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_ppsScreenPosFragNorm.xy );
				float2 uv_CustomDepth = i.texcoord.xy * _CustomDepth_ST.xy + _CustomDepth_ST.zw;
				#ifdef _USECUSTOMDEPTH_ON
				float staticSwitch809 = tex2D( _CustomDepth, uv_CustomDepth ).r;
				#else
				float staticSwitch809 = clampDepth610;
				#endif
				float _CustomDepth792 = staticSwitch809;
				float depthToLinear802 = LinearEyeDepth(_CustomDepth792);
				float _ScreenDepthEye738 = depthToLinear802;
				float2 appendResult474 = (float2(( ( _ScreenDepthEye738 + ( _GradientStart * -1.0 ) ) / _GradientEnd ) , 0.0));
				#ifdef _USEGRADIENT_ON
				float4 staticSwitch446 = tex2D( _GradientTexture, appendResult474 );
				#else
				float4 staticSwitch446 = _FogColor;
				#endif
				float4 FogColor191 = staticSwitch446;
				float4 break380 = (ase_ppsScreenPosFragNorm*2.0 + -1.0);
				float4 appendResult381 = (float4(break380.x , break380.y , 1.0 , 1.0));
				float4 break391 = ( mul( unity_CameraInvProjection, appendResult381 ) * _ScreenDepthEye738 );
				float4 appendResult384 = (float4(break391.x , break391.y , break391.z , 1.0));
				float4 WorldPositionFromDepth89 = mul( _InverseView, appendResult384 );
				float4 CameraDirection100 = ( WorldPositionFromDepth89 - float4( _WorldSpaceCameraPos , 0.0 ) );
				float4 normalizeResult272 = normalize( CameraDirection100 );
				float3 ase_worldPos = i.ase_texcoord2.xyz;
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(ase_worldPos);
				float dotResult273 = dot( normalizeResult272 , float4( worldSpaceLightDir , 0.0 ) );
				float4 lerpResult268 = lerp( FogColor191 , _SunColor , saturate( ( pow( ( dotResult273 + 0.0 ) , _SunPower ) * _SunIntensity ) ));
				#ifdef _USESUNLIGHT_ON
				float4 staticSwitch589 = lerpResult268;
				#else
				float4 staticSwitch589 = FogColor191;
				#endif
				float4 FogColorSunblend302 = staticSwitch589;
				float depthToLinear801 = Linear01Depth(_CustomDepth792);
				float _ScreenDepth01737 = depthToLinear801;
				float _DepthDependantScale615 = ( ( 1.0 - _ScreenDepth01737 ) + 0.1 );
				float mulTime656 = _Time.y * _NoiseTimeScale1;
				float simplePerlin3D605 = snoise( ( ( WorldPositionFromDepth89 / ( _Scale1 * _DepthDependantScale615 ) ) + float4( ( _NoiseSpeed1 * mulTime656 ) , 0.0 ) ).xyz );
				simplePerlin3D605 = simplePerlin3D605*0.5 + 0.5;
				float lerpResult628 = lerp( 1.0 , simplePerlin3D605 , _Lerp1);
				float lerpResult674 = lerp( 1.0 , lerpResult628 , _NoiseIntensity);
				float lerpResult672 = lerp( 1.0 , lerpResult674 , saturate( exp2( ( pow( ( _ScreenDepthEye738 / _NoiseDistanceEnd ) , _NoiseEndHardness ) * -1.0 ) ) ));
				#ifdef _USENOISE_ON
				float staticSwitch678 = lerpResult672;
				#else
				float staticSwitch678 = 1.0;
				#endif
				float temp_output_472_0 = max( ( ( ( (float)UseRadialDistance == 1.0 ? length( CameraDirection100 ) : ( _ScreenDepth01737 * _ProjectionParams.z ) ) - _ProjectionParams.y ) + _DistanceFogOffset ) , 0.0 );
				float temp_output_173_0 = ( temp_output_472_0 * _SceneFogParams.x );
				#ifdef _USEDISTANCEFOG_ON
				float staticSwitch521 = ( 1.0 - ( _ScreenDepth01737 >= 1.0 ? 1.0 : saturate(  ( (float)_FogType - 0.0 > 2.0 ? exp2( ( ( temp_output_173_0 * temp_output_173_0 ) * -1.0 ) ) : (float)_FogType - 0.0 <= 2.0 && (float)_FogType + 0.0 >= 2.0 ? exp2( ( ( temp_output_472_0 * _SceneFogParams.y ) * -1.0 ) ) : ( ( temp_output_472_0 * _SceneFogParams.z ) + _SceneFogParams.w ) )  ) ) );
				#else
				float staticSwitch521 = 0.0;
				#endif
				float FactorDistance96 = staticSwitch521;
				float Noise_DistanceFactor685 = ( ( (float)_UseNoiseDistance == 1.0 ? staticSwitch678 : 1.0 ) * FactorDistance96 );
				float smoothstepResult263 = smoothstep( _SkyboxFogHardness , 1.0 , saturate( ( ( ( ( WorldPositionFromDepth89.y * -1.0 ) / ( _ProjectionParams.z * 2.0 ) ) + 1.0 ) + _SkyboxFogOffset ) ));
				float lerpResult704 = lerp( 0.0 , saturate( smoothstepResult263 ) , _SkyboxFogIntesity);
				float lerpResult518 = lerp( _SkyboxFill , 1.0 , lerpResult704);
				#ifdef _USESKYBOXHEIGHTFOG_ON
				float staticSwitch524 = ( _ScreenDepth01737 >= 1.0 ? lerpResult518 : 0.0 );
				#else
				float staticSwitch524 = 0.0;
				#endif
				float FactorSkyboxHeight207 = staticSwitch524;
				float _HeightVar591 = _Height;
				float temp_output_122_0 = ( _WorldSpaceCameraPos.y - _HeightVar591 );
				float temp_output_123_0 = ( temp_output_122_0 <= 0.0 ? 1.0 : 0.0 );
				float saferPower146 = abs( min( ( ( 1.0 - ( temp_output_123_0 * 2.0 ) ) * ( ( CameraDirection100 + _WorldSpaceCameraPos.y ).y - _HeightVar591 ) ) , 0.0 ) );
				float temp_output_145_0 = ( ( length( ( _HeightDensity * CameraDirection100 ) ) * -1.0 ) * ( ( ( ( ( CameraDirection100 + _WorldSpaceCameraPos.y ).y + temp_output_122_0 ) - _HeightVar591 ) * temp_output_123_0 ) - ( pow( saferPower146 , 2.0 ) / abs( ( CameraDirection100.y + 1E-05 ) ) ) ) );
				#ifdef _USEHEIGHTFOG_ON
				float staticSwitch537 = ( 1.0 - saturate( exp2( (  ( (float)_HeightFogType - 0.0 > 1.0 ? ( temp_output_145_0 * temp_output_145_0 ) : (float)_HeightFogType - 0.0 <= 1.0 && (float)_HeightFogType + 0.0 >= 1.0 ? temp_output_145_0 : 0.0 )  * -1.0 ) ) ) );
				#else
				float staticSwitch537 = 0.0;
				#endif
				float FactorHeight156 = staticSwitch537;
				float Noise_HeightFactor353 = ( ( (float)_UseNoiseHeight == 1.0 ? staticSwitch678 : 1.0 ) * FactorHeight156 );
				float FactorCombined514 = ( saturate( ( FogColorSunblend302.a * ( Noise_DistanceFactor685 + FactorSkyboxHeight207 + Noise_HeightFactor353 ) ) ) * _FogIntensity );
				float4 appendResult824 = (float4(0.0 , 0.0 , 0.0 , 0.0));
				float2 uv_FogOffset = i.texcoord.xy * _FogOffset_ST.xy + _FogOffset_ST.zw;
				float4 tex2DNode815 = tex2D( _FogOffset, uv_FogOffset );
				float4 appendResult823 = (float4(tex2DNode815.r , tex2DNode815.g , 0.0 , 0.0));
				#ifdef _USEFOGOFFSET_ON
				float4 staticSwitch814 = appendResult823;
				#else
				float4 staticSwitch814 = appendResult824;
				#endif
				float4 _CustomAdditionalFog808 = staticSwitch814;
				float4 break826 = _CustomAdditionalFog808;
				float4 appendResult765 = (float4((FogColorSunblend302).rgb , saturate( ( ( FactorCombined514 * ( 1.0 - break826.y ) ) + break826.x ) )));
				

				float4 color = appendResult765;
				
				return color;
			}
			ENDCG
		}

		
		Pass
		{
			
			Name "Screen Fog Blend"
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#define ASE_NEEDS_FRAG_SCREEN_POSITION_NORMALIZED
			#pragma multi_compile __ _USECUSTOMDEPTH_ON

		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _EnergyLoss;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform sampler2D _CustomDepth;
			uniform float4 _CustomDepth_ST;
			uniform sampler2D _FogFactor_RT;
			uniform float4 _FogFactor_RT_ST;


			
			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float2 uv_MainTex = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 MainTex43 = tex2D( _MainTex, uv_MainTex );
				float clampDepth610 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_ppsScreenPosFragNorm.xy );
				float2 uv_CustomDepth = i.texcoord.xy * _CustomDepth_ST.xy + _CustomDepth_ST.zw;
				#ifdef _USECUSTOMDEPTH_ON
				float staticSwitch809 = tex2D( _CustomDepth, uv_CustomDepth ).r;
				#else
				float staticSwitch809 = clampDepth610;
				#endif
				float _CustomDepth792 = staticSwitch809;
				float depthToLinear801 = Linear01Depth(_CustomDepth792);
				float _ScreenDepth01737 = depthToLinear801;
				float2 uv_FogFactor_RT = i.texcoord.xy * _FogFactor_RT_ST.xy + _FogFactor_RT_ST.zw;
				float4 tex2DNode777 = tex2D( _FogFactor_RT, uv_FogFactor_RT );
				float _FogFactorRT_Factor772 = tex2DNode777.a;
				float FactorEnergyLoss528 = ( 1.0 - ( _ScreenDepth01737 >= 1.0 ? 0.0 : _FogFactorRT_Factor772 ) );
				float lerpResult496 = lerp( 1.0 , FactorEnergyLoss528 , _FogFactorRT_Factor772);
				float smoothstepResult497 = smoothstep( 0.0 , _EnergyLoss , saturate( max( lerpResult496 , 1E-05 ) ));
				float3 _FogFactorRT_Color764 = (tex2DNode777).rgb;
				float4 lerpResult194 = lerp( ( MainTex43 * smoothstepResult497 ) , float4( _FogFactorRT_Color764 , 0.0 ) , _FogFactorRT_Factor772);
				

				float4 color = lerpResult194;
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19108
Node;AmplifyShaderEditor.CommentaryNode;819;2584.741,-5192.231;Inherit;False;1226.859;388.248;;5;808;824;823;814;815;Fog Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;818;2848.587,-5673.857;Inherit;False;808.823;270.5786;;5;737;738;803;801;802;Depth ;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;786;2480.639,-4675.418;Inherit;False;1239.934;393.2716;;8;799;816;773;767;766;765;775;825;Fog RT;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;682;3503.356,679.4407;Inherit;False;5161.871;1499.967;;40;678;693;695;675;669;652;650;643;640;616;606;788;605;743;696;668;662;663;664;674;628;639;686;684;685;353;691;631;630;694;688;319;615;613;611;609;679;656;654;672;3dNoise;0.4644606,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;564;889.6877,-2827.014;Inherit;False;1168.145;300.4961;;5;563;528;761;760;525;Energy Loss Final Factor;0.811035,0.8396226,0.1148541,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;561;6908.125,-5276.851;Inherit;False;1622.524;626.6094;;11;514;505;240;478;479;480;506;512;702;604;513;Final Fog Factor;0.811035,0.8396226,0.1148541,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;517;4873.457,-5624.204;Inherit;False;1694.972;620.6996;;10;1;191;446;474;467;473;502;450;787;820;Fog Color;0.7134212,0.720837,0.9056604,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;504;403.3504,-3427.962;Inherit;False;2014.199;507.9763;;12;483;488;194;438;187;501;496;497;498;185;184;769;Final Composite;0.811035,0.8396226,0.1148541,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;432;7197.364,-3752.976;Inherit;False;1129.725;421.4189;;4;100;45;94;93;Camera Direction;0.7490196,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;301;4239.025,-4939.372;Inherit;False;2434.675;673.9562;;16;275;278;277;587;269;192;272;273;274;276;268;302;270;589;590;822;Sun Color Blend;0.7134212,0.720837,0.9056604,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;255;4039.531,-2181.481;Inherit;False;3624.398;769.3116;;24;206;205;524;554;237;523;207;519;264;258;261;518;248;263;262;260;247;232;246;209;236;210;704;741;Skybox Fog;0.2730509,0.4009349,0.9811321,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;155;5603.114,-1047.783;Inherit;False;2913.928;1098.58;;24;537;156;153;146;148;147;145;566;580;575;578;577;579;538;574;152;546;547;545;137;144;151;150;149;Height Fog;0.2730509,0.4009349,0.9811321,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;136;4490.903,-184.6745;Inherit;False;649.0994;393.41;c2;4;132;133;135;134;;0.2730509,0.4009349,0.9811321,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;131;3699.838,-1017.889;Inherit;False;1256.333;748.2925;c1;11;116;126;127;128;129;122;121;124;123;154;592;;0.2730509,0.4009349,0.9811321,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;114;4046.082,-3127.284;Inherit;False;3575.522;770.3059;;33;96;172;472;163;162;453;470;111;102;433;436;104;441;168;171;170;169;106;103;107;110;521;522;108;109;173;174;175;176;569;698;740;742;Distance Fog;0.2730509,0.4009349,0.9811321,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;90;4371.44,-4022.58;Inherit;False;2387.422;605.0495;;14;89;392;394;384;391;389;385;420;381;380;427;426;553;739;World Position From Depth;0.7490196,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;61;-1398.673,-3398.541;Inherit;False;597.7333;280;;2;40;43;Main Texture Sample;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;210;4386.63,-2036.195;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;4476.562,-1751.214;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;246;4553.096,-2032.635;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;232;4719.038,-1960.2;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2000;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;247;4905.096,-1959.635;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;260;5122.063,-2012.049;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;262;5291.063,-1990.049;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;263;5461.063,-1966.049;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.8;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;1795.37,-3262.295;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;498;1291.526,-3255.514;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;496;926.4754,-3238.046;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;149;6195.635,-235.8874;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;5708.738,-220.4494;Inherit;False;100;CameraDirection;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;151;5917.739,-173.4494;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;4616.929,-134.6745;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;133;4800.002,-126.1275;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;135;4540.904,73.73655;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ProjectionParams;554;4196.913,-1864.638;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;6306.56,-658.9724;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;545;5968.111,-793.7845;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LengthOpNode;547;6151.559,-696.4583;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;563;1586.986,-2680.377;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;268;5954.207,-4761.439;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;276;5815.07,-4560.894;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;274;5666.341,-4533.446;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;273;4939.374,-4650.165;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;-2,2,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;277;5360.263,-4642.69;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;587;5138.184,-4636.88;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;272;4607.285,-4725.565;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;546;5756.559,-701.4583;Inherit;False;100;CameraDirection;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;8079.792,-3560.123;Inherit;False;CameraDirection;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;93;7843.211,-3628.421;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;6477.008,-3688.765;Inherit;False;WorldPositionFromDepth;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;392;6244.096,-3706.253;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;672;6770.729,1508.547;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;654;4361.222,1238.21;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;656;4203.772,1293.103;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;679;6751.608,1295.015;Inherit;False;Constant;_Float0;Float 0;38;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;152;6047.739,-109.4494;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1E-05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;609;4226.043,875.1885;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;574;7944.736,-554.057;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;579;7246.783,-577.7608;Inherit;False;6;0;INT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;577;7506.251,-570.5573;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Exp2OpNode;578;7684.252,-557.5563;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;575;7810.93,-555.6379;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;566;7030.736,-704.4687;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;6724.783,-558.6407;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;687;4303.619,77.09918;Inherit;False;591;_HeightVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;4020.838,-937.9608;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;127;4153.837,-888.9609;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;4794.171,-578.0387;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;128;4371.837,-806.9601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;129;4590.837,-708.9609;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;154;3744.306,-857.162;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;116;3784.171,-967.8899;Inherit;False;100;CameraDirection;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMinOpNode;147;5708.368,-432.063;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;148;6330.025,-341.3174;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;146;5891.368,-395.0629;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;153;6502.379,-407.6566;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;4975.603,45.47244;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;123;4450.767,-518.6825;Inherit;False;5;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;611;5417.118,951.9275;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;613;5586.945,959.5786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;615;5734.32,969.5925;Inherit;False;_DepthDependantScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;121;3859.653,-651.6707;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;122;4124.235,-567.4856;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;8306.309,-739.7449;Inherit;False;FactorHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;319;4020.003,728.4207;Inherit;False;89;WorldPositionFromDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;688;4381.642,730.1377;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Compare;694;7427.88,1259.161;Inherit;False;0;4;0;INT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;630;7840.063,1909.937;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;631;7655.176,2040.784;Inherit;False;156;FactorHeight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;691;7524.641,1735.501;Inherit;False;0;4;0;INT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;353;8074.233,1850.243;Inherit;False;Noise_HeightFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;685;8099.163,1353.098;Inherit;False;Noise_DistanceFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;684;7832.066,1355.174;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;686;7569.07,1465.172;Inherit;False;96;FactorDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;523;6635.708,-1700.42;Inherit;False;Constant;_Float7;Float 6;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;518;6339.929,-1889.195;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;248;5706.44,-1844.38;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;704;6066.548,-1779.575;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;207;7228.191,-1857.741;Inherit;False;FactorSkyboxHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;427;4679.889,-3696.359;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;380;4924.195,-3691.413;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;381;5093.195,-3692.413;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;385;5264.61,-3735.096;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;389;5496.473,-3723.861;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;384;5990.706,-3701.822;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;391;5788.753,-3682.459;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ScreenPosInputsNode;426;4440.807,-3706.587;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Matrix4X4Node;394;5909.722,-3922.492;Inherit;False;Global;_InverseView;_InverseView;13;0;Create;True;0;0;0;False;0;False;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.CameraProjectionNode;420;4944.311,-3860.665;Inherit;False;unity_CameraInvProjection;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;94;7494.031,-3522.963;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;194;2224.883,-3255.231;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Compare;206;6610.019,-1909.943;Inherit;False;3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;761;1414.201,-2760.27;Inherit;False;3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;762;-679.8958,-3380.703;Inherit;False;861.7333;288;;4;764;770;772;777;_FogFactorRT;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;302;6436.105,-4698.553;Inherit;False;FogColorSunblend;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;474;5498.286,-5190.253;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;467;5322.679,-5196.608;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;122.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;502;5136.536,-5305.584;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;702;7259.859,-5202.114;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;480;7640.452,-5175.541;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;479;7508.658,-4995.847;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;240;7867.857,-5166.465;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;505;8090.007,-5151.167;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;770;-283.422,-3322.807;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;5696.656,-4898.244;Inherit;False;191;FogColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;497;1479.127,-3202.498;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;639;4703.821,1238.075;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;628;5518.509,1249.565;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;674;6331.843,1290.054;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;664;6584.013,1799.066;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Exp2OpNode;663;6438.335,1818.147;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;662;6277.334,1816.146;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;668;6120.083,1833.309;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;6.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;696;5960.706,1693.331;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;743;5722.186,1674.082;Inherit;False;738;_ScreenDepthEye;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;605;5062.142,1254.66;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;787;4915.227,-5362.499;Inherit;False;738;_ScreenDepthEye;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;739;4898.536,-3487.752;Inherit;False;738;_ScreenDepthEye;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;788;5197.31,992.5237;Inherit;False;737;_ScreenDepth01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;791;2619.311,-6133.37;Inherit;False;1280.354;358.4805;;4;809;610;793;792;Depth Sample;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;110;4852.081,-2961.284;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;107;4368.083,-2925.284;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;4129.082,-2932.284;Inherit;False;100;CameraDirection;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Compare;106;4552.78,-3024.884;Inherit;False;0;4;0;INT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;5556.742,-2959.354;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;441;5809.221,-2900.953;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;453;6523.218,-2901.694;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;162;5164.297,-2954.889;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;472;5334.512,-2895.415;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ProjectionParams;111;4651.081,-2811.284;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;5572.382,-2600.751;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;5743.382,-2590.753;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;5893.384,-2572.753;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;569;5388.1,-2506.923;Inherit;False;_SceneFogParams;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;5551.742,-2788.354;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;5689.741,-2739.354;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;4458.533,-2670.268;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;102;4172.2,-2699.937;Inherit;False;1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ProjectionParams;109;4186.533,-2602.269;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;470;6776.355,-3020.167;Inherit;False;3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;436;6197.71,-3035.073;Inherit;False;6;0;INT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;698;7003.33,-2967.002;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;522;7032.341,-2713.128;Inherit;False;Constant;_Float6;Float 6;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;740;4181.043,-2792.995;Inherit;False;737;_ScreenDepth01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;7449.566,-2897.749;Inherit;False;FactorDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;776;2498.39,-3258.906;Float;False;True;-1;2;ASEMaterialInspector;0;18;Hidden/INabStudio/BetterFog;8268af943e8e93a4d81aac1a2a72e8fa;True;Screen Fog Blend;0;1;Screen Fog Blend;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;2;True;True;False;;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;741;6391.626,-2084.228;Inherit;False;737;_ScreenDepth01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;205;6405.018,-1984.943;Inherit;False;1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;792;3477.514,-6051.827;Inherit;False;_CustomDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;737;3425.41,-5623.857;Inherit;False;_ScreenDepth01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;738;3416.859,-5521.248;Inherit;False;_ScreenDepthEye;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;803;2898.587,-5577.588;Inherit;False;792;_CustomDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;799;3083.668,-4503.376;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;765;3280.077,-4585.445;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;767;2761.216,-4628.935;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;591;3924.065,-40.07831;Inherit;False;_HeightVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;775;3490.452,-4511.995;Float;False;False;-1;2;ASEMaterialInspector;0;18;New Amplify Shader;8268af943e8e93a4d81aac1a2a72e8fa;True;Fog Factor;0;0;Fog Factor;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;766;2531.638,-4633.418;Inherit;False;302;FogColorSunblend;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;590;5964.696,-4859.128;Inherit;False;191;FogColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;764;-37.58196,-3323.883;Inherit;False;_FogFactorRT_Color;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;187;1280.311,-3067.856;Inherit;False;Property;_EnergyLoss;_EnergyLoss;10;0;Create;True;0;0;0;False;0;False;0;0.0001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;525;1152.688,-2639.014;Inherit;False;772;_FogFactorRT_Factor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;772;-274.422,-3205.808;Inherit;False;_FogFactorRT_Factor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;528;1795.695,-2690.297;Inherit;False;FactorEnergyLoss;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;488;632.3504,-3160.034;Inherit;False;772;_FogFactorRT_Factor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;501;1135.637,-3235.004;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1E-05;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;184;1590.848,-3377.962;Inherit;False;43;MainTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;438;1893.555,-3128.919;Inherit;False;764;_FogFactorRT_Color;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;769;1941.099,-3038.26;Inherit;False;772;_FogFactorRT_Factor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LinearDepthNode;801;3178.226,-5616.332;Inherit;False;1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LinearDepthNode;802;3165.324,-5519.279;Inherit;False;0;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;760;1127.808,-2737.555;Inherit;False;737;_ScreenDepth01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;5698.183,-5510.118;Inherit;False;Property;_FogColor;_FogColor;0;0;Create;True;0;0;0;False;0;False;0.8301887,0.8301887,0.8301887,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;450;5125.235,-5119.505;Inherit;False;Property;_GradientEnd;GradientEnd;21;0;Create;False;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;473;5683.783,-5266.441;Inherit;True;Property;_GradientTexture;GradientTexture;29;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;446;6008.643,-5413.41;Inherit;False;Property;_UseGradient;UseGradient;14;0;Create;True;0;0;0;True;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;191;6344.43,-5366.45;Inherit;False;FogColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;270;4351.68,-4718.147;Inherit;False;100;CameraDirection;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;7455.006,-3668.413;Inherit;False;89;WorldPositionFromDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;278;5194.595,-4472.638;Inherit;False;Property;_SunPower;_SunPower;28;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;275;5472.483,-4420.631;Inherit;False;Property;_SunIntensity;_SunIntensity;27;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;269;5669.751,-4794.695;Inherit;False;Property;_SunColor;_SunColor;23;0;Create;True;0;0;0;False;0;False;0.9019608,0.8478336,0.8,0;0.990566,0.9074031,0.7989943,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;589;6161.697,-4766.128;Inherit;False;Property;_UseSunLight;UseSunLight;20;0;Create;True;0;0;0;True;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;40;-1348.672,-3348.541;Inherit;True;Global;_MainTex;_MainTex;4;0;Create;True;0;0;0;True;0;False;-1;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-1024.939,-3293.099;Inherit;False;MainTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;777;-616.9402,-3329.281;Inherit;True;Global;_FogFactor_RT;_FogFactor_RT;39;0;Create;True;0;0;0;True;0;False;-1;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;104;4250.083,-3077.284;Inherit;False;Property;UseRadialDistance;Use Radial Distance;1;0;Create;False;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;4934.905,-2819.753;Inherit;False;Property;_DistanceFogOffset;Distance Fog Offset;7;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;168;5110.741,-2665.352;Inherit;False;Property;_SceneFogParams;_SceneFogParams;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;433;5987,-3053.354;Inherit;False;Property;_FogType;FogType;12;0;Create;False;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StaticSwitch;521;7216.497,-2802.361;Inherit;False;Property;_UseDistanceFog;UseDistanceFog;15;0;Create;True;0;0;0;True;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Exp2OpNode;172;5867.742,-2726.353;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Exp2OpNode;176;6039.381,-2582.753;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;742;6554.994,-3043.662;Inherit;False;737;_ScreenDepth01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;4102.529,-2060.282;Inherit;False;89;WorldPositionFromDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;237;4300.562,-1657.215;Inherit;False;Constant;_Size;Size;14;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;261;4785.062,-1800.049;Inherit;False;Property;_SkyboxFogOffset;_SkyboxFogOffset;26;0;Create;True;0;0;0;False;0;False;0.13;0.13;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;264;5142.955,-1792.339;Inherit;False;Property;_SkyboxFogHardness;_SkyboxFogHardness;24;0;Create;True;0;0;0;False;0;False;0.692782;0.692782;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;524;6825.594,-1867.653;Inherit;False;Property;_UseSkyboxHeightFog;UseSkyboxHeightFog;19;0;Create;True;0;0;0;True;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;5803.684,-1620.123;Inherit;False;Property;_SkyboxFogIntesity;_SkyboxFogIntesity;25;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;519;5950.181,-1934.218;Inherit;False;Property;_SkyboxFill;_SkyboxFill;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;592;3962.289,-364.5363;Inherit;False;591;_HeightVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;3701.333,-39.1219;Inherit;False;Property;_Height;_Height;2;0;Create;True;0;0;0;False;0;False;4;3.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;5755.318,-787.0733;Inherit;False;Property;_HeightDensity;_HeightDensity;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;580;6977.198,-855.9028;Inherit;False;Property;_HeightFogType;_HeightFogType;13;0;Create;True;0;0;0;False;0;False;1;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;538;7824.532,-877.8093;Inherit;False;Constant;_Float8;Float 6;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;537;7997.277,-804.0189;Inherit;False;Property;_UseHeightFog;UseHeightFog;18;0;Create;True;0;0;0;True;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;606;3983.518,816.4946;Inherit;False;Property;_Scale1;_Scale1;16;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;616;3952.244,942.8545;Inherit;False;615;_DepthDependantScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;640;4091.821,1105.075;Inherit;False;Property;_NoiseSpeed1;_NoiseSpeed1;32;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;643;3967.322,1299.015;Inherit;False;Property;_NoiseTimeScale1;_NoiseTimeScale1;31;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;650;5335.719,1387.4;Inherit;False;Property;_Lerp1;_Lerp1;33;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;652;5732.269,1789.626;Inherit;False;Property;_NoiseDistanceEnd;_NoiseDistanceEnd;34;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;669;5934.193,1965.179;Inherit;False;Property;_NoiseEndHardness;_NoiseEndHardness;36;0;Create;True;0;0;0;False;0;False;6;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;675;6116.843,1488.053;Inherit;False;Property;_NoiseIntensity;_NoiseIntensity;35;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;695;7136.413,1194.529;Inherit;False;Property;_UseNoiseDistance;_UseNoiseDistance;38;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;693;7194.673,1718.325;Inherit;False;Property;_UseNoiseHeight;_UseNoiseHeight;37;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StaticSwitch;678;6921.858,1354.141;Inherit;False;Property;_UseNoise;UseNoise;17;0;Create;True;0;0;0;False;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;513;6958.124,-5104.354;Inherit;False;207;FactorSkyboxHeight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;512;6955.358,-5221.851;Inherit;False;685;Noise_DistanceFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;604;6956.563,-5005.473;Inherit;False;353;Noise_HeightFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;478;7225.302,-4863.625;Inherit;False;302;FogColorSunblend;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;506;7778.979,-4918.57;Inherit;False;Property;_FogIntensity;_FogIntensity;11;0;Create;True;0;0;0;False;0;False;1;0.0001;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;514;8305.009,-5141.878;Inherit;False;FactorCombined;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;483;665.6417,-3327.966;Inherit;False;528;FactorEnergyLoss;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;503;4720.536,-5239.586;Inherit;False;Property;_GradientStart;GradientStart;22;0;Create;False;0;0;0;False;0;False;0;111;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;820;4952.283,-5236.641;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;556;5303.146,-3377.03;Inherit;False;Property;_FarPlaneClip;_FarPlaneClip;30;0;Create;True;0;0;0;False;0;False;1000;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;553;5492.203,-3422.001;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1000;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;390;5077.474,-3368.44;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;822;4665.706,-4509.857;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;773;2517.329,-4513.107;Inherit;False;514;FactorCombined;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;826;2386.897,-4257.258;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;825;2957.897,-4343.258;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;793;2724.71,-5976.161;Inherit;True;Global;_CustomDepth;_CustomDepth;5;0;Create;True;0;0;0;True;0;False;-1;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;809;3073.102,-6057.992;Inherit;False;Property;_UseCustomDepth;UseCustomDepth;41;0;Create;True;0;0;0;True;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;610;2831.519,-6075.686;Inherit;False;1;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;814;3250.359,-5016.914;Inherit;False;Property;_UseFogOffset;UseFogOffset;40;0;Create;True;0;0;0;True;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;815;2688.963,-5063.384;Inherit;True;Global;_FogOffset;_FogOffset;6;0;Create;True;0;0;0;True;0;False;-1;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;808;3539.414,-4997.954;Inherit;False;_CustomAdditionalFog;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;796;2134.484,-4246.706;Inherit;False;808;_CustomAdditionalFog;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;817;2566.111,-4182.945;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;816;2811.837,-4486.583;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;823;3019.223,-4965.981;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;824;3091.749,-5145.495;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
WireConnection;210;0;209;0
WireConnection;236;0;554;3
WireConnection;236;1;237;0
WireConnection;246;0;210;1
WireConnection;232;0;246;0
WireConnection;232;1;236;0
WireConnection;247;0;232;0
WireConnection;260;0;247;0
WireConnection;260;1;261;0
WireConnection;262;0;260;0
WireConnection;263;0;262;0
WireConnection;263;1;264;0
WireConnection;185;0;184;0
WireConnection;185;1;497;0
WireConnection;498;0;501;0
WireConnection;496;1;483;0
WireConnection;496;2;488;0
WireConnection;149;0;152;0
WireConnection;151;0;150;0
WireConnection;132;0;123;0
WireConnection;133;0;132;0
WireConnection;135;0;127;1
WireConnection;135;1;687;0
WireConnection;144;0;547;0
WireConnection;545;0;137;0
WireConnection;545;1;546;0
WireConnection;547;0;545;0
WireConnection;563;0;761;0
WireConnection;268;0;192;0
WireConnection;268;1;269;0
WireConnection;268;2;276;0
WireConnection;276;0;274;0
WireConnection;274;0;277;0
WireConnection;274;1;275;0
WireConnection;273;0;272;0
WireConnection;273;1;822;0
WireConnection;277;0;587;0
WireConnection;277;1;278;0
WireConnection;587;0;273;0
WireConnection;272;0;270;0
WireConnection;100;0;93;0
WireConnection;93;0;45;0
WireConnection;93;1;94;0
WireConnection;89;0;392;0
WireConnection;392;0;394;0
WireConnection;392;1;384;0
WireConnection;672;1;674;0
WireConnection;672;2;664;0
WireConnection;654;0;640;0
WireConnection;654;1;656;0
WireConnection;656;0;643;0
WireConnection;152;0;151;1
WireConnection;609;0;606;0
WireConnection;609;1;616;0
WireConnection;574;0;575;0
WireConnection;579;0;580;0
WireConnection;579;2;566;0
WireConnection;579;3;145;0
WireConnection;577;0;579;0
WireConnection;578;0;577;0
WireConnection;575;0;578;0
WireConnection;566;0;145;0
WireConnection;566;1;145;0
WireConnection;145;0;144;0
WireConnection;145;1;153;0
WireConnection;126;0;116;0
WireConnection;126;1;154;2
WireConnection;127;0;126;0
WireConnection;124;0;129;0
WireConnection;124;1;123;0
WireConnection;128;0;127;1
WireConnection;128;1;122;0
WireConnection;129;0;128;0
WireConnection;129;1;592;0
WireConnection;147;0;134;0
WireConnection;148;0;146;0
WireConnection;148;1;149;0
WireConnection;146;0;147;0
WireConnection;153;0;124;0
WireConnection;153;1;148;0
WireConnection;134;0;133;0
WireConnection;134;1;135;0
WireConnection;123;0;122;0
WireConnection;611;0;788;0
WireConnection;613;0;611;0
WireConnection;615;0;613;0
WireConnection;122;0;121;2
WireConnection;122;1;592;0
WireConnection;156;0;537;0
WireConnection;688;0;319;0
WireConnection;688;1;609;0
WireConnection;694;0;695;0
WireConnection;694;2;678;0
WireConnection;630;0;691;0
WireConnection;630;1;631;0
WireConnection;691;0;693;0
WireConnection;691;2;678;0
WireConnection;353;0;630;0
WireConnection;685;0;684;0
WireConnection;684;0;694;0
WireConnection;684;1;686;0
WireConnection;518;0;519;0
WireConnection;518;2;704;0
WireConnection;248;0;263;0
WireConnection;704;1;248;0
WireConnection;704;2;258;0
WireConnection;207;0;524;0
WireConnection;427;0;426;0
WireConnection;380;0;427;0
WireConnection;381;0;380;0
WireConnection;381;1;380;1
WireConnection;385;0;420;0
WireConnection;385;1;381;0
WireConnection;389;0;385;0
WireConnection;389;1;739;0
WireConnection;384;0;391;0
WireConnection;384;1;391;1
WireConnection;384;2;391;2
WireConnection;391;0;389;0
WireConnection;194;0;185;0
WireConnection;194;1;438;0
WireConnection;194;2;769;0
WireConnection;206;0;741;0
WireConnection;206;2;518;0
WireConnection;761;0;760;0
WireConnection;761;3;525;0
WireConnection;302;0;589;0
WireConnection;474;0;467;0
WireConnection;467;0;502;0
WireConnection;467;1;450;0
WireConnection;502;0;787;0
WireConnection;502;1;820;0
WireConnection;702;0;512;0
WireConnection;702;1;513;0
WireConnection;702;2;604;0
WireConnection;480;0;479;3
WireConnection;480;1;702;0
WireConnection;479;0;478;0
WireConnection;240;0;480;0
WireConnection;505;0;240;0
WireConnection;505;1;506;0
WireConnection;770;0;777;0
WireConnection;497;0;498;0
WireConnection;497;2;187;0
WireConnection;639;0;688;0
WireConnection;639;1;654;0
WireConnection;628;1;605;0
WireConnection;628;2;650;0
WireConnection;674;1;628;0
WireConnection;674;2;675;0
WireConnection;664;0;663;0
WireConnection;663;0;662;0
WireConnection;662;0;668;0
WireConnection;668;0;696;0
WireConnection;668;1;669;0
WireConnection;696;0;743;0
WireConnection;696;1;652;0
WireConnection;605;0;639;0
WireConnection;110;0;106;0
WireConnection;110;1;111;2
WireConnection;107;0;103;0
WireConnection;106;0;104;0
WireConnection;106;2;107;0
WireConnection;106;3;108;0
WireConnection;169;0;472;0
WireConnection;169;1;168;3
WireConnection;441;0;169;0
WireConnection;441;1;168;4
WireConnection;453;0;436;0
WireConnection;162;0;110;0
WireConnection;162;1;163;0
WireConnection;472;0;162;0
WireConnection;173;0;472;0
WireConnection;173;1;168;1
WireConnection;174;0;173;0
WireConnection;174;1;173;0
WireConnection;175;0;174;0
WireConnection;569;0;168;0
WireConnection;170;0;472;0
WireConnection;170;1;168;2
WireConnection;171;0;170;0
WireConnection;108;0;740;0
WireConnection;108;1;109;3
WireConnection;470;0;742;0
WireConnection;470;3;453;0
WireConnection;436;0;433;0
WireConnection;436;2;176;0
WireConnection;436;3;172;0
WireConnection;436;4;441;0
WireConnection;698;0;470;0
WireConnection;96;0;521;0
WireConnection;776;0;194;0
WireConnection;792;0;809;0
WireConnection;737;0;801;0
WireConnection;738;0;802;0
WireConnection;799;0;825;0
WireConnection;765;0;767;0
WireConnection;765;3;799;0
WireConnection;767;0;766;0
WireConnection;591;0;117;0
WireConnection;775;0;765;0
WireConnection;764;0;770;0
WireConnection;772;0;777;4
WireConnection;528;0;563;0
WireConnection;501;0;496;0
WireConnection;801;0;803;0
WireConnection;802;0;803;0
WireConnection;473;1;474;0
WireConnection;446;1;1;0
WireConnection;446;0;473;0
WireConnection;191;0;446;0
WireConnection;589;1;590;0
WireConnection;589;0;268;0
WireConnection;43;0;40;0
WireConnection;521;1;522;0
WireConnection;521;0;698;0
WireConnection;172;0;171;0
WireConnection;176;0;175;0
WireConnection;524;1;523;0
WireConnection;524;0;206;0
WireConnection;537;1;538;0
WireConnection;537;0;574;0
WireConnection;678;1;679;0
WireConnection;678;0;672;0
WireConnection;514;0;505;0
WireConnection;820;0;503;0
WireConnection;553;0;739;0
WireConnection;553;1;556;0
WireConnection;826;0;796;0
WireConnection;825;0;816;0
WireConnection;825;1;826;0
WireConnection;809;1;610;0
WireConnection;809;0;793;1
WireConnection;814;1;824;0
WireConnection;814;0;823;0
WireConnection;808;0;814;0
WireConnection;817;0;826;1
WireConnection;816;0;773;0
WireConnection;816;1;817;0
WireConnection;823;0;815;1
WireConnection;823;1;815;2
ASEEND*/
//CHKSM=E9048B8F0776FF5A8E769B4BEF947D031D76C2E5