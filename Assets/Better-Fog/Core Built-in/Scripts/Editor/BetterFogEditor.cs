using UnityEditor.Rendering.PostProcessing;
using UnityEngine;
using UnityEditor;
using INab.BetterFog.Core;

namespace UnityEditor.Rendering.PostProcessing
{
    
    [PostProcessEditor(typeof(INab.BetterFog.BIRP.BetterFog))]
    public class BetterFogEditor : PostProcessEffectEditor<INab.BetterFog.BIRP.BetterFog>
    {
        // Settings
        SerializedParameterOverride _UseCustomDepthTexture;
        SerializedParameterOverride _UseFogOffsetTexture;

        // FogParameters
        SerializedParameterOverride _FogIntensity;
        SerializedParameterOverride _EnergyLoss;
        SerializedParameterOverride _FogColor;
        SerializedParameterOverride _UseGradient;
        SerializedParameterOverride _GradientStart;
        SerializedParameterOverride _GradientEnd;
        SerializedParameterOverride _GradientTexture;
        SerializedParameterOverride _UseSunLight;
        SerializedParameterOverride _SunColor;
        SerializedParameterOverride _SunIntensity;
        SerializedParameterOverride _SunPower;
        SerializedParameterOverride _UseDistanceFog;
        SerializedParameterOverride _UseRadialDistance;
        SerializedParameterOverride _FogType;
        SerializedParameterOverride _DistanceFogOffset;
        SerializedParameterOverride _SceneStart;
        SerializedParameterOverride _SceneEnd;
        SerializedParameterOverride _FogDensity;
        SerializedParameterOverride _UseSkyboxHeightFog;
        SerializedParameterOverride _SkyboxFogOffset;
        SerializedParameterOverride _SkyboxFogHardness;
        SerializedParameterOverride _SkyboxFogIntensity;
        SerializedParameterOverride _SkyboxFill;
        SerializedParameterOverride _UseHeightFog;
        SerializedParameterOverride _Height;
        SerializedParameterOverride _HeightDensity;
        SerializedParameterOverride _HeightFogType;
        SerializedParameterOverride _UseNoise;
        SerializedParameterOverride _NoiseAffect;
        SerializedParameterOverride _NoiseIntensity;
        SerializedParameterOverride _NoiseDistanceEnd;
        SerializedParameterOverride _NoiseEndHardness;
        SerializedParameterOverride _Scale1;
        SerializedParameterOverride _Lerp1;
        SerializedParameterOverride _NoiseSpeed1;
        SerializedParameterOverride _NoiseTimeScale1;

        // SSMSParameters
        SerializedParameterOverride _UseSSMS;
        SerializedParameterOverride _Threshold;
        SerializedParameterOverride _SoftKnee;
        SerializedParameterOverride _Radius;
        SerializedParameterOverride _BlurWeight;
        SerializedParameterOverride _Intensity;
        SerializedParameterOverride _HighQuality;
        SerializedParameterOverride _AntiFlicker;
        SerializedParameterOverride _FadeRamp;

