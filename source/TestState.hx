package;

import flixel.util.FlxColor;
import GlitchEffect.GlitchShader;
import CrtEffect.CrtShader;
import openfl.filters.ShaderFilter;
import VcrShader.VhsHandler;
import GameboyDesaturator.GameboyHandler;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxG;

class TestState extends FlxState{
    public var CrtShade:CrtEffect = null;
    public var GameboyShade:GameboyHandler = null;
    public var GlitchShade:GlitchEffect = null;
    public var VcrShade:VhsHandler = null;
    public var VignetteShade:VignetteEffect = null;

    public var shaderFilter:Array<ShaderFilter> = [];

    public var descArray:Array<Array<String>> = [
        ["CrtEffect", "A small CRT shader, doesn't take that much memory aswell, can be curved or not.", "Press ENTER to toggle curve."],
        ["GameboyDesaturator", "A shader that changes the colors displayed on the screen into what the gameboy displays.", "LEFT/RIGHT to adjust the colors."],
        ["GlitchEffect", "A shader that displays a glitchy effect, display_squares and intensity easily adjustable", "LEFT/RIGHT to adjust intensity | A/D to adjust display_squares"],
        ["VcrShader", "A shader that puts a hard VHS effect onto the display, has noise (static) and intensity (glitchiness), curve not toggle-able", "LEFT/RIGHT to adjust noise | A/D to adjust intensity"],
        ["VignetteEffect", "A shader that puts a vignette overlay onto the display, smoothness and radius can be adjusted easily", "LEFT/RIGHT to adjust smoothness | A/D to adjust radius"]
    ];
    public var TheText:FlxText;
    public var displayText:FlxText;
    public var theGraphic:FlxSprite;
    public var curSelected:Int = 0;
    override function create() {
        super.create();

        CrtShade = new CrtEffect();
        shaderFilter.push(CrtShade.getFilter());

        GameboyShade = new GameboyHandler();
        shaderFilter.push(new ShaderFilter(GameboyShade.shader));

        GlitchShade = new GlitchEffect();
        shaderFilter.push(new ShaderFilter(GlitchShade.shader));

        VcrShade = new VhsHandler();
        shaderFilter.push(new ShaderFilter(VcrShade.shader));

        VignetteShade = new VignetteEffect();
        shaderFilter.push(new ShaderFilter(VignetteShade.shader));

        theGraphic = new FlxSprite().loadGraphic(Paths.image("myass"));
        theGraphic.antialiasing = true;
        theGraphic.screenCenter();
        add(theGraphic);

        TheText = new FlxText(0,0,0,"UP/DOWN to change selection.", 24);
        TheText.setFormat(Paths.font("bedangcatfont"), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        TheText.antialiasing = true;
        TheText.screenCenter();
        TheText.y += 200;
        add(TheText);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        CrtShade.update(elapsed);
        GlitchShade.update(elapsed);
        VcrShade.update(elapsed);

        if (FlxG.keys.justPressed.UP)
            changeShit(-1);

        if (FlxG.keys.justPressed.DOWN)
            changeShit(1);

        if (FlxG.keys.justPressed.ENTER)
            CrtShade.curved = !CrtShade.curved;

        if (FlxG.keys.justPressed.LEFT) {
            switch (curSelected) {
                case 1:
                    GameboyShade.BRIGHTNESS -= 0.1;
                case 2:
                    GlitchShade.glitchMultiply -= 0.1;
                case 3:
                    VcrShade.noise -= 0.1;
                case 4:
                    VignetteShade.smoothness -= 0.1;
                default:
            }
        }

        if (FlxG.keys.justPressed.RIGHT) {
            switch (curSelected) {
                case 1:
                    GameboyShade.BRIGHTNESS += 0.1;
                case 2:
                    GlitchShade.glitchMultiply += 0.1;
                case 3:
                    VcrShade.noise += 0.1;
                case 4:
                    VignetteShade.smoothness += 0.1;
                default:
            }
        }

        if (FlxG.keys.justPressed.A) {
            switch (curSelected) {
                case 2:
                    GlitchShade.NUM_SAMPLES -= 1;
                case 3:
                    VcrShade.intensity -= 0.1;
                case 4:
                    VignetteShade.radius -= 0.1;
                default:
            }
        }

        if (FlxG.keys.justPressed.D) {
            switch (curSelected) {
                case 2:
                    GlitchShade.NUM_SAMPLES += 1;
                case 3:
                    VcrShade.intensity += 0.1;
                case 4:
                    VignetteShade.radius += 0.1;
                default:
            }
        }
    }

    public function changeShit(?huh:Int = 0) {
        curSelected += huh;

        if (curSelected == 4)
            curSelected = 0;
        if (curSelected == -1)
            curSelected = 3;

        TheText.text = descArray[curSelected][1] + "\n" + descArray[curSelected][2];
        TheText.screenCenter(X);

        FlxG.camera.setFilters([shaderFilter[curSelected]]);
    }
}