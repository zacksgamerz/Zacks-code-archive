package examples;

/**
 * usage
 * ```haxe
 * loadfolder("assets/images");
 * loadfolder("assets/shared/images/ui");
 * ```
 */
function loadfolder(folder:String) {
    // SysPathing.createFileRelToExe("/assetList.txt", folder);
    // var ugh = FileSystem.readDirectory(Sys.getCwd() + '/' + folder);
    // var ugh2 = "";
    // for (i in 0...ugh.length) {
    // 	ugh2 += ugh[i] + ",";
    // }
    // File.saveContent(folder + '/assetList.txt', ugh2);
    var charpaths =  FileSystem.readDirectory(Sys.getCwd() + '/' + folder);
    for (path in charpaths)
    {
        var fullpath = '$folder/$path';

        if (!path.contains('.png'))
            continue;

        //fuck how dynamics work
        // #if !debug
        // var bet:Bytes = ZCrypt.decrypt("png", fullpath);
        // var bit:ByteArray = ByteArray.fromBytes(bet);
        // var bitmap = BitmapData.fromBytes(bit);
        // #else
        var bitmap = BitmapData.fromFile(Sys.getCwd() + '/' + fullpath);
        // #end

        Paths.cache.setBitmapData(fullpath, bitmap);
        Paths.dumpExclusions.push(fullpath);
        // trace(Paths.dumpExclusions.toString());
        // Paths.bitSprites.set(fullpath, Paths.cache.getBitmapData(fullpath));
        // Paths.cache.clear(fullpath);//uhh not needed???
        //trace(fullpath);

        FlxG.bitmap.add(bitmap, false, fullpath).persist = true;

        loadedImages++;
    }
}
