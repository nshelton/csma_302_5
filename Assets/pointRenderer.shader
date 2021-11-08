Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _Color("MainColor", Color) = (1, 0, 0, 1)
        _SecColor("SecColor", Color) = (1, 0, 0, 1)
        _Tex("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        Blend One One
        LOD 100

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
            fixed4 _SecColor;
            float _MaxAge;

            v2f vert (uint vertex_id : SV_VertexID, uint instance_id : SV_InstanceID)
            {
                v2f output = (v2f)0;

                float3 pos = _Particles[instance_id].position;

                output.vertex = UnityObjectToClipPos(float4(pos, 1));
                output.color = lerp(_Color, _SecColor, _Particles[instance_id].life / _MaxAge);

                return output;
            }
            
            sampler2D _Tex;

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_Tex, i.vertex/500);
                return col;
            }
            ENDCG
        }
    }
}
