package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;



class Credits extends FlxState
{
	var creditsText:FlxText;
	var totalTime:Float = 0.0;
	var startedFadeOut:Bool = false;

	override public function create():Void
	{
		super.create();

		FlxG.camera.bgColor = 0xff8d57f7;
		FlxG.camera.fade(FlxG.camera.bgColor, 0.8, true, null, true);

		creditsText = new FlxText(0, FlxG.height, FlxG.width, "Holy Carrot is a game by
Vasco Freitas

Made in one week for 
HaxeJam 2025: Summer jam

The Jam Theme was
\"Taking Root\"

Carrots are roots
And you were taking them

Game framework used
HaxeFlixel

Tools
Visual Studio Code
Ogmo Editor
PaintShop Pro
LabChirp
Audacity

All assets created by Vasco Freitas

With the exception of
\"Ahhhh Choir\" sound effect from FXssoundwarehouse
Sawblade silhouette from ClipartMax


Thank you for playing");
		creditsText.setFormat("assets/fonts/ChelseaMarket-Regular.ttf", 52, 0xffffffff, FlxTextAlign.CENTER);
		creditsText.velocity.y = -88;
		add(creditsText);

		#if html5
		FlxG.log.redirectTraces = true;
		#end
	
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		totalTime += elapsed;

		if (!startedFadeOut && totalTime > 32) {
			startedFadeOut = true;
			if (FlxG.sound.music != null) {
				FlxG.sound.music.fadeOut(3.0);
			}

			FlxG.camera.fade(0xff000000, 3.0, false, function() {
				FlxG.switchState(PlayState.new);
			});
		}

		creditsText.y += creditsText.velocity.y * elapsed;

	}


}
