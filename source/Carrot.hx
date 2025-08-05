package;

import flixel.FlxG;
import flixel.FlxSprite;

class Carrot extends FlxSprite
{
	public var state:Int = 0;
	public var overlappingPlayer:Bool = false;

	var flashTime:Float = 0.0;
	var flashSpeed:Float = 12;
	var flashing:Bool = false;
	
	public var carrotHealth:Int = 1;
	public var size:Int = 1;


	public function new(X:Float, Y:Float, Size:Int = 1):Void
	{
		carrotHealth = size = Size;

		if (size == 1) {
			super(X, Y, "assets/images/carrot.png");
		}
		else {
			super(X, Y, "assets/images/carrot_x" + size + ".png");
		}

		width = 45 * size;
		height = 98 * size;
		offset.x = 41 * size;
		offset.y = 13 * size;

	}

	override public function update(elapsed:Float):Void
	{		

		super.update(elapsed);

		if (state == 1 && !overlappingPlayer) {
			if (carrotHealth <= 0) {
				if (size == 2) trace("state set to 2");
				state = 2;
			}
			else {
				if (size == 2) trace("state set to 0");
				state = 0;
			}
		}


		if (flashTime > 0.0) {
			setColorTransform(1.0 + flashTime, 1.0 + flashTime, 1.0 + flashTime);

			if (flashing) {
				flashTime += flashSpeed * elapsed;
				if (flashTime >= 1.0) {
					flashTime = 1.0;
					flashing = false;
				}
			}
			else {
				flashTime -= flashSpeed * elapsed;
				if (flashTime <= 0.0) {
					flashTime = 0.0;
				}
			}
		}


		overlappingPlayer = false;
	}

	public function flash() {
		flashTime = flashSpeed * FlxG.elapsed;
		flashing = true;
	}
}
