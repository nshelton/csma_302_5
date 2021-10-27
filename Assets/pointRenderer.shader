Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"= "Transparent" }
        LOD 100
        Blend One One   // additive blending

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

            fixed4 _Color;

            v2f vert (uint vertex_id : SV_VertexID, uint instance_id : SV_InstanceID)
            {
                v2f output = (v2f)0;

                float3 pos = _Particles[instance_id].position;

                output.vertex = UnityObjectToClipPos(float4(pos, 1));

                return output;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = _Color;
                return col;
            }
            ENDCG
        }
    }
}
