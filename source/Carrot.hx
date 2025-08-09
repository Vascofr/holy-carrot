package;

import flixel.FlxG;
import flixel.FlxSprite;

class Carrot extends FlxSprite
{
	public var state:Int = 0;
	public var overlappingPlayer:Bool = false;

	var flashTime:Float = 0.0;
	var flashTimeMax:Float = 1.0;
	var flashSpeed:Float = 1.5;
	var flashing:Bool = false;
	
	public var carrotHealth:Int = 1;
	public var size:Int = 1;

	public var checkNum:Int = 0;

	public function new(X:Float, Y:Float, CheckNum:Int = 0, Size:Int = 1):Void
	{
		carrotHealth = size = Size;
		checkNum = CheckNum;

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

		if (size == 8) {
			width -= 100;
			offset.x -= 195;
			offset.y += 140;
			x -= 195;
			y += 140;
			carrotHealth = size = 16;
		}

	}

	override public function update(elapsed:Float):Void
	{		

		super.update(elapsed);

		if (state == 1 && !overlappingPlayer) {
			if (carrotHealth <= 0) {
				state = 2;
			}
			else {
				state = 0;
			}
		}


		if (flashTime > 0.0) {
			setColorTransform(1.0 + flashTime, 1.0 + flashTime, 1.0 + flashTime);

			if (flashing) {
				flashTime += flashSpeed * elapsed;
				if (flashTime >= flashTimeMax) {
					flashTime = flashTimeMax;
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

	public function flash(small:Bool = false) {
		if (!small) {
			flashSpeed = 12;
			flashTime = flashSpeed * FlxG.elapsed;
			flashTimeMax = 1.0;
			flashing = true;
		}
		else {
			flashSpeed = 1.5;
			flashTime = flashSpeed * FlxG.elapsed;
			flashTimeMax = 0.25;
			flashing = true;
		}
	}
}
