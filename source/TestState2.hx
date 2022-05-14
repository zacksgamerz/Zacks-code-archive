package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;

class TestState2 extends FlxState {
    public var image:FlxSprite;
    public var curHeight:Int = FlxG.height;
    public var theWindows:Array<Array<String>> = [
        // ["alert"],
        // ["borderless"],
        // ["close"],
        // ["maximize"],
        // ["minimize"],
        // ["fullscreen"],
        // ["height"],
        // ["mouselock"],
        // ["move"],
        // ["tween"],
        // ["onKeyUp"],
        // ["onKeyDown"],
        // ["onActivate"],
        // ["onClose"],
        // ["onDeactivate"],
        // ["onDropFile"],
        // ["onEnter"],
        // ["onExpose"],
        // ["onFocusOut"],
        // ["onFocusIn"],
        // ["onFullscreen"],
        // ["onLeave"],
        // ["onMaximize"],
        // ["onMinimize"],
        // ["resizable"],
        // ["resize"],
        // ["setIcon"],
        // ["textInputToggle"],
        // ["changeTitle"],
        // ["warpMouse"]
    ];

    public var curWidth:Int = 1280;
    public var curSelected:Int = 0;
    override function create() {
        super.create();
        
        // image = new FlxSprite().loadGraphic(Paths.image("myass"));
        image.screenCenter();
        image.antialiasing = true;
        add(image);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.UP)
            changeInt(1);
        if (FlxG.keys.justPressed.DOWN)
            changeInt(-1);
        if (FlxG.keys.justPressed.ENTER)
            windowDo(theWindows[curSelected][0]);
    }

    public function changeInt(hm:Int) {
        curSelected += hm;
        switch (curSelected) {
            case 30:
                curSelected = 0;
            case -1:
                curSelected = 29;
        }
        trace(theWindows[curSelected][0]);
    }

    public function windowDo(dowhat:String) {

        switch (dowhat) {
            //do i really need to explain the obvious ones.
            case "alert":
                FlxG.stage.window.alert("This is the alert message", "This is the alert title");
            case "borderless":
                FlxG.stage.window.borderless = !FlxG.stage.window.borderless;
            case "close":
                FlxG.stage.window.close();
            case "maximize":
                FlxG.stage.window.maximized = !FlxG.stage.window.maximized;
            case "minimize":
                FlxG.stage.window.minimized = !FlxG.stage.window.minimized;
            case "fullscreen":
                FlxG.stage.window.fullscreen = !FlxG.stage.window.fullscreen;
                // can also be V
                // FlxG.fullscreen = !FlxG.fullscreen;
            case "height": 
                FlxG.stage.window.height = curHeight;
            case "mouselock":
                FlxG.stage.window.mouseLock = !FlxG.stage.window.mouseLock;
            case "move":
                FlxG.stage.window.move(FlxG.stage.window.x + FlxG.random.int(30, 100), FlxG.stage.window.y + FlxG.random.int(30, 100));
            case "tween":
                FlxTween.tween(FlxG.stage.window, {x: FlxG.stage.window.x + 200, y: FlxG.stage.window.y - 200}, 1.2, {ease: FlxEase.quadInOut});
            case "onKeyUp": //adds listeners. Check each listener for the function arguments.. if the bool argument is set to true, it does it only once.
                FlxG.stage.window.onKeyUp.add(keyUpListener, false);
            case "onKeyDown":
                FlxG.stage.window.onKeyDown.add(keyDownListener, false);
            case "onActivate":
                FlxG.stage.window.onActivate.add(activateListener, false);
            case "onClose":
                FlxG.stage.window.onClose.add(closeListener, false);
            case "onDeactivate":
                FlxG.stage.window.onDeactivate.add(deactivateListener, false);
            case "onDropFile": 
                Sys.command('start ' + SysPathing.getExePath('assets/example.txt'));
                FlxG.stage.window.onDropFile.add(dropFileListener, false);
            case "onEnter":
                FlxG.stage.window.onEnter.add(enterListener, false);
            case "onExpose": 
                FlxG.stage.window.onExpose.add(exposeListener, false);
            case "onFocusIn": 
                FlxG.stage.window.onFocusIn.add(focusInListener, false);
            case "onFocusOut": 
                FlxG.stage.window.onFocusOut.add(focusOutListener, false);
            case "onFullscreen": 
                FlxG.stage.window.onFullscreen.add(fullscreenListener, false);
            case "onLeave": 
                FlxG.stage.window.onLeave.add(leaveListener, false);
            case "onMaximize":
                FlxG.stage.window.onMaximize.add(maximizeListener, false);
            case "onMinimize":
                FlxG.stage.window.onMinimize.add(minimizeListener, false);
            // case "": okay listen im not doing anymore listeners fuck this they way too damn long.
            //     FlxG.stage.window.onMouseDown.add();
            case "resizable": //toggles whether the window can be resized manually or not.
                FlxG.stage.window.resizable = !FlxG.stage.window.resizable;
            case "resize": //resizes the window.
                FlxG.stage.window.resize(1280, 720);
            case "setIcon": //changes the window's icon
                // FlxG.stage.window.setIcon(Paths.image("myass"));
            case "textInputToggle": //toggles the ability in input text lmao 
                FlxG.stage.window.textInputEnabled = !FlxG.stage.window.textInputEnabled;
            case "changeTitle": // changes the window title
                FlxG.stage.window.title = FlxG.random.getObject(["ASS FUCKER SIMULATOR", "hooo very scary i changed your window title", "if you get this you love the taste of cock", "demotivation.", "hello?", "yo wassup", "im good hbu", "not really that good", "we miserable ey", "yeah.", "cock and balls torture"]);
            case "warpMouse": //warps yo mouse, duh.
                FlxG.stage.window.warpMouse(0,0);
            case "width": //change width
                FlxG.stage.window.width = curWidth;
        }
    }

    public function minimizeListener():Void {
        // does whatever the fuck you want whenever you maximize the window.
        FlxG.openURL("https://twitter.com/ZackDroidCoder");
    }

    public function maximizeListener():Void {
        // does whatever the fuck you want whenever you maximize the window.
        FlxG.openURL("https://twitter.com/ZackDroidCoder");
    }
    
    public function leaveListener():Void {
        // does whatever the fuck you want whenever you leave the window.
        FlxG.openURL("https://twitter.com/ZackDroidCoder");
    }

    public function keyUpListener(KeyCode:lime.ui.KeyCode, KeyMod:lime.ui.KeyModifier):Void {
        // this is obvious.
        if (KeyCode == lime.ui.KeyCode.UP)
            FlxG.stage.window.y -= 10;
    }

    public function dropFileListener(File:String):Void {
        // makes the game react when you drop a file to the game, currently only works with string files such as txt, lua, json, etc.
        // you can make a json decoder or someshit for your game or fnf mod.
        FlxG.log.warn("file loaded: " + File);
    }

    public function fullscreenListener():Void {
        // does whatever you put in this function when you fullscreen.
        FlxG.openURL("https://music.youtube.com/watch?v=QIPJXqnpH3Y");
    }
 
    public function closeListener():Void {
        // does whatever the fuck you want whenever you close the window.
        FlxG.openURL("https://twitter.com/ZackDroidCoder");
    }

    public function keyDownListener(KeyCode:lime.ui.KeyCode, KeyMod:lime.ui.KeyModifier):Void {
        // this is obvious.
        if (KeyCode == lime.ui.KeyCode.DOWN)
            FlxG.stage.window.y += 10;
    }

    public function activateListener():Void {
        // uhh idfk??????
        FlxG.log.warn("activate log.");
    }

    public function deactivateListener():Void {
        // uhh idfk?????? 2
        FlxG.log.warn("deactivate log.");
    }

    public function enterListener():Void {
        // uhh idfk?????? 3
        FlxG.log.warn("enter log.");
    }

    public function exposeListener():Void {
        // uhh idfk?????? 4
        FlxG.log.warn("expose log.");
    }

    public function focusInListener():Void {
        // uhh idfk?????? 5
        FlxG.log.warn("focusIn log.");
    }

    public function focusOutListener():Void {
        // uhh idfk?????? 6
        FlxG.log.warn("focusOut log.");
    }

}