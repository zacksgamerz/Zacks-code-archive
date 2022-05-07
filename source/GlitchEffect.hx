package;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;

/**
 * shader by hornet, thanks
 * https://www.shadertoy.com/view/lsfGD2
 * ```haxe
 * glitch = new GlitchEffect();
 * FlxG.camera.setFilters([new ShaderFilter(glitch.shader)]);
 * override function update(elapsed:Float)
 * {
 *      glitch.update(elapsed);
 * }
 * ```
 */
// :moyai:
// entirely ported by luckydog.
// slightly modified by zackdroid

class GlitchEffect
{
    public var shader(default, null):GlitchShader = new GlitchShader();
    //public var intensity(default, set):Int = 10;

    // increass if u want more gitches squares, or decrease (min is 3)
    public var NUM_SAMPLES(default, set):Int = 10;
    // strength of effect
    public var glitchMultiply(default, set):Float = 1;
    // offset of the effect, updated along with iTime.
    public var iMouse(default, set):Float = 779;

    public function new():Void
	{
        shader.iMouseX.value = [779];
		shader.uTime.value = [0];
        shader.NUM_SAMPLES.value = [10];
        shader.glitchMultiply.value = [1];
	}

    // update this manually
	public function update(elapsed:Float):Void
	{
        //shader.iMouseX.value[0] = FlxG.mouse.x;
        shader.iMouseX.value[0] = iMouse; //much better if self adjusted.
		shader.uTime.value[0] += elapsed;
	}

	function set_NUM_SAMPLES(value:Int):Int {
		NUM_SAMPLES = value;
        shader.NUM_SAMPLES.value[0] = value;
        return value;
	}

	function set_glitchMultiply(value:Float):Float {
		glitchMultiply = value;
        shader.glitchMultiply.value[0] = value;
        return value;
	}

    function set_iMouse(value:Float):Float {
		iMouse = value;
        return value;
	}
}

class GlitchShader extends FlxShader {
    @:glFragmentSource('
    #pragma header

    uniform float uTime;
    uniform float iMouseX;
    uniform int NUM_SAMPLES;
    uniform float glitchMultiply;
    
    float sat( float t ) {
        return clamp( t, 0.0, 1.0 );
    }
    
    vec2 sat( vec2 t ) {
        return clamp( t, 0.0, 1.0 );
    }
    
    //remaps inteval [a;b] to [0;1]
    float remap  ( float t, float a, float b ) {
        return sat( (t - a) / (b - a) );
    }
    
    //note: /\\ t=[0;0.5;1], y=[0;1;0]
    float linterp( float t ) {
        return sat( 1.0 - abs( 2.0*t - 1.0 ) );
    }
    
    vec3 spectrum_offset( float t ) {
        float t0 = 3.0 * t - 1.5;
        return clamp( vec3( -t0, 1.0-abs(t0), t0), 0.0, 1.0);
        /*
        vec3 ret;
        float lo = step(t,0.5);
        float hi = 1.0-lo;
        float w = linterp( remap( t, 1.0/6.0, 5.0/6.0 ) );
        float neg_w = 1.0-w;
        ret = vec3(lo,1.0,hi) * vec3(neg_w, w, neg_w);
        return pow( ret, vec3(1.0/2.2) );
    */
    }
    
    //note: [0;1]
    float rand( vec2 n ) {
      return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
    }
    
    //note: [-1;1]
    float srand( vec2 n ) {
        return rand(n) * 2.0 - 1.0;
    }
    
    float mytrunc( float x, float num_levels )
    {
        return floor(x*num_levels) / num_levels;
    }
    vec2 mytrunc( vec2 x, float num_levels )
    {
        return floor(x*num_levels) / num_levels;
    }

    void main()
    {
        float aspect = openfl_TextureSize.x / openfl_TextureSize.y;
        vec2 uv = openfl_TextureCoordv;
        // uv.y = 1.0 - uv.y;
        
        float time = mod(uTime, 32.0); // + modelmat[0].x + modelmat[0].z;
    
        float GLITCH = (0.1 + iMouseX / openfl_TextureSize.x) * glitchMultiply;
        
        //float rdist = length( (uv - vec2(0.5,0.5))*vec2(aspect, 1.0) )/1.4;
        //GLITCH *= rdist;
        
        float gnm = sat( GLITCH );
        float rnd0 = rand( mytrunc( vec2(time, time), 6.0 ) );
        float r0 = sat((1.0-gnm)*0.7 + rnd0);
        float rnd1 = rand( vec2(mytrunc( uv.x, 10.0*r0 ), time) ); //horz
        //float r1 = 1.0f - sat( (1.0f-gnm)*0.5f + rnd1 );
        float r1 = 0.5 - 0.5 * gnm + rnd1;
        r1 = 1.0 - max( 0.0, ((r1<1.0) ? r1 : 0.9999999) ); //note: weird ass bug on old drivers
        float rnd2 = rand( vec2(mytrunc( uv.y, 40.0*r1 ), time) ); //vert
        float r2 = sat( rnd2 );
    
        float rnd3 = rand( vec2(mytrunc( uv.y, 10.0*r0 ), time) );
        float r3 = (1.0-sat(rnd3+0.8)) - 0.1;
    
        float pxrnd = rand( uv + time );
    
        float ofs = 0.05 * r2 * GLITCH * ( rnd0 > 0.5 ? 1.0 : -1.0 );
        ofs += 0.5 * pxrnd * ofs;
    
        uv.y += 0.1 * r3 * GLITCH;
    
        // const int NUM_SAMPLES = 10;
        // const float RCP_NUM_SAMPLES_F = 1.0 / float(NUM_SAMPLES);
        float RCP_NUM_SAMPLES_F = 1.0 / float(NUM_SAMPLES);
        
        vec4 sum = vec4(0.0);
        vec3 wsum = vec3(0.0);
        for( int i=0; i<NUM_SAMPLES; ++i )
        {
            float t = float(i) * RCP_NUM_SAMPLES_F;
            uv.x = sat( uv.x + ofs * t );
            vec4 samplecol = texture2D( bitmap, uv );
            vec3 s = spectrum_offset( t );
            samplecol.rgb = samplecol.rgb * s;
            sum += samplecol;
            wsum += s;
        }
        sum.rgb /= wsum;
        sum.a *= RCP_NUM_SAMPLES_F;
    
        //gl_FragColor = vec4( sum.bbb, 1.0 ); return;
        
        gl_FragColor.a = sum.a;
        gl_FragColor.rgb = sum.rgb; // * outcol0.a;
    }')

    public function new() {
        super();
    }
}