        public override void OnEnable()
        {
            // Settings
            _UseCustomDepthTexture = FindParameterOverride(x => x._UseCustomDepthTexture);
            _UseFogOffsetTexture = FindParameterOverride(x => x._UseFogOffsetTexture);
            
            // FogParameters
            _FogIntensity = FindParameterOverride(x => x._FogIntensity);
            _EnergyLoss = FindParameterOverride(x => x._EnergyLoss);
            _FogColor = FindParameterOverride(x => x._FogColor);
            _UseGradient = FindParameterOverride(x => x._UseGradient);
            _GradientStart = FindParameterOverride(x => x._GradientStart);
            _GradientEnd = FindParameterOverride(x => x._GradientEnd);
            _GradientTexture = FindParameterOverride(x => x._GradientTexture);
            _UseSunLight = FindParameterOverride(x => x._UseSunLight);
            _SunColor = FindParameterOverride(x => x._SunColor);
            _SunIntensity = FindParameterOverride(x => x._SunIntensity);
            _SunPower = FindParameterOverride(x => x._SunPower);
            _UseDistanceFog = FindParameterOverride(x => x._UseDistanceFog);
            _UseRadialDistance = FindParameterOverride(x => x._UseRadialDistance);
            _FogType = FindParameterOverride(x => x._FogType);
            _DistanceFogOffset = FindParameterOverride(x => x._DistanceFogOffset);
            _SceneStart = FindParameterOverride(x => x._SceneStart);
            _SceneEnd = FindParameterOverride(x => x._SceneEnd);
            _FogDensity = FindParameterOverride(x => x._FogDensity);
            _UseSkyboxHeightFog = FindParameterOverride(x => x._UseSkyboxHeightFog);
            _SkyboxFogOffset = FindParameterOverride(x => x._SkyboxFogOffset);
            _SkyboxFogHardness = FindParameterOverride(x => x._SkyboxFogHardness);
            _SkyboxFogIntensity = FindParameterOverride(x => x._SkyboxFogIntensity);
            _SkyboxFill = FindParameterOverride(x => x._SkyboxFill);
            _UseHeightFog = FindParameterOverride(x => x._UseHeightFog);
            _Height = FindParameterOverride(x => x._Height);
            _HeightDensity = FindParameterOverride(x => x._HeightDensity);
            _HeightFogType = FindParameterOverride(x => x._HeightFogType);
            _UseNoise = FindParameterOverride(x => x._UseNoise);
            _NoiseAffect = FindParameterOverride(x => x._NoiseAffect);
            _NoiseIntensity = FindParameterOverride(x => x._NoiseIntensity);
            _NoiseDistanceEnd = FindParameterOverride(x => x._NoiseDistanceEnd);
            _NoiseEndHardness = FindParameterOverride(x => x._NoiseEndHardness);
            _Scale1 = FindParameterOverride(x => x._Scale1);
            _Lerp1 = FindParameterOverride(x => x._Lerp1);
            _NoiseSpeed1 = FindParameterOverride(x => x._NoiseSpeed1);
            _NoiseTimeScale1 = FindParameterOverride(x => x._NoiseTimeScale1);

            // SSMSParameters
            _UseSSMS = FindParameterOverride(x => x._UseSSMS);
            _Threshold = FindParameterOverride(x => x._Threshold);
            _SoftKnee = FindParameterOverride(x => x._SoftKnee);
            _Radius = FindParameterOverride(x => x._Radius);
            _BlurWeight = FindParameterOverride(x => x._BlurWeight);
            _Intensity = FindParameterOverride(x => x._Intensity);
            _HighQuality = FindParameterOverride(x => x._HighQuality);
            _AntiFlicker = FindParameterOverride(x => x._AntiFlicker);
            _FadeRamp = FindParameterOverride(x => x._FadeRamp);
        }

        public override void OnInspectorGUI()
        {
            EditorGUILayout.LabelField("Custom Textures", BetterFogUtility.centeredBoldLabel);
            using (new EditorGUILayout.VerticalScope(EditorStyles.helpBox))
            {
                PropertyField(_UseCustomDepthTexture);
                PropertyField(_UseFogOffsetTexture); 
                EditorGUILayout.Space();
            }
            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Main", BetterFogUtility.centeredBoldLabel);
            using (new EditorGUILayout.VerticalScope(EditorStyles.helpBox))
            {
                PropertyField(_FogIntensity);
                PropertyField(_EnergyLoss);
                EditorGUILayout.Space();
            }
            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Colors", BetterFogUtility.centeredBoldLabel);
            using (new EditorGUILayout.VerticalScope(EditorStyles.helpBox))
            {
                PropertyField(_UseGradient);

                if (_UseGradient.value.boolValue)
                {
                    PropertyField(_GradientStart);
                    PropertyField(_GradientEnd);
                    PropertyField(_GradientTexture);
                }
                else
                {
                    PropertyField(_FogColor);
                }
                EditorGUILayout.Space();
            }
            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Sun Light", BetterFogUtility.centeredBoldLabel);
            using (new EditorGUILayout.VerticalScope(EditorStyles.helpBox))
            {
                PropertyField(_UseSunLight);

                if (_UseSunLight.value.boolValue)
                {
                    PropertyField(_SunColor);
                    PropertyField(_SunIntensity);
                    PropertyField(_SunPower);
                }
                EditorGUILayout.Space();
            }
            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Distance Fog", BetterFogUtility.centeredBoldLabel);
            using (new EditorGUILayout.VerticalScope(EditorStyles.helpBox))
            {
                PropertyField(_UseDistanceFog);

                if (_UseDistanceFog.value.boolValue)
                {
                    PropertyField(_UseRadialDistance);
                    PropertyField(_DistanceFogOffset);
                    PropertyField(_FogType);

                    if (_FogType.value.enumValueIndex == 0)
                    {
                        PropertyField(_SceneStart);
                        PropertyField(_SceneEnd);
                    }
                    else
                    {
                        PropertyField(_FogDensity);
                    }

                }
                EditorGUILayout.Space();
            }

            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Skybox Height Fog", BetterFogUtility.centeredBoldLabel);
            using (new EditorGUILayout.VerticalScope(EditorStyles.helpBox))
            {
                PropertyField(_UseSkyboxHeightFog);

                if (_UseSkyboxHeightFog.value.boolValue)
                {
                    PropertyField(_SkyboxFogOffset);
                    PropertyField(_SkyboxFogHardness);
                    PropertyField(_SkyboxFogIntensity);
                    PropertyField(_SkyboxFill);
                }
                EditorGUILayout.Space();
            }

            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Height Fog", BetterFogUtility.centeredBoldLabel);
            using (new EditorGUILayout.VerticalScope(EditorStyles.helpBox))
            {
                PropertyField(_UseHeightFog);

                if (_UseHeightFog.value.boolValue)
                {
                    PropertyField(_Height);
                    PropertyField(_HeightDensity);
                    PropertyField(_HeightFogType);
                }
                EditorGUILayout.Space();
            }

            EditorGUILayout.Space();

            EditorGUILayout.LabelField("3D Noise", BetterFogUtility.centeredBoldLabel);
            using (new EditorGUILayout.VerticalScope(EditorStyles.helpBox))
            {
                PropertyField(_UseNoise);


                if (_UseNoise.value.boolValue)
                {
                    PropertyField(_NoiseAffect);
                    PropertyField(_NoiseIntensity);
                    PropertyField(_NoiseDistanceEnd);
                    PropertyField(_NoiseEndHardness);
                    PropertyField(_Scale1);
                    PropertyField(_Lerp1);
                    PropertyField(_NoiseSpeed1);
                    PropertyField(_NoiseTimeScale1);

                }
                EditorGUILayout.Space();
            }

            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Screen Space Multiple Scattering", BetterFogUtility.centeredBoldLabel);
            using (new EditorGUILayout.VerticalScope(EditorStyles.helpBox))
            {
                // SSMSParameters
                PropertyField(_UseSSMS);

                if (!_UseSSMS.value.boolValue)
                {
                    //EditorGUILayout.Space();
                    //EditorGUILayout.HelpBox("SSMS is ", MessageType.Info);
                    //EditorGUILayout.Space();
                }
                else
                {
                    PropertyField(_Threshold);
                    PropertyField(_SoftKnee);
                    PropertyField(_Radius);
                    PropertyField(_BlurWeight);
                    PropertyField(_Intensity);
                    PropertyField(_HighQuality);
                    PropertyField(_AntiFlicker);
                    PropertyField(_FadeRamp);
                }
                EditorGUILayout.Space();
            }
        }
    }
}