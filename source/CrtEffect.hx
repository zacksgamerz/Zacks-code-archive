package;

import openfl.filters.ShaderFilter;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;

// Original shader in question: https://www.shadertoy.com/view/WdjfDy
// Ported by ZackDroid, now compatible with haxeflixel.

class CrtEffect {
    public var shader:CrtShader;
    public var curved(default, set):Bool = true;

    public function new() {
        shader = new CrtShader();
        shader.curved.value = [true];
        shader.uTime.value = [0.0];
    }

    public function update(elapsed:Float) {
        shader.uTime.value[0] += elapsed;
    }

    public function getFilter():ShaderFilter {
        return new ShaderFilter(shader);
    }

	public function set_curved(value:Bool):Bool {
		curved = value;
        shader.curved.value = [value];
        return value;
	}
}

class CrtShader extends FlxShader {
    @:glFragmentSource('
    #pragma header

    uniform float uTime;
    uniform bool curved;

    vec2 curve(vec2 uv)
    {
	    return uv;
    }

    void main()
    {
        vec2 uv = openfl_TextureCoordv.xy;

        // Curve
        if (curved)
	        uv = curve( uv );

        float daAlp = flixel_texture2D(bitmap,uv).a;
    
        vec3 col;

        // Chromatic
        col.r = flixel_texture2D(bitmap,vec2(uv.x+0.003,uv.y)).x;
        col.g = flixel_texture2D(bitmap,vec2(uv.x+0.000,uv.y)).y;
        col.b = flixel_texture2D(bitmap,vec2(uv.x-0.003,uv.y)).z;

        col *= step(0.0, uv.x) * step(0.0, uv.y);
        col *= 1.0 - step(1.0, uv.x) * 1.0 - step(1.0, uv.y);

        col *= 0.5 + 0.5*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y);
        col *= vec3(0.95,1.05,0.95);

        col *= 0.9+0.1*sin(10.0*uTime+uv.y*700.0);

        col *= 0.99+0.01*sin(110.0*uTime);

        gl_FragColor = vec4(col,daAlp);
    }
    ')

    public function new() {
        super();
    }
}