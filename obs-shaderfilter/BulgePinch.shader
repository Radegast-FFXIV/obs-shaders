uniform float radius = 0.0;
uniform float magnitude = 0.0;
uniform float center_x = 0.5;
uniform float center_y = 0.5;
uniform bool animate = false;

float4 mainImage(VertData v_in) : TARGET 
{
    float2 center = float2(center_x, center_y);
	VertData v_out;
    v_out.pos = v_in.pos;
    float2 hw = uv_size;
    const float ar = 1.0 * (float)hw.x/(float)hw.y;
    v_out.uv = v_in.uv * uv_scale  + uv_offset  - center;

    // if(BUFFER_WIDTH > BUFFER_HEIGHT)
    //     texcoord.x *= ar;
    // else
    //     texcoord.y *= ar;

    float dist = distance(v_out.uv, center);
    if (dist < radius)
    {
        float anim_mag = (animate ? magnitude * sin(radians(elapsed_time)) : magnitude);
        float percent = dist/radius;
        if(anim_mag > 0)
            v_out.uv = (v_out.uv - center) * lerp(1.0, smoothstep(0.0, radius/dist, percent), anim_mag * 0.75);
        else
            v_out.uv = (v_out.uv-center) * lerp(1.0, pow(percent, 1.0 + anim_mag * 0.75) * radius/dist, 1.0 - percent);

        v_out.uv += (2*center);

        // if(BUFFER_WIDTH > BUFFER_HEIGHT)
        //     v_out.uv.x /= ar;
        // else
        //     v_out.uv.y /= ar;
        
        return image.Sample(textureSampler, v_out.uv);
    }
    else
    {
        return image.Sample(textureSampler, v_in.uv);
    }
}