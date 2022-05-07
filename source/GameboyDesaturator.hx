package;

import flixel.system.FlxAssets.FlxShader;


// original shader in question: https://www.shadertoy.com/view/MdfXDH
// Ported by ZackDroid with the help of luckydog.

class GameboyHandler {
    //public var size(default, set):Float = 128.0;
    //public var threshold(default, set):Float = 0.006;
    public var BRIGHTNESS(default, set):Float = 1.0;
    public var shader:GameboyShader = null;
    public function new() {
        shader = new GameboyShader();
        shader.BRIGHTNESS.value = [1.0];
        //shader.threshold.value = [0.006];
    }

	/*function set_size(value:Float):Float {
		size = value;
        shader.size.value = [value];
        return value;
	}
    function set_threshold(value:Float):Float {
		threshold = value;
        shader.threshold.value = [value];
        return value;
	}*/
    function set_BRIGHTNESS(value:Float):Float {
		BRIGHTNESS = value;
        shader.BRIGHTNESS.value = [value];
        return value;
	}
}

class GameboyShader extends FlxShader {
    @:glFragmentSource('
    #pragma header
    //#define GAMEBOY
    //#define GAMEBOY
    uniform float BRIGHTNESS;

    vec3 iscloser (in vec3 color, in vec3 current, inout float dmin) 
    {
        vec3 closest = current;
        float dcur = distance (color, current);
        if (dcur < dmin) 
        {
            dmin = dcur;
            closest = color;	
        }
        return closest;
    }
    
    vec3 find_closest (vec3 ref) {	
        vec3 old = vec3 (100.0*255.0);		
        #define TRY_COLOR(new) old = mix (new, old, step (length (old-ref), length (new-ref)));	
        
        //#ifdef GAMEBOY
        TRY_COLOR (vec3 (156.0, 189.0, 15.0));
        TRY_COLOR (vec3 (140.0, 173.0, 15.0));
        TRY_COLOR (vec3 (48.0, 98.0, 48.0));
        TRY_COLOR (vec3 (15.0, 56.0, 15.0));
        //#endif
        
        return old;
    }
    
    
    float dither_matrix (float x, float y) {
        return mix(mix(mix(mix(mix(mix(0.0,32.0,step(1.0,y)),mix(8.0,40.0,step(3.0,y)),step(2.0,y)),mix(mix(2.0,34.0,step(5.0,y)),mix(10.0,42.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),mix(mix(mix(48.0,16.0,step(1.0,y)),mix(56.0,24.0,step(3.0,y)),step(2.0,y)),mix(mix(50.0,18.0,step(5.0,y)),mix(58.0,26.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(1.0,x)),mix(mix(mix(mix(12.0,44.0,step(1.0,y)),mix(4.0,36.0,step(3.0,y)),step(2.0,y)),mix(mix(14.0,46.0,step(5.0,y)),mix(6.0,38.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),mix(mix(mix(60.0,28.0,step(1.0,y)),mix(52.0,20.0,step(3.0,y)),step(2.0,y)),mix(mix(62.0,30.0,step(5.0,y)),mix(54.0,22.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(3.0,x)),step(2.0,x)),mix(mix(mix(mix(mix(3.0,35.0,step(1.0,y)),mix(11.0,43.0,step(3.0,y)),step(2.0,y)),mix(mix(1.0,33.0,step(5.0,y)),mix(9.0,41.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),mix(mix(mix(51.0,19.0,step(1.0,y)),mix(59.0,27.0,step(3.0,y)),step(2.0,y)),mix(mix(49.0,17.0,step(5.0,y)),mix(57.0,25.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(5.0,x)),mix(mix(mix(mix(15.0,47.0,step(1.0,y)),mix(7.0,39.0,step(3.0,y)),step(2.0,y)),mix(mix(13.0,45.0,step(5.0,y)),mix(5.0,37.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),mix(mix(mix(63.0,31.0,step(1.0,y)),mix(55.0,23.0,step(3.0,y)),step(2.0,y)),mix(mix(61.0,29.0,step(5.0,y)),mix(53.0,21.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(7.0,x)),step(6.0,x)),step(4.0,x));
    }
    
    vec3 dither (vec3 color, vec2 uv) {	
        color *= 255.0 * BRIGHTNESS;	
        color += dither_matrix (mod (uv.x, 8.0), mod (uv.y, 8.0));
        color = find_closest (clamp (color, 0.0, 255.0));
        return color / 255.0;
    }
    
    
    void main()
    {
        vec2 uv = openfl_TextureCoordv.xy;
        vec4 tc = flixel_texture2D(bitmap, uv);
        float daAlp = tc.a;
        gl_FragColor =  vec4 (dither (tc.xyz, uv),daAlp);		
    }')

    public function new() {
        super();
    }
}