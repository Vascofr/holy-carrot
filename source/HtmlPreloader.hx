package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.Lib;
import flixel.FlxG;

import flixel.system.FlxBasePreloader;
@:bitmap("preloader/background.webp")
class GraphicBackground extends BitmapData {}


/**
 * This is the Default HaxeFlixel Themed Preloader 
 * You can make your own style of Preloader by overriding `FlxPreloaderBase` and using this class as an example.
 * To use your Preloader, simply change `Project.xml` to say: `<app preloader="class.path.MyPreloader" />`
 */
class HtmlPreloader extends FlxBasePreloader
{
	var _buffer:Sprite;
	var _bmpBar:Bitmap;
	var _bmpBarBg:Bitmap;
	
	var scale:Float = 1.0;
	var xOffset:Float = 0.0;
	var yOffset:Float = 0.0;
	
	/**
	 * Initialize your preloader here.
	 * 
	 * ```haxe
	 * super(0, ["test.com", FlxPreloaderBase.LOCAL]); // example of site-locking
	 * super(10); // example of long delay (10 seconds)
	 * ```
	 */
	override public function new(MinDisplayTime:Float = 0, ?AllowedURLs:Array<String>):Void
	{		
		super(MinDisplayTime, AllowedURLs);
	}
	
	/**
	 * This class is called as soon as the FlxPreloaderBase has finished initializing.
	 * Override it to draw all your graphics and things - make sure you also override update
	 * Make sure you call super.create()
	 */
	override function create():Void
	{
		// Set up the view window and double buffering
		
		_width = Std.int(Lib.current.stage.stageWidth);
		_height = Std.int(Lib.current.stage.stageHeight);
		
		if (_width / _height > 1.77777778) {
			scale = _height / 1080;
			xOffset = _width - (scale * 1920);
			xOffset *= 0.5;
		}
		else {
			scale = _width / 1920;
			yOffset = _height - (scale * 1080);
			yOffset *= 0.5;
		}
		
		_buffer = new Sprite();
		addChild(_buffer);

		
		_buffer.scaleX = _buffer.scaleY = scale;
		_buffer.x = xOffset;
		_buffer.y = yOffset;
		
		
		var bitmap = new Bitmap(new GraphicBackground(0, 0));
		bitmap.smoothing = true;
		bitmap.scaleX = bitmap.scaleY = scale;
		_buffer.addChild(bitmap);
		_bmpBarBg = new Bitmap(new BitmapData(280, 8, false, 0x6d3cda));
		_bmpBarBg.x = 814;
		_bmpBarBg.y = 971;
		_buffer.addChild(_bmpBarBg);
		_bmpBar = new Bitmap(new BitmapData(1, 8, false, 0xffffff));
		_bmpBar.x = 814;
		_bmpBar.y = 971;
		_buffer.addChild(_bmpBar);		

		super.create();
	}
	
	/**
	 * Cleanup your objects!
	 * Make sure you call super.destroy()!
	 */
	override function destroy():Void
	{
		if (_buffer != null)	
		{
			removeChild(_buffer);
		}
		
		FlxG.stage.removeChild(_bmpBar);
		FlxG.stage.removeChild(_bmpBarBg);
		
		_buffer = null;
		_bmpBar = null;
		_bmpBarBg = null;

		super.destroy();
	}
	
	/**
	 * Update is called every frame, passing the current percent loaded. Use this to change your loading bar or whatever.
	 * @param	Percent	The percentage that the project is loaded
	 */
	override public function update(Percent:Float):Void
	{
		
		_width = Std.int(Lib.current.stage.stageWidth);
		_height = Std.int(Lib.current.stage.stageHeight);
		
		if (_width / _height > 1.77777778) {
			scale = _height / 1080;
			xOffset = _width - (scale * 1920);
			xOffset *= 0.5;
			
			yOffset = _height - (scale * 1080);
			yOffset *= 0.5;
		}
		else {
			scale = _width / 1920;
			yOffset = _height - (scale * 1080);
			yOffset *= 0.5;

			xOffset = _width - (scale * 1920);
			xOffset *= 0.5;
		}
		
		if (_buffer.scaleX != scale) {
			_buffer.scaleX = scale;
			_buffer.scaleY = scale;
			_buffer.x = xOffset;
			_buffer.y = yOffset;
		}
		
		
		_bmpBar.scaleX = Std.int(Percent * 100) * 2.8;
		
	}

}
