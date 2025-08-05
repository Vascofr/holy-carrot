package;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	public var levelUpCarrotAmounts:Array<Int> = [5, 15, 30, 50, 80, 120, 170, 250, 500];
	
	static public inline var iSpeed:Float = 390;
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
		super(X, Y);

		loadGraphic("assets/images/player.png", true, 200, 200);
		animation.add("run", [0, 1, 2, 3], 8, true);
		animation.add("climb", [0, 1, 2, 3], 10, true);
		animation.add("jump", [0], 8, true);
		animation.play("run");

		width = 102;
		height = 75;
		offset.x = 40 + 17;
		offset.y = 74;

		speed = iSpeed;
		velocity.x = speed;
		acceleration.y = 2000;

		jumpBuffer = jumpBufferMax;
	}

	override public function update(elapsed:Float):Void
	{
		if (!alive) return;


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

			offset.x = 40 + 6;
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
			
			offset.x = 40 + 4;
		}


		if (FlxG.mouse.justPressed || FlxG.keys.justPressed.ANY) {
			justClicked = true;

			jumpBuffer = jumpBufferMax;
			if (level >= 2) wallJumpBuffer = wallJumpBufferMax;
		}

		if (jumpBuffer > 0.0) {
			if (isTouching(FLOOR)) {
				velocity.y = -jumpHeight;
				jumpBuffer = 0.0;
				wallJumpBuffer = 0.0;
				FlxG.sound.play("assets/sounds/jump.mp3", 1.0);
				animation.play("jump");
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
		
		if (isTouching(DOWN)) {
			animation.play("run");
		}
		else {
			if (isTouching(LEFT) || isTouching(RIGHT)) {
				animation.play("climb");
			}
			else {
				animation.play("jump");
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

	public function deathBySawblade() {
		//FlxG.sound.play("assets/sounds/sawblade.mp3", 0.4);
		alive = false;
		velocity.set(0, 0);
		setColorTransform(1.5, 1.5, 1.5);
		FlxG.sound.play("assets/sounds/sawblade_start.mp3", 0.4);

	}
}
