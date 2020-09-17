uniform float radius = 0.0;
uniform float angle = 180.0;
uniform float period = 0.5;
uniform float amplitude = 1.0;

uniform float center_x = 0.25;
uniform float center_y = 0.25;

uniform float phase = 1.0;
uniform int animate = 0;


float4 mainImage(VertData v_in) : TARGET
{
    float2 center = float2(center_x, center_y);
	VertData v_out;
    v_out.pos = v_in.pos;
    float2 hw = uv_size;
    const float ar = 1.0 * (float)hw.x/(float)hw.y;
    v_out.uv = v_in.uv * uv_scale  + uv_offset  - center;


    float dist = distance(v_out.uv, center);
    if (dist < radius)
    {
        float percent = (radius-dist)/radius;
        float theta = percent * percent * 
        (
            animate == 1 ? 
                amplitude * sin(elapsed_time) : 
                amplitude
        ) 
        * sin(percent * percent / period * radians(angle) + (phase + 
        (
            animate == 2 ? 
            elapsed_time : 
            0
        )));

        float s =  sin(theta);
        float c = cos(theta);
        v_out.uv = float2(dot(v_out.uv-center, float2(c,-s)), dot(v_out.uv-center, float2(s,c)));

        v_out.uv += (2.0*center);

        return image.Sample(textureSampler, v_out.uv);
    }
    else
    {
        return image.Sample(textureSampler, v_in.uv);
    }
        
}