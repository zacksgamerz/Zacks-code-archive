package;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;
import flixel.FlxSprite;
#if sys
import sys.io.File;
import sys.FileSystem;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
#end

import flash.media.Sound;
class Paths {
    public static function getPath(file:String, type:AssetType, ?library:Null<String> = null)
    {
        if (library != null)
            return getLibraryPath(file, library);
    
        var levelPath:String = '';
        levelPath = getLibraryPathForce(file, library);
        if (OpenFlAssets.exists(levelPath, type))
            return levelPath;
    
        levelPath = getLibraryPathForce(file, "shared");
        if (OpenFlAssets.exists(levelPath, type))
            return levelPath;
    
        return getPreloadPath(file);
    }
    
    static public function getLibraryPath(file:String, library = "preload")
    {
        return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
    }
    
    inline static function getLibraryPathForce(file:String, library:String)
    {
        return '$library:assets/$library/$file';
    }
    
    inline public static function getPreloadPath(file:String = '')
    {
        return 'assets/$file';
    }
    
    inline static public function image(key:String, ?library:String):Dynamic
    {
        return getPath('images/$key.png', IMAGE, library);
    }

    inline static public function font(key:String)
    {
        return Main.getDataPath() + 'assets/fonts/$key';
    }
    
}