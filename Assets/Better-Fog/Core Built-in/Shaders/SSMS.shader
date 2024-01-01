
Shader "Hidden/INabStudio/SSMS"
{
    SubShader
    {
        ZTest Always Cull Off ZWrite Off

        HLSLINCLUDE
        #include "SSMS.hlsl"
        ENDHLSL

        // 0: Prefilter
        Pass
        {
            HLSLPROGRAM
            #pragma vertex VertDefault
            #pragma fragment frag_prefilter
            ENDHLSL
        }

        // 2: First level downsampler
        Pass
        {
            HLSLPROGRAM
            #pragma vertex VertDefault
            #pragma fragment frag_downsample1
            ENDHLSL
        }
        
        // 4: Second level downsampler
        Pass
        {
            HLSLPROGRAM
            #pragma vertex VertDefault
            #pragma fragment frag_downsample2
            ENDHLSL
        }
        // 5: Upsampler
        Pass
        {
            HLSLPROGRAM
            #pragma vertex VertDefault
            #pragma fragment frag_upsample
            ENDHLSL
        }
        
        // 7: Combiner
        Pass
        {
            HLSLPROGRAM
            #pragma vertex VertDefault
            #pragma fragment frag_upsample_final
            ENDHLSL
        }
        
    }
}
