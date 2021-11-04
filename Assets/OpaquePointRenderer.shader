Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _color0("color0", Color) = (0.5, 0.5, 0.5)
        _color1("color1", Color) = (0.5, 0.5, 0.5)
        _scale("scale", Range (0.01, 1)) = 0.01
        _MainTex("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom

            #include "UnityCG.cginc"

            #pragma target 5.0


            struct v2g
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            struct g2f
            {
                float4 vertex : SV_Position;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct Particle
            {
                float3 position;
                float3 velocity;
                float life;
            };

            StructuredBuffer<Particle> _Particles;
            float _maxAge;
            float4 _Color0;
            float4 _Color1;

            v2g vert(uint vertex_id : SV_VertexID, uint instance_id : SV_InstanceID)
            {
                v2g output = (v2g)0;
                output.vertex = float4(_Particles[instance_id].position, 1.0);

                output.color = lerp(_Color0, _Color1, _Particles[instance_id].life / _maxAge);
                return output;
            }

            float _scale;
            sampler2D _MainTex;

            [maxvertexcount(6)]
            void geom(point v2g input[1], inout TriangleStream<g2f> triStream)
            {

                float aspect = _ScreenParams.y / _ScreenParams.x;

                g2f o;
                o.color = input[0].color;

                float4 vert = UnityObjectToClipPos(input[0].vertex);
                float4 A = vert - float4(-1 * aspect, -1, 0, 0) * _scale;
                float4 B = vert - float4(1 * aspect, -1, 0, 0) * _scale;

                float4 C = vert - float4(1 * aspect, 1, 0, 0) * _scale;
                float4 D = vert - float4(-1 * aspect, 1, 0, 0) * _scale;

                //[A, C, B]
                o.vertex = A;
                o.uv = float2(1, 0);
                triStream.Append(o);

                o.vertex = C;
                o.uv = float2(0, 1);
                triStream.Append(o);

                o.vertex = B;
                o.uv = float2(0, 0);
                triStream.Append(o);

                //[A, D, C]
                o.vertex = A;
                o.uv = float2(1, 0);
                triStream.Append(o);

                o.vertex = D;
                o.uv = float2(1, 1);
                triStream.Append(o);

                o.vertex = C;
                o.uv = float2(0, 1);
                triStream.Append(o);

                triStream.RestartStrip();
            }

            fixed4 frag(g2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv) * i.color;

                fixed4 col = fixed4(1, 0, 0, 1);

                //clip(Luminance(col) - 0.1);

                return col;
            }
            ENDCG
        }
    }
}