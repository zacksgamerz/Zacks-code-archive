import flixel.system.FlxAssets.FlxShader;

// Shader in question: https://www.shadertoy.com/view/ldjGzV
// Original haxefl code: https://github.com/jobf/haxeflixel-vcr-effect-shader/blob/master/source/VhsShader.hx
// Modified by zackdroid so it can be much easier to handle.

class VhsHandler
{
    public var shader:VhsShader;
    public var noise(default, set):Float = 0.0;
    public var intensity(default,set):Float = 0.2;

	public function new()
	{
		//super();
        shader = new VhsShader();
    	shader.iTime.value = [0.0];
	    shader.noisePercent.value = [0.0];
        shader.intensity.value = [0.2];
	}

	public function update(elapsed:Float)
	{
    	shader.iTime.value[0] += elapsed;
	}

	function set_noise(value:Float):Float {
	    shader.noisePercent.value = [value];
        noise = value;
        return value;
	}
	function set_intensity(value:Float):Float {
    	shader.intensity.value = [value];
        intensity = value;
        return value;
	}
}

class VhsShader extends FlxShader {
    @:glFragmentSource('
    #pragma header
    
    uniform float iTime;
    uniform sampler2D noiseTexture;
    uniform float noisePercent;
    uniform float intensity;
    
    float rand(vec2 co)
    {
        //no highp, crashes bullshit.
        float a = 12.9898;
        float b = 78.233;
        float c = 43758.5453;
        float dt= dot(co.xy ,vec2(a,b));
        float sn= mod(dt,3.14);
        return fract(sin(sn) * c);
    }
        
    float noise(vec2 p)
    {
        return rand(p) * noisePercent;
    }
    
    float onOff(float a, float b, float c)
    {
        return step(c, sin(iTime + a*cos(iTime*b)));
    }

    float ramp(float y, float start, float end)
    {
        float inside = step(start,y) - step(end,y);
        float fact = (y-start)/(end-start)*inside;
        return (1.-fact) * inside;
    }

    float stripes(vec2 uv)
    {
        float noi = noise(uv*vec2(0.5,1.) + vec2(1.,3.));
        return ramp(mod(uv.y*4. + iTime/2.+sin(iTime + sin(iTime*0.63)),1.),0.5,0.6)*noi;
    }

    vec4 getVideo(vec2 uv)
    {
        vec2 look = uv;
        float window = 1./(1.+20.*(look.y-mod(iTime/4.,1.))*(look.y-mod(iTime/4.,1.)));
        look.x = look.x + sin(look.y*10. + iTime)/50.*onOff(4.,4.,.3)*(1.+cos(iTime*80.))*window;
        float vShift = 0.4*onOff(2.,3.,.9) * (sin(iTime)*sin(iTime*20.) + (0.5 + 0.1*sin(iTime*200.)*cos(iTime)));
        look.y = mod(look.y + vShift, 1.);
        vec4 video = vec4(flixel_texture2D(bitmap,mix(uv,look,intensity)));
        return video;
    }

    vec2 screenDistort(vec2 uv)
    {
        uv -= vec2(.5,.5);
        uv = uv*1.2*(1./1.2+2.*uv.x*uv.x*uv.y*uv.y);
        uv += vec2(.5,.5);
        return uv;
    }

    void main()
    {
        vec2 uv = openfl_TextureCoordv.xy;
        uv = screenDistort(uv);
        vec4 video = getVideo(uv);
        float daAlp = video.a; // we dont want a black camera with the efx on it.
        float vigAmt = 3.+.3*sin(iTime + 5.*cos(iTime*5.));
        float vignette = (1.-vigAmt*(uv.y-.5)*(uv.y-.5))*(1.-vigAmt*(uv.x-.5)*(uv.x-.5));
        
        video += stripes(uv);
        video += noise(uv*2.)/2.;
        video *= vignette;
        video *= (12.+mod(uv.y*30.+iTime,1.))/13.;
        
        gl_FragColor = vec4(video.rgb,daAlp);
    }
    ')
    public function new() {
        super();
    }
}
