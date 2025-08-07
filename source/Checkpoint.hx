package;

import flixel.FlxG;
import flixel.FlxSprite;

class Checkpoint extends FlxSprite
{
	var flashTime:Float = 0.0;
	var flashSpeed:Float = 4;
	var flashing:Bool = false;

	public var number:Int = 0;
	public var flipped:Bool = false;  // doesn't flip the sprite, only changes direction of player when spawned.

	public function new(X:Float, Y:Float, Number:Int, Flipped:Bool):Void
	{
		super(X, Y);

		number = Number;
		flipped = Flipped;

		loadGraphic("assets/images/sunflower.png", true, 122, 280);

		animation.add("off", [0], 1, true);
		animation.add("on", [1], 1, true);

		animation.play("off");
		if (number <= Player.checkpointNumber) {
			animation.play("on");
		}

		width -= 30;
		offset.x += 15;
		x += 15;

		height -= 15;
		offset.y += 15;
		y += 15;

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

		FlxG.camera.flash(0x11ffffff, 0.45);
	}

}
