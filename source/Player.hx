package;

import flixel.math.FlxPoint;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	static public var checkpoint:FlxPoint = null;
	static public var checkpointNumber:Int = 0;
	static public var checkpointFlipped:Bool = false;
	static public var level:Int = 1;

	public var levelUpCarrotAmounts:Array<Int> = [5, 15, 27, 40, 60, 100, -1];
	
	static public inline var iSpeed:Float = 390;
	public var speed:Float = 0;
	public var jumpHeight:Float = 800;  // 600
	var justClicked:Bool = false;
	var jumpBufferMax:Float = 0.2;	
	var jumpBuffer:Float = 0.0;
	var wallJumpBufferMax:Float = 0.1;
	var wallJumpBuffer:Float = 0.0;
	public var facingRight:Bool = true;
	var spriteFlipSpeed:Float = 14.5;
	
	static public inline var quickTurnSpeed:Float = 2000;
	static public inline var slowTurnSpeed:Float = 500;
	var targetAngle:Float = 0.0;
	var angleTurnSpeed:Float = 500.0;

	public var carrots(default, set):Int = 0;

	public var roofRun:Float = 0.0;
	var roofRunLevel:Int = 4;

	var iOffsetY:Float = 74;
	
	var stepSoundTime:Float = 0.0;
	var stepSoundTimeMax:Float = 0.2;

	public var finalSequence:Bool = false;
	var behindHolyCarrot:Bool = false;


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
		offset.y = iOffsetY;

		speed = iSpeed;
		acceleration.y = 2000;

		jumpBuffer = jumpBufferMax;

		level = 1;

		if (checkpointNumber > 0) {

			var effectOnly:Bool = false;
			//if (level != 1) effectOnly = true;

			levelUp(effectOnly);

			for (i in 0...checkpointNumber) {
				levelUp(effectOnly);
			}
		}

		if (level > 1)
			carrots = levelUpCarrotAmounts[level - 2];
		else
			carrots = 0;

		velocity.x = speed;

		maxVelocity.y = 2500;
	}

	override public function update(elapsed:Float):Void
	{
		if (!alive) return;

		if (finalSequence) {
			//speed = 400;
			//spriteFlipSpeed = 8.0;
			if (velocity.x > 0.0) velocity.x = speed;
			else if (velocity.x < 0.0) velocity.x = -speed;

			velocity.y = -115;
			if (x < 12024) {
				var playState:PlayState = cast(FlxG.state, PlayState);
				x = 12024;
				facingRight = true;
				
				if (behindHolyCarrot) {
					behindHolyCarrot = false;
					velocity.x = speed;
					playState.playerBehindCarrotLayer.remove(this, true);
					playState.playerLayer.add(this);
				}
				else {
					behindHolyCarrot = true;
					velocity.x = 0;
					playState.playerLayer.remove(this, true);
					playState.playerBehindCarrotLayer.add(this);
				}
			}
			else if (x > 12638) {
				var playState:PlayState = cast(FlxG.state, PlayState);
				x = 12638;
				facingRight = false;
				if (behindHolyCarrot) {
					behindHolyCarrot = false;
					velocity.x = -speed;
					playState.playerBehindCarrotLayer.remove(this, true);
					playState.playerLayer.add(this);
				}
				else {
					behindHolyCarrot = true;
					velocity.x = 0;
					playState.playerLayer.remove(this, true);
					playState.playerBehindCarrotLayer.add(this);
				}
			}

			if (y < 400) {
				//FlxG.sound.music.fadeOut()
				FlxG.camera.fade(0xffffffff, 6.5, false, 
					function() {
						FlxG.switchState(Credits.new);
					}
				);
			}
		}

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
				velocity.y = -jumpHeight * 0.7;
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
				if (!(isTouching(UP) && level >= roofRunLevel && roofRun > 0.0 && (FlxG.mouse.pressed || FlxG.keys.pressed.ANY))) {
					animation.play("jump");
				}
			}
		}

		// roof running //
		if (!(touching == UP)) {
			roofRun = 0.0;
			if (scale.y < 1.0) {
				scale.y += spriteFlipSpeed * elapsed;
				if (scale.y > 1.0) {
					scale.y = 1.0;
				}
			}

			if (offset.y < iOffsetY) {
				offset.y += 200 * elapsed;
				if (offset.y > iOffsetY) {
					offset.y = iOffsetY;
				}
			}
			
			//animation.play("run");
		}
		else if (level >= roofRunLevel && roofRun > 0.0 && (FlxG.mouse.pressed || FlxG.keys.pressed.ANY)) {
			roofRun -= 460 * elapsed;  // just comment this if you want to try not timing it out  
			velocity.y = -roofRun;

			if (scale.y > -1.0) {
				scale.y -= spriteFlipSpeed * elapsed;
				if (scale.y < -1.0) {
					scale.y = -1.0;
				}
			}

			if (offset.y > iOffsetY - 35) {
				offset.y -= 200 * elapsed;
				if (offset.y < iOffsetY - 35) {
					offset.y = iOffsetY - 35;
				}
			}
			animation.play("climb");
		}


		if (animation.name == "run" || animation.name == "climb") {
			stepSoundTime -= elapsed;
			if (stepSoundTime <= 0.0) {
				stepSoundTime = 0.53333333 * (390 / speed);
				var rand = FlxG.random.int(1, 6);
				FlxG.sound.play("assets/sounds/step" + rand + ".mp3", 0.7 * (FlxG.camera.zoom + ((1.0 - FlxG.camera.zoom) * 0.5)));
			}
		}
		else {
			stepSoundTime = 0.0;
		}

		if (x < 25) {
			x = 25;
			if (isTouching(DOWN)) {
				facingRight = true;
			}
		}
		else if (x > 18100) {
			x = 18100;
			if (isTouching(DOWN)) {
				facingRight = false;

			}
		}
		

		super.update(elapsed);

		

		/*if (velocity.y != 0.0) {
			scale.y = 1.0 + Math.abs(velocity.y * 0.0001);
		}
		else {
			scale.y = 1.0;
		}*/

		justClicked = false;
	}

	public function levelUp(effectOnly:Bool = false) {
		if (!effectOnly) {
			level++;
		}

		var speedFactor:Float = 1.15;
		var jumpFactor:Float = 1.2;
		switch (level) {
			case 4:
				speedFactor = 1.3225;
				jumpFactor = 1.04;
			case 5:
				speedFactor = 1.362175;
		}

		speed *= speedFactor;		
		jumpHeight *= jumpFactor;

		animation.getByName("run").frameRate = Std.int(animation.getByName("run").frameRate * speedFactor);
		animation.getByName("climb").frameRate = Std.int(animation.getByName("climb").frameRate * speedFactor);


		if (PlayState.waitTimeBeforeStart <= 0.0 && !effectOnly) {
			FlxG.camera.flash(0xccffffff, 0.7);
		}
	}

	function set_carrots(newValue:Int):Int
	{
		if (levelUpCarrotAmounts.contains(newValue) && (PlayState.waitTimeBeforeStart <= 0.0)) {
			levelUp();
		}

		if (levelUpCarrotAmounts[level - 1] >= 0)
			cast(FlxG.state, PlayState).carrotHUDText.text = newValue + "/" + levelUpCarrotAmounts[level - 1];
		else
			cast(FlxG.state, PlayState).carrotHUDText.text = newValue + "/?";

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
		//FlxG.sound.play("assets/sounds/sawblade_start.mp3", 0.4);
		FlxG.sound.play("assets/sounds/sawblade.mp3", 0.4);

	}
}
