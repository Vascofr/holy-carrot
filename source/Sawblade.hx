package;

import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;

class Sawblade extends FlxSprite
{

	public function new(X:Float, Y:Float, Rotation:Float):Void
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

		angle = Rotation * FlxAngle.TO_DEG;
		switch(angle) {
			case 0:
				y += 4;
				offset.y += 2;
			case 90:
				x -= 138;
				y += 20;
				var widthTemp = width;
				width = height;
				height = widthTemp;
				offset.x += 37;
				offset.y -= 90;
			case 180:
				x -= 300;
				y -= 118;
				offset.y -= 52;
			case 270:
				x -= 31.5;
				y -= 281;
				var widthTemp = width;
				width = height;
				height = widthTemp;
				offset.x += 93;
				offset.y -= 92;
		}

	}

	override public function update(elapsed:Float):Void
	{		
		super.update(elapsed);
	}
	
}
