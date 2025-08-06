package;

import flixel.FlxG;
import flixel.FlxSprite;

class Sawblade extends FlxSprite
{

	public function new(X:Float, Y:Float):Void
	{
		super(X, Y);

		loadGraphic("assets/images/sawblade.png", true, 300, 151);

		animation.add("spin", [0, 1, 2], 60, true);
		animation.play("spin");

		animation.add("jammed", [0], 60, false);

		width = 226;
		height = 96;
		offset.x = 37;
		offset.y = 52;

	}

	override public function update(elapsed:Float):Void
	{		
		super.update(elapsed);
	}

}
