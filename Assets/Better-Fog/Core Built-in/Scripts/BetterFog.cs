using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using System.Collections.Generic;
using INab.BetterFog.Core;

namespace INab.BetterFog.BIRP
{
	#region PostProcessingStackParameters

	[Serializable]
	public sealed class FogParameter : ParameterOverride<FogMode> { }

	[Serializable]
	public sealed class HeightFogParameter : ParameterOverride<HeightFogType> { }

	[Serializable]
	public sealed class NoiseAffectParameter : ParameterOverride<NoiseAffect> { }

	[Serializable]
	public sealed class LightParameter : ParameterOverride<GameObject> { }
	#endregion

	[Serializable]
	[PostProcess(typeof(BetterFogRenderer), PostProcessEvent.BeforeStack, "BetterFog", true)]
	public sealed class BetterFog : PostProcessEffectSettings
	{

		#region Settings
		public BoolParameter _UseCustomDepthTexture = new BoolParameter { value = false };
		public BoolParameter _UseFogOffsetTexture = new BoolParameter { value = false };
		//public LightParameter _DirectionalLight = new LightParameter { value = null };
		#endregion

		#region FogParameters

		[Range(0, 1)]
		public FloatParameter _FogIntensity = new FloatParameter { value = 1 };

		[Range(0, 1)]
		public FloatParameter _EnergyLoss = new FloatParameter { value = 0 };

		public BoolParameter _UseGradient = new BoolParameter { value = false };
		public ColorParameter _FogColor = new ColorParameter { value = new Color(.8f, .8f, .8f, 1f) };
		public FloatParameter _GradientStart = new FloatParameter { value = 0 };
		public FloatParameter _GradientEnd = new FloatParameter { value = 100 };
		public TextureParameter _GradientTexture = new TextureParameter { value = null };

		public BoolParameter _UseSunLight = new BoolParameter { value = false };
		public ColorParameter _SunColor = new ColorParameter { value = new Color(.9f, .85f, .8f, 1f) };
		[Range(0, 1)]
		public FloatParameter _SunIntensity = new FloatParameter { value = .5f };
		[Range(.1f, 12)]
		public FloatParameter _SunPower = new FloatParameter { value = 2 };

		public BoolParameter _UseDistanceFog = new BoolParameter { value = true };
		public BoolParameter _UseRadialDistance = new BoolParameter { value = false };
		public FogParameter _FogType = new FogParameter { value = FogMode.ExponentialSquared };
		public FloatParameter _DistanceFogOffset = new FloatParameter { value = -20 };

		public FloatParameter _SceneStart = new FloatParameter { value = 10 };
		public FloatParameter _SceneEnd = new FloatParameter { value = 100 };

		[Range(0, .1f)]
		public FloatParameter _FogDensity = new FloatParameter { value = 0.001f };

		public BoolParameter _UseSkyboxHeightFog = new BoolParameter { value = false };
		[Range(-.1f, .1f)]
		public FloatParameter _SkyboxFogOffset = new FloatParameter { value = 0 };
		[Range(0, .999f)]
		public FloatParameter _SkyboxFogHardness = new FloatParameter { value = 0 };
		[Range(0, 1)]
		public FloatParameter _SkyboxFogIntensity = new FloatParameter { value = 1 };
		[Range(0, 1)]
		public FloatParameter _SkyboxFill = new FloatParameter { value = 0 };

		public BoolParameter _UseHeightFog = new BoolParameter { value = false };
		public FloatParameter _Height = new FloatParameter { value = 4f };
		[Range(0, .5f)]
		public FloatParameter _HeightDensity = new FloatParameter { value = 0.35f };

		public HeightFogParameter _HeightFogType = new HeightFogParameter { value = HeightFogType.ExponentialSquared };

		public BoolParameter _UseNoise = new BoolParameter { value = false };
		public NoiseAffectParameter _NoiseAffect = new NoiseAffectParameter { value = NoiseAffect.Both };
		[Range(0, 1)]
		public FloatParameter _NoiseIntensity = new FloatParameter { value = 1 };
		public FloatParameter _NoiseDistanceEnd = new FloatParameter { value = 80 };
		[Range(1, 16)]
		public FloatParameter _NoiseEndHardness = new FloatParameter { value = 0.35f };


