package;

import flixel.system.FlxAssets.FlxShader;
/**
 * ported by luckydog
 * helped? by zack
 * thanks to https://github.com/TyLindberg/glsl-vignette for shader
 * ```haxe
 * var v = new VignetteEffect();
 * v.radius = 0.9;
 * v.smoothness = 0;
 * FlxG.camera.setFilters([new ShaderFilter(v.shader)]);
 * ```
 */

class VignetteEffect
{
    public var shader(default, null):VignetteShader2 = new VignetteShader2();

    public var radius(default, set):Float = 0.5;
    public var smoothness(default, set):Float = 0.5;

    function set_radius(value:Float):Float {
		radius = value;
        shader.uRadius.value = [value];
        return value;
	}

	function set_smoothness(value:Float):Float {
		smoothness = value;
        shader.uSmoothness.value = [value];
        return value;
	}

    public function new() {
        shader.uRadius.value = [0.5];
        shader.uSmoothness.value = [0.5];
        //to prevent null object
    }
}

class VignetteShader2 extends FlxShader
{ //NOTE: DONT ADD VALUES TO uRadius or uSmoothness IN GLFRAGMENTSOURCE!!!!!!!!!!!! DO IT VIA SET FUNCTIONS INSTEAD
    @:glFragmentSource('
    #pragma header

    uniform float uRadius;
    uniform float uSmoothness;

    float vignette(vec2 uv, float radius, float smoothness) {
        float diff = radius - distance(uv, vec2(0.5, 0.5));
        return smoothstep(-smoothness, smoothness, diff);
    }

    void main()
    {
        vec2 uv = openfl_TextureCoordv;
        
        float vignetteValue = vignette(uv, uRadius, uSmoothness);

        vec4 color = texture2D(bitmap, uv);
        color.rgb *= vignetteValue;
        gl_FragColor = color;
    }')
    
    public function new() {
        super();
    }
}