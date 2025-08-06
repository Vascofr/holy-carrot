package;

import flixel.FlxG;
import flixel.FlxSprite;

class Checkpoint extends FlxSprite
{
	var flashTime:Float = 0.0;
	var flashSpeed:Float = 4;
	var flashing:Bool = false;

	public var number:Int = 0;

	public function new(X:Float, Y:Float, Number:Int):Void
	{
		super(X, Y);

		number = Number;

		loadGraphic("assets/images/sunflower.png", true, 103, 244);

		animation.add("off", [0], 1, true);
		animation.add("on", [1], 1, true);

		animation.play("off");
		if (number <= Player.checkpointNumber) {
			animation.play("on");
		}

		//width = 226;
		//height = 96;
		//offset.x = 37;
		//offset.y = 52;

	}

	override public function update(elapsed:Float):Void
	{		
		super.update(elapsed);

		if (flashTime > 0.0) {
			setColorTransform(1.0 + flashTime, 1.0 + flashTime, 1.0 + flashTime);

			if (flashing) {
				flashTime += flashSpeed * elapsed;
				if (flashTime >= 1.35) {
					flashTime = 1.35;
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
	}

	public function flash() {
		flashTime = flashSpeed * FlxG.elapsed;
		flashing = true;
	}

}