		[Range(5, 140)]
		public FloatParameter _Scale1 = new FloatParameter { value = 40 };
		[Range(0, 1)]
		public FloatParameter _Lerp1 = new FloatParameter { value = .5f };
		public Vector3Parameter _NoiseSpeed1 = new Vector3Parameter { value = new Vector3(0, 0, 0) };
		[Range(0, .5f)]
		public FloatParameter _NoiseTimeScale1 = new FloatParameter { value = .1f };

		#endregion

		#region SSMSParameters
		public BoolParameter _UseSSMS = new BoolParameter { value = false };
		[Range(-1, 1)]
		public FloatParameter _Threshold = new FloatParameter { value = 0 };
		public FloatParameter _SoftKnee = new FloatParameter { value = .5f };
		[Range(1, 7)]
		public FloatParameter _Radius = new FloatParameter { value = 7 };
		[Range(.1f, 100)]
		public FloatParameter _BlurWeight = new FloatParameter { value = 1 };
		[Range(0, 1)]
		public FloatParameter _Intensity = new FloatParameter { value = 1 };
		public BoolParameter _HighQuality = new BoolParameter { value = false };
		public BoolParameter _AntiFlicker = new BoolParameter { value = false };
		public TextureParameter _FadeRamp = new TextureParameter { value = null };

		#endregion
	}

	public sealed class BetterFogRenderer : PostProcessEffectRenderer<BetterFog>
	{
		const int kMaxIterations = 16;
		int[] _blurBuffer1 = new int[kMaxIterations];
		int[] _blurBuffer2 = new int[kMaxIterations];

		private BetterFogRenderers betterFogRenderers;

		public override void Init()
		{
			for (int i = 0; i < kMaxIterations; i++)
			{
				_blurBuffer1[i] = Shader.PropertyToID("_MipDown" + i);
				_blurBuffer2[i] = Shader.PropertyToID("_MipUp" + i);
			}
		}

		private void DrawRenderers(List<CustomRenderer> list, UnityEngine.Rendering.CommandBuffer cmd)
		{
			if (betterFogRenderers)
			{
				foreach (var customRenderer in list)
				{
					if (customRenderer.render == false) continue;

					var material = customRenderer.material;

					var renderer = customRenderer.renderer;

					if (renderer == false || material == false) continue;

					if (!customRenderer.alwaysRender)
					{
						if (renderer.enabled == false || renderer.gameObject.activeInHierarchy == false) continue;
					}

					if (customRenderer.drawAllSubmeshes && renderer is not ParticleSystemRenderer)
					{
						Mesh mesh = null;
						if (renderer is SkinnedMeshRenderer)
							mesh = (renderer as SkinnedMeshRenderer).sharedMesh;
						else if (renderer is MeshRenderer)
							mesh = renderer.GetComponent<MeshFilter>().sharedMesh;

						for (int i = 0; i < mesh.subMeshCount; i++)
						{
							cmd.DrawRenderer(renderer, material, i, 0);
						}
					}
					else
					{
						cmd.DrawRenderer(renderer, material, 0, 0);
					}
				}
			}
		}

