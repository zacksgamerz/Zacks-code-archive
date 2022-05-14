package; // makes things easier for me -zack

// also made by me thank you very much
// also if you find this confusing asf then ask me directly because i havent added explanations yet.
import flixel.FlxG;
import haxe.io.Path;
import sys.io.File;

using StringTools;

#if sys
import sys.FileSystem;
#end

class SysPathing
{ // virus hacking folders!?!?!?1/1/1/1?!?!?!?
	/**
	 * Gets path from the user's files. (Multiplatform) (WIP)
	 * @param daPath The path you'd like to get.
	 * @return Returns the multiplatform path as `String`.
	 */
	public static function getPath(daPath:String):String
	{
		var daPathReal:String = daPath;
		#if android
		daPathReal = "/" + daPath;
		#elseif windows
		daPathReal = "C:/Users/" + Sys.environment()["USERNAME"] + daPath;
		#elseif flash
		daPathReal = "file:///C:/O/" + daPath;
		#elseif mac
		// TO DO: ADD AUTO FILE PATH TO MACOS
		#elseif linux
		// TO DO: ADD AUTO FILE PATH TO LINUX
		#end
		return daPathReal;
	}

	// a combination of Sys.programPath() and relativeToPath()
	// also makes the path if nonexistent so no accidental errors happen.
	/**
	 * A combination of `Sys.programPath()` and `Sys.relativeToPath()`. Gets game exe path.
	 * @param addition (Optional) Incase you want to get a file relative to the game's exe.     If the path doesn't exist it will make it.
	 * @return Returns the full path.
	 */
	public static function getExePath(?addition:String):String
	{
		#if sys
		if (addition == null)
		{
			return Sys.programPath();
		}
		else
		{
			if (FileSystem.exists(Path.join([Path.directory(Sys.programPath()), addition])))
			{
				return Path.join([Path.directory(Sys.programPath()), addition]);
			}
			else
			{
				// FileSystem.createDirectory(Path.join([Path.directory(Sys.programPath()), addition]));
                createDirRelToExe(addition);
				return Path.join([Path.directory(Sys.programPath()), addition]); // alot of copy pastes there
			}
		}
		#end
	}

    //you might say that i should just use exists() like a normal person but no because 1. i like sneeping into folders 2. this provides more information to me idk about you lol 3. i love it
    /**
     * An advanced and detailed version of `Sys.FileSystem.exists()`. Functions the same though.
     * @param file The directory to check.
     * @return Returns `false` if directory doesn't exist, otherwise it returns `true`
     */
    public static function isPathExisting(file:String):Bool {
        //trace(Path.join([Path.directory(Sys.programPath()), file]));
		return FileSystem.exists(Path.join([Path.directory(Sys.programPath()), file]));
	}

	/**
	 * idk lmao
	 * @param addition 
	 * @return String
	 */
	public static function lmfao(?addition:String):String
	{
		#if sys
		if (addition == null)
		{
			return Sys.programPath();
		}
		else
		{
			if (FileSystem.exists(Path.join([Path.directory(Sys.programPath()), addition])))
			{
				return Path.join([Path.directory(Sys.programPath()), addition]);
			}
			else
			{
				// FileSystem.createDirectory(Path.join([Path.directory(Sys.programPath()), addition]));
				return Path.join([Path.directory(Sys.programPath()), addition]); // alot of copy pastes there
			}
		}
		#end
	}

	/**
	 * Creates directory relative to exe path. If directory has a file extension, it will run `createFileRelToExe()` instead. Usage: `SysPathing.createDirRelToExe("newfolder/", "existingfolder/)"`.
	 * @param file The directory you want to make.
	 * @param addition Use this only if there are existing directories.
	 */
	public static function createDirRelToExe(file:String, ?addition:String = ""):Void
	{
		#if sys
		var daFiles:Array<String> = file.split("/");
		var daExt:String = "";
		var daDir:String = "";

		if (file.contains("/"))
		{
			daDir += "/" + addition;
			daFiles = file.split("/");
		}
		else if (addition != "")
			if (addition.contains("/"))
				daFiles = addition.split("/");
			else
				daFiles = [addition];

		for (i in 0...daFiles.length)
		{
			if (daFiles[i].contains("."))
			{
				createFileRelToExe(file, addition);
			}
			else
			{
				daDir += daFiles[i] + "/";
			}
		}

		if (!FileSystem.exists(Path.join([Path.directory(Sys.programPath()), daDir])))
			FileSystem.createDirectory(Path.join([Path.directory(Sys.programPath()), daDir]));
		#end
	}

	/**
	 * Create file relative to the game's exe. Usage: `SysPathing.createDirRelToExe("newfolder/newfile.extension", "existingfolder/)`.
	 * @param file The file you want to make. (MUST HAVE EXTENSION)
	 * @param addition Use this only if there are existing directories.
	 */
	public static function createFileRelToExe(file:String, ?addition:String = "")
	{
		#if sys
		var daFiles:Array<String> = file.split("/");
		var daExt:String = "";
		var daDir:String = "";

		if (file.contains("/"))
		{
			daDir += "/" + addition;
			daFiles = file.split("/");
		}
		else if (addition != "")
			if (addition.contains("/"))
				daFiles = addition.split("/");
			else
				daFiles = [addition];

		for (i in 0...daFiles.length)
		{
			if (daFiles[i].contains("."))
			{
				daExt = daFiles[i];
				daFiles.remove(daFiles[i]);
			}
			else
			{
				daDir += daFiles[i] + "/";
			}
		}

		// trace(daDir);

		var path:String = "";

		if (!FileSystem.exists(Path.join([Path.directory(Sys.programPath()), daDir + daExt])))
		{
            // if (!FileSys)
			FileSystem.createDirectory(Path.join([Path.directory(Sys.programPath()), daDir]));

			File.write(path = Path.join([Path.directory(Sys.programPath()), daDir + daExt]), false);
		}

		return path;
		// FileSystem.createDirectory(Path.join([Path.directory(Sys.programPath() + "/" + addition), file]));
		#end
	}

	// separate contents with commas if its multiple lines.
	/**
	 * Appends file that it's path is relative to the game's exe path. throws a warning if path doesn't exist.
	 * @param file The file you want to edit.
	 * @param contents The contents you want to give it. if you want to separate it with multiple lines, use commas. Example: `text1,text2,text3`.
	 */
	public static function editFileRelToExe(file:String, contents:String)
	{
        if (isPathExisting(file)) {
		    var daFiles:Array<String> = file.split("/");
		    var daExt:String = "";
		    var daDir:String = "/";

		    if (file.contains("/"))
		    {
			    // daDir += "/";
			    daFiles = file.split("/");
		    }
		    else
		    {
			    daFiles = [file];
		    }

		    for (i in 0...daFiles.length)
		    {
			    if (daFiles[i].contains("."))
			    {
				    daExt = daFiles[i];
				    daFiles.remove(daFiles[i]);
			}
			    else
			    {
				    daDir += daFiles[i] + "/";
			    }
		    }
		    // trace(daExt);

		    var items:List<String> = new List<String>();
		    var toAdd:Array<String> = contents.split(",");
		    var added;

		    for (i in 0...toAdd.length)
		    {
			    items.add(toAdd[i]);
		    }
		    for (i in items)
		    {
			    added = File.append(Path.join([Path.directory(Sys.programPath()), daDir + daExt]), false);
			    added.writeString(i + "\n");
			    added.close();
		    }
	    } else {
            FlxG.stage.window.alert("WARNING: File " + '"' + file + '"' + "doesn't exist. Appending file cancelled", "SysPathing.hx warning.");
        }
    }
}
