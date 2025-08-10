package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;



class TitleScreen extends FlxState
{
	var logo:FlxSprite;
	var startText:FlxText;
	var carrot:FlxSprite;
	var haloTop:FlxSprite;
	var haloBottom:FlxSprite;
	var beams:FlxSprite;


	var flickerTime:Float = 0.9;


	override public function create():Void
	{
		super.create();

		FlxG.camera.bgColor = 0xff8d57f7;
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.unload();

		beams = new FlxSprite(0, 0, "assets/images/title_screen/beams.png");
		add(beams);

		FlxTween.tween(beams, { alpha: 0.2 }, 1.15, { type: PINGPONG, ease: FlxEase.quadInOut });

		logo = new FlxSprite(749, 115, "assets/images/title_screen/logo.png");
		add(logo);

		haloBottom = new FlxSprite(804, 364 + 72, "assets/images/title_screen/halo_bottom_half.png");
		add(haloBottom);

		FlxTween.tween(haloBottom, { y: 364 + 72 + 12 }, 1.15 * 3.5, { type: PINGPONG, ease: FlxEase.quadInOut });

		carrot = new FlxSprite(846, 410, "assets/images/title_screen/carrot.png");
		add(carrot);

		FlxTween.tween(carrot, { y: 410 - 10 }, 1.15 * 2.2, { type: PINGPONG, ease: FlxEase.quadInOut });

		haloTop = new FlxSprite(804, 364, "assets/images/title_screen/halo_top_half.png");
		add(haloTop);

		FlxTween.tween(haloTop, { y: 364 + 12 }, 1.15 * 3.5, { type: PINGPONG, ease: FlxEase.quadInOut });

		startText = new FlxText(0, 890, FlxG.width, "Click anywhere to play");
		startText.setFormat("assets/fonts/ChelseaMarket-Regular.ttf", 52, 0xffffffff, FlxTextAlign.CENTER);
		add(startText);

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		flickerTime -= elapsed;
		if (flickerTime <= 0.0) {
			if (startText.visible) {
				startText.visible = false;
				flickerTime = 0.45;
			}
			else {
				startText.visible = true;
				flickerTime = 0.9;
			}

		}

		if (FlxG.mouse.justPressed /*|| FlxG.keys.justPressed.ANY*/) {
			FlxG.camera.fade(FlxG.camera.bgColor, 0.5, function() {
				FlxG.switchState(PlayState.new);
			});
		}
	}


}
