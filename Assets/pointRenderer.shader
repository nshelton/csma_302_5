Shader "Unlit/NewUnlitShader"
{
    Properties
    {

        _brightness("brightness", float) = 0
        _color("color", Color) = (.25, .5, .5, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        // additive blending
        Blend One One

        // disable blackface bulling
        Cull Off

        // don't write to the depth buffer
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #pragma target 5.0


            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            struct Particle {
                float3 position;
                float3 velocity;
                float life;
            };

            StructuredBuffer<Particle> _Particles;

            v2f vert (uint vertex_id : SV_VertexID, uint instance_id : SV_InstanceID)
            {
                v2f output = (v2f)0;

                float3 pos = _Particles[instance_id].position;

                output.vertex = UnityObjectToClipPos(float4(pos, 1));

                return output;
            }

            float4 _color;
            float _brightness;


            fixed4 frag(v2f i) : SV_Target
            {
                //col = _brightness * _color;

                //fixed4 col = fixed4(0.3, 0.5, 0.9, 1.0);

                fixed4 col = _color;
                 col *= _brightness;
                return col;
            }
            ENDCG
        }
    }
}
