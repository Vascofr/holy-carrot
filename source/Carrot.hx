package;

import flixel.FlxG;
import flixel.FlxSprite;

class Carrot extends FlxSprite
{
	public var state:Int = 0;
	public var overlappingPlayer:Bool = false;

	public function new(X:Float, Y:Float):Void
	{
		super(X, Y, "assets/images/carrot.png");

		width = 45;
		height = 98;
		offset.x = 27;
		offset.y = 1;

	}

	override public function update(elapsed:Float):Void
	{		

		super.update(elapsed);

		if (state == 1 && !overlappingPlayer) {
			state = 2;
		}


		overlappingPlayer = false;
	}

}