		public override void Render(PostProcessRenderContext context)
		{
			var cmd = context.command;
			cmd.BeginSample("Better Fog");

			// Fog Post Process
			var sheet = context.propertySheets.Get(Shader.Find("Hidden/INabStudio/BetterFog"));
			var sheetOnlyDepth = context.propertySheets.Get(Shader.Find("Hidden/INabStudio/OnlyDepth"));

			#region Keywords

			sheet.ClearKeywords();

			if (settings._UseSunLight.value)
			{
				sheet.EnableKeyword("_USESUNLIGHT_ON");
			}
			if (settings._UseGradient.value)
			{
				sheet.EnableKeyword("_USEGRADIENT_ON");
			}

			if (settings._UseDistanceFog.value)
			{
				sheet.EnableKeyword("_USEDISTANCEFOG_ON");
			}

			if (settings._UseSkyboxHeightFog.value)
			{
				sheet.EnableKeyword("_USESKYBOXHEIGHTFOG_ON");
			}

			if (settings._UseHeightFog.value)
			{
				sheet.EnableKeyword("_USEHEIGHTFOG_ON");
			}

			if (settings._UseNoise.value)
			{
				sheet.EnableKeyword("_USENOISE_ON");
			}

			#endregion

			#region UserProperties

			sheet.properties.SetColor("_SunColor", settings._SunColor);
			sheet.properties.SetFloat("_SunPower", settings._SunPower);
			sheet.properties.SetFloat("_SunIntensity", settings._SunIntensity);

			sheet.properties.SetColor("_FogColor", settings._FogColor);

			sheet.properties.SetFloat("_GradientStart", settings._GradientStart);
			sheet.properties.SetFloat("_GradientEnd", settings._GradientEnd);

			var gradientTexture = settings._GradientTexture.value == null ? RuntimeUtilities.whiteTexture : settings._GradientTexture.value;
			sheet.properties.SetTexture("_GradientTexture", gradientTexture);
			sheet.properties.SetFloat("_EnergyLoss", settings._EnergyLoss);

			sheet.properties.SetFloat("_FogIntensity", settings._FogIntensity);
			sheet.properties.SetFloat("_UseRadialDistance", settings._UseRadialDistance ? 1 : 0);

			switch (settings._FogType.value)
			{
				case FogMode.Linear:
					sheet.properties.SetInt("_FogType", 1);
					break;
				case FogMode.Exponential:
					sheet.properties.SetInt("_FogType", 2);
					break;
				case FogMode.ExponentialSquared:
					sheet.properties.SetInt("_FogType", 3);
					break;
			}

			sheet.properties.SetFloat("_DistanceFogOffset", settings._DistanceFogOffset);

			sheet.properties.SetFloat("_SkyboxFogIntensity", settings._SkyboxFogIntensity);
			sheet.properties.SetFloat("_SkyboxFogHardness", settings._SkyboxFogHardness);
			sheet.properties.SetFloat("_SkyboxFogOffset", settings._SkyboxFogOffset);
			sheet.properties.SetFloat("_SkyboxFill", settings._SkyboxFill);

			sheet.properties.SetFloat("_HeightDensity", Mathf.Pow(settings._HeightDensity, 4));
			sheet.properties.SetFloat("_Height", settings._Height);
			sheet.properties.SetInt("_HeightFogType", ((int)settings._HeightFogType.value));

			sheet.properties.SetFloat("_Scale1", settings._Scale1);
			sheet.properties.SetFloat("_NoiseTimeScale1", settings._NoiseTimeScale1);
			sheet.properties.SetFloat("_Lerp1", settings._Lerp1);
			sheet.properties.SetFloat("_NoiseDistanceEnd", settings._NoiseDistanceEnd);
			sheet.properties.SetFloat("_NoiseIntensity", settings._NoiseIntensity);
			sheet.properties.SetFloat("_NoiseEndHardness", settings._NoiseEndHardness);

			sheet.properties.SetVector("_NoiseSpeed1", settings._NoiseSpeed1);

			int useNoiseDistance = 0;
			int useNoiseHeight = 0;

			switch (settings._NoiseAffect.value)
			{
				case NoiseAffect.DistanceOnly:
					useNoiseDistance = 1;
					useNoiseHeight = 0;

					break;
				case NoiseAffect.HeightOnly:
					useNoiseDistance = 0;
					useNoiseHeight = 1;
					break;
				case NoiseAffect.Both:
					useNoiseDistance = 1;
					useNoiseHeight = 1;
					break;
			}

			if (settings._UseDistanceFog.value == false)
				useNoiseDistance = 0;

			if (settings._UseHeightFog.value == false)
				useNoiseHeight = 0;

			sheet.properties.SetInt("_UseNoiseDistance", useNoiseDistance);
			sheet.properties.SetInt("_UseNoiseHeight", useNoiseHeight);

			#endregion

			#region OtherProperties

			// Distance Fog Values
			Vector4 sceneParams;
			float diff = settings._SceneEnd - settings._SceneStart;
			float invDiff = Mathf.Abs(diff) > 0.0001f ? 1.0f / diff : 0.0f;
			sceneParams.x = settings._FogDensity * 1.2011224087f; // density / sqrt(ln(2)), used by Exp2 fog mode
			sceneParams.y = settings._FogDensity * 1.4426950408f; // density / ln(2), used by Exp fog mode
			sceneParams.z = -invDiff;
			sceneParams.w = settings._SceneEnd * invDiff;
			sheet.properties.SetVector("_SceneFogParams", sceneParams);

			// Sun Direction
			//sheet.properties.SetVector("SunDirection", -RenderSettings.sun.gameObject.transform.forward);
			//var sunDir = settings._DirectionalLight != null ? new Vector3(0, 0, 0) : -settings._DirectionalLight.value.gameObject.transform.forward;
			
			//sheet.properties.SetVector("SunDirection", sunDir);

			sheet.properties.SetMatrix("_InverseView", context.camera.cameraToWorldMatrix);

			#endregion

			// Use ARGBHalf since DefaultHDR sometimes breaks 
			var rtFormat = RenderTextureFormat.ARGBHalf;
			var rtReadWrite = RenderTextureReadWrite.Default;
			var rtFilterMode = FilterMode.Bilinear;

			int fogFactorRT = Shader.PropertyToID("fogFactorID");
			context.GetScreenSpaceTemporaryRT(cmd, fogFactorRT, 0, rtFormat, rtReadWrite, rtFilterMode, context.width, context.height);

			var camera = context.camera;
			betterFogRenderers = camera.gameObject.GetComponent<BetterFogRenderers>();

			// Only Depth RT
			int onlyDepthRT = Shader.PropertyToID("onlyDepthID");

			if (settings._UseCustomDepthTexture)
			{
				sheet.EnableKeyword("_USECUSTOMDEPTH_ON");

				// depthBufferBits need to be 16 or more for depth testing
				context.GetScreenSpaceTemporaryRT(cmd, onlyDepthRT, 32, RenderTextureFormat.RFloat, rtReadWrite, FilterMode.Point, context.width, context.height);

				cmd.BlitFullscreenTriangle(context.source, onlyDepthRT, sheetOnlyDepth, 0);
				cmd.SetRenderTarget(onlyDepthRT);

				// we need this to avoid depth testing glitches
				cmd.ClearRenderTarget(true, false, Color.black);

				DrawRenderers(betterFogRenderers.depthRenderers, cmd);

				cmd.SetGlobalTexture("_CustomDepth", onlyDepthRT);
			}
			// End of Only Depth RT

			// Fog Offset RT
			int fogOffsetRT = Shader.PropertyToID("fogOffsetID");

			if (settings._UseFogOffsetTexture)
			{
				sheet.EnableKeyword("_USEFOGOFFSET_ON");

				// depthBufferBits need to be 16 or more for depth testing
				context.GetScreenSpaceTemporaryRT(cmd, fogOffsetRT, 32, RenderTextureFormat.RGHalf, rtReadWrite, FilterMode.Point, context.width, context.height);

				//cmd.BlitFullscreenTriangle(context.source, fogOffsetRT, sheetOnlyDepth, 0);
				cmd.SetRenderTarget(fogOffsetRT);

				// we need this to avoid depth testing glitches
				cmd.ClearRenderTarget(true, true, Color.black);

				DrawRenderers(betterFogRenderers.fogOffsetRenderers, cmd);

				cmd.SetGlobalTexture("_FogOffset", fogOffsetRT);
			}
			// End of Fog Offset RT

			// Fog post process blit
			if (!settings._UseSSMS)
			{
				// Fog blit to FogFactorRT
				cmd.BlitFullscreenTriangle(context.source, fogFactorRT, sheet, 0);
				cmd.SetGlobalTexture("_FogFactor_RT", fogFactorRT);

				// Camera fog blit
				cmd.BlitFullscreenTriangle(context.source, context.destination, sheet, 1);
			}

			if (settings._UseSSMS)
			{
				int temporaryRT = Shader.PropertyToID("temporaryRT");
				context.GetScreenSpaceTemporaryRT(cmd, temporaryRT, 0, rtFormat, rtReadWrite, rtFilterMode, context.width, context.height);

				// Fog blit to FogFactorRT
				cmd.BlitFullscreenTriangle(context.source, fogFactorRT, sheet, 0);
				cmd.SetGlobalTexture("_FogFactor_RT", fogFactorRT);

				// Camera fog blit to temporaryRT
				cmd.BlitFullscreenTriangle(context.source, temporaryRT, sheet, 1);


				// SSMS sheet
				var sheetSSMS = context.propertySheets.Get(Shader.Find("Hidden/INabStudio/SSMS"));

				// source texture size
				var tw = context.width;
				var th = context.height;

				// Do fog on a half resolution, full resolution doesn't bring much
				tw /= 2;
				th /= 2;

				// determine the iteration count
				var logh = Mathf.Log(th, 2) + settings._Radius - 8;
				var logh_i = (int)logh;
				var iterations = Mathf.Clamp(logh_i, 1, kMaxIterations);

				// update the shader properties
				var lthresh = settings._Threshold;
				sheetSSMS.properties.SetFloat("_Threshold", lthresh);

				var knee = lthresh * settings._SoftKnee + 1e-5f;
				var curve = new Vector3(lthresh - knee, knee * 2, 0.25f / knee);
				sheetSSMS.properties.SetVector("_Curve", curve);

				var pfo = !settings._HighQuality && settings._AntiFlicker;
				sheetSSMS.properties.SetFloat("_PrefilterOffs", pfo ? -0.5f : 0.0f);

				sheetSSMS.properties.SetFloat("_SampleScale", 0.5f + logh - logh_i);
				sheetSSMS.properties.SetFloat("_Intensity", settings._Intensity);

				var fadeRampTexture = settings._FadeRamp.value == null ? RuntimeUtilities.whiteTexture : settings._FadeRamp.value;
				sheetSSMS.properties.SetTexture("_FadeTex", fadeRampTexture);
				sheetSSMS.properties.SetFloat("_BlurWeight", settings._BlurWeight);
				sheetSSMS.properties.SetFloat("_Radius", settings._Radius);

				sheetSSMS.ClearKeywords();

				if (settings._AntiFlicker.value)
				{
					sheetSSMS.EnableKeyword("ANTI_FLICKER_ON");
				}

				if (settings._HighQuality.value)
				{
					sheetSSMS.EnableKeyword("_HIGH_QUALITY_ON");
				}

				// prefilter pass
				int prefilteredRT = Shader.PropertyToID("prefilteredRT");
				context.GetScreenSpaceTemporaryRT(cmd, prefilteredRT, 0, rtFormat, rtReadWrite, rtFilterMode, context.width, context.height);

				var pass = 0;
				cmd.BlitFullscreenTriangle(temporaryRT, prefilteredRT, sheetSSMS, pass);


				// construct a mip pyramid
				var last = prefilteredRT;
				for (var level = 0; level < iterations; level++)
				{
					context.GetScreenSpaceTemporaryRT(cmd, _blurBuffer1[level], 0, rtFormat, rtReadWrite, rtFilterMode, tw, th);
					context.GetScreenSpaceTemporaryRT(cmd, _blurBuffer2[level], 0, rtFormat, rtReadWrite, rtFilterMode, tw, th);

					tw = Mathf.Max(tw / 2, 1);
					th = Mathf.Max(th / 2, 1);

					pass = (level == 0) ?  1 : 2;
					cmd.SetGlobalTexture("_MainTex", last);
					cmd.BlitFullscreenTriangle(last, _blurBuffer1[level], sheetSSMS, pass);

					last = _blurBuffer1[level];
				}

				// upsample and combine loop
				for (var level = iterations - 2; level >= 0; level--)
				{
					var basetex = _blurBuffer1[level];
					cmd.SetGlobalTexture("_BaseTex", basetex);

					pass = 3;
					cmd.BlitFullscreenTriangle(last, _blurBuffer2[level], sheetSSMS, pass);
					last = _blurBuffer2[level];
				}


				// finish process
				cmd.SetGlobalTexture("_BaseTex", temporaryRT);
				pass = 4;
				cmd.BlitFullscreenTriangle(last, context.destination, sheetSSMS, pass);


				// release the temporary buffers
				for (var i = 0; i < kMaxIterations; i++)
				{
					cmd.ReleaseTemporaryRT(_blurBuffer1[i]);
					cmd.ReleaseTemporaryRT(_blurBuffer2[i]);
				}

				cmd.ReleaseTemporaryRT(prefilteredRT);
				cmd.ReleaseTemporaryRT(temporaryRT);

			}

			cmd.ReleaseTemporaryRT(fogFactorRT);

			if (settings._UseCustomDepthTexture) cmd.ReleaseTemporaryRT(onlyDepthRT);
			if (settings._UseFogOffsetTexture) cmd.ReleaseTemporaryRT(fogOffsetRT);

			cmd.EndSample("Better Fog");
		}
	}
}