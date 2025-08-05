package;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	public var levelUpCarrotAmounts:Array<Int> = [5, 15, 30, 50, 80, 120, 170, 250, 500];
	
	static public inline var iSpeed:Float = 400;
	public var speed:Float = 0;
	public var jumpHeight:Float = 800;  // 600
	var justClicked:Bool = false;
	var jumpBufferMax:Float = 0.2;	
	var jumpBuffer:Float = 0.0;
	var wallJumpBufferMax:Float = 0.1;
	var wallJumpBuffer:Float = 0.0;
	public var facingRight:Bool = true;
	var spriteFlipSpeed:Float = 14.0;
	
	static public inline var quickTurnSpeed:Float = 2000;
	static public inline var slowTurnSpeed:Float = 500;
	var targetAngle:Float = 0.0;
	var angleTurnSpeed:Float = 500.0;

	public var carrots(default, set):Int = 0;

	public var level:Int = 1;

	public function new(X:Float, Y:Float):Void
	{
		super(X, Y, "assets/images/player.png");

		width = 122;
		height = 96;
		offset.x = 40;
		offset.y = 53;

		speed = iSpeed;
		velocity.x = speed;
		acceleration.y = 2000;

		jumpBuffer = jumpBufferMax;
	}

	override public function update(elapsed:Float):Void
	{

		if (facingRight) {
			if (velocity.x <= 0.1) {
				velocity.x = speed;
			}
			if (scale.x < 1.0) {
				scale.x += spriteFlipSpeed * elapsed;
				if (scale.x > 1.0) {
					scale.x = 1.0;
				}
			}
		}
		else {
			if (velocity.x >= -0.1) {
				velocity.x = -speed;
			}
			if (scale.x > -1.0) {
				scale.x -= spriteFlipSpeed * elapsed;
				if (scale.x < -1.0) {
					scale.x = -1.0;
				}
			}
		}


		if (FlxG.mouse.justPressed || FlxG.keys.justPressed.ANY) {
			justClicked = true;

			jumpBuffer = jumpBufferMax;
			wallJumpBuffer = wallJumpBufferMax;
		}

		if (jumpBuffer > 0.0) {
			if (isTouching(FLOOR)) {
				velocity.y = -jumpHeight;
				jumpBuffer = 0.0;
				wallJumpBuffer = 0.0;
			}

			jumpBuffer -= elapsed;
			if (jumpBuffer < 0.0)
				jumpBuffer = 0.0;
		}
		if (wallJumpBuffer > 0.0) {
			if (isTouching(RIGHT)) {
				velocity.y = -jumpHeight * 0.6;
				velocity.x = -speed;
				facingRight = false;

				jumpBuffer = 0.0;
				wallJumpBuffer = 0.0;
			}
			else if (isTouching(LEFT)) {
				velocity.y = -jumpHeight * 0.6;
				velocity.x = speed;
				facingRight = true;

				jumpBuffer = 0.0;
				wallJumpBuffer = 0.0;
			}

			wallJumpBuffer -= elapsed;
			if (wallJumpBuffer < 0.0)
				wallJumpBuffer = 0.0;
		}


		if (!isTouching(ANY) || touching == FLOOR) {
			toAngle(0.0, quickTurnSpeed);
		}

		if (angle < targetAngle) {
			angle += angleTurnSpeed * elapsed;
			if (angle > targetAngle) {
				angle = targetAngle;
			}
		}
		else if (angle > targetAngle) {
			angle -= angleTurnSpeed * elapsed;
			if (angle < targetAngle) {
				angle = targetAngle;
			}
		}
		

		super.update(elapsed);

		if (velocity.y != 0.0) {
			scale.y = 1.0 + Math.abs(velocity.y * 0.0001);
		}
		else {
			scale.y = 1.0;
		}

		justClicked = false;
	}

	public function levelUp() {
		level++;
		speed *= 1.15;
		jumpHeight *= 1.2;
		FlxG.camera.flash(0xccffffff, 0.7);
		
	}

	function set_carrots(newValue:Int):Int
	{
		if (levelUpCarrotAmounts.contains(newValue)) {
			levelUp();
		}
		
		return carrots = newValue;
	}

	public function toAngle(tAngle:Float, turnSpeed:Float) {
		targetAngle = tAngle;
		angleTurnSpeed = turnSpeed;
	}
}
