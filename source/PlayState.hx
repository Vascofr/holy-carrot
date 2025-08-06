package;

import particles.BunnyParticle;
import particles.BloodParticle;
import flixel.util.FlxTimer;
import flixel.util.FlxTimer.FlxTimerManager;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxRect;
import openfl.events.Event;
import lime.media.AudioContext;
import js.html.MouseEvent;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import openfl.display.FPS;
import openfl.display.BlendMode;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxState;
import particles.TopEmitter;
import flixel.graphics.frames.FlxTileFrames;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;


class PlayState extends FlxState
{

	var particleEmitter:FlxEmitter;
	
	var ogmoLoader:FlxOgmo3Loader;
	var tilemap:FlxTilemap;
	var bgTilemap:FlxTilemap;

	var player:Player;
	var carrots = new FlxTypedGroup<Carrot>();
	var sawblades = new FlxTypedGroup<Sawblade>();

	public var bloodEmitter:FlxEmitter;
	public var bunnyEmitter:FlxEmitter;

	public var timers:FlxTimerManager = new FlxTimerManager();

	var sawbladeSound:FlxSound;

	var waitTimeBeforeStart:Float = 0.4;

	var fadeSprite:FlxSprite;

	override public function create():Void
	{
		super.create();
		flixelInit();

		//FlxG.stage.addChild(new FPS(26, 26, 0x33dd33));

		ogmoLoader = new FlxOgmo3Loader("assets/ogmo/level.ogmo", "assets/ogmo/level.json");

		bgTilemap = ogmoLoader.loadTilemap("assets/ogmo/tilemap.png", "background");
		bgTilemap.frames = FlxTileFrames.fromBitmapAddSpacesAndBorders("assets/ogmo/tilemap.png", new FlxPoint(100, 100), new FlxPoint(0, 0), new FlxPoint(1, 1));
		bgTilemap.follow();
		add(bgTilemap);

		tilemap = ogmoLoader.loadTilemap("assets/ogmo/tilemap.png", "ground");
		tilemap.frames = FlxTileFrames.fromBitmapAddSpacesAndBorders("assets/ogmo/tilemap.png", new FlxPoint(100, 100), new FlxPoint(0, 0), new FlxPoint(1, 1));
		tilemap.follow();
		add(tilemap);

		add(carrots);
		add(sawblades);

		bloodEmitter = new FlxEmitter(FlxG.width * 0.5, FlxG.height * 0.5, 50);
		bloodEmitter.particleClass = BloodParticle;
		bloodEmitter.makeParticles(32, 32, 0xffffffff, 3000);
		//bloodEmitter.loadParticles("assets/images/particle.png", 15000);
		bloodEmitter.angularVelocity.set(-100, 100, -100, 100);
		bloodEmitter.velocity.set(-4000, -4000, 4000, 4000, -2000, -2000, 2000, 2000);
		bloodEmitter.alpha.set(0.7, 0.8, 0.7, 0.8);
		bloodEmitter.color.set(0xffff0000, 0xffee0000, 0xffee0000, 0xffaa0000);
		bloodEmitter.scale.set(0.5, 0.5, 0.5, 0.5);
		bloodEmitter.lifespan.set(60, 63);
		bloodEmitter.acceleration.set(0, 100, 0, 100);
		bloodEmitter.drag.set(10, 10, 10, 10);
		bloodEmitter.solid = true;
		//bloodEmitter.blend = BlendMode.ADD;
		bloodEmitter.start(false, 0.0004);
		bloodEmitter.emitting = false;
		add(bloodEmitter);

		bunnyEmitter = new FlxEmitter(FlxG.width * 0.5, FlxG.height * 0.5, 50);
		bunnyEmitter.particleClass = BunnyParticle;
		//bunnyEmitter.makeParticles(32, 32, 0xffffffff, 3000);
		bunnyEmitter.loadParticles("assets/images/gibs.png", 5, 0, true);
		bunnyEmitter.angularVelocity.set(-180, 180, -180, 180);
		bunnyEmitter.velocity.set(-4000, -4000, 4000, 4000, -2000, -2000, 2000, 2000);
		//bunnyEmitter.alpha.set(0.7, 0.8, 0.7, 0.8);
		//bunnyEmitter.color.set(0xffff0000, 0xffee0000, 0xffee0000, 0xffaa0000);
		//bunnyEmitter.scale.set(0.5, 0.5, 0.5, 0.5);
		bunnyEmitter.lifespan.set(60, 63);
		bunnyEmitter.acceleration.set(0, 100, 0, 100);
		bunnyEmitter.drag.set(10, 10, 10, 10);
		bunnyEmitter.solid = true;
		//bunnyEmitter.blend = BlendMode.ADD;
		
		//bunnyEmitter.emitting = false;
		add(bunnyEmitter);

		ogmoLoader.loadEntities(loadEntity, "entities");

		tilemap.pixelPerfectPosition = true;

		add(timers);
		
		/*decals = ogmoLoader.loadDecals("decals", "assets/ogmo");
		decals.forEach(function(decal) {
			cast(decal, FlxSprite).x = Std.int(cast(decal, FlxSprite).x);
			cast(decal, FlxSprite).y = Std.int(cast(decal, FlxSprite).y);
			cast(decal, FlxSprite).offset.x = Std.int(cast(decal, FlxSprite).offset.x);
			cast(decal, FlxSprite).offset.y = Std.int(cast(decal, FlxSprite).offset.y);
		});*/


		fadeSprite = new FlxSprite(0, 0);
		fadeSprite.makeGraphic(FlxG.width, FlxG.height, FlxG.camera.bgColor);
		fadeSprite.antialiasing = false;
		fadeSprite.scrollFactor.set(0.0, 0.0);
		add(fadeSprite);
		
	}

	override public function update(elapsed:Float):Void
	{
		if (waitTimeBeforeStart > 0.0) {
			waitTimeBeforeStart -= elapsed;
			if (waitTimeBeforeStart <= 0.0) {
				fadeSprite.exists = false;
			}
			FlxG.camera.fade(FlxG.camera.bgColor, 0.2, true, null, true);

			return;
		}
		super.update(elapsed);


		if (player.speed > Player.iSpeed) {
			var targetZoom = 1.0 - (player.speed - Player.iSpeed) * 0.001;

			if (FlxG.camera.zoom > targetZoom) {
				FlxG.camera.zoom -= 0.1 * elapsed;
				if (FlxG.camera.zoom < targetZoom) {
					FlxG.camera.zoom = targetZoom;
				}
			}

		}

		if (FlxG.keys.justPressed.X) {
			FlxG.sound.play("assets/sounds/test.mp3", 0.4);
		}
		
		FlxG.collide(player, tilemap, playerTileCollision);
		FlxG.collide(bloodEmitter, tilemap);
		FlxG.collide(bunnyEmitter, tilemap);
		FlxG.overlap(player, carrots, playerCarrotOverlap);
		FlxG.overlap(player, sawblades, playerSawbladeOverlap);
	}

	function flixelInit()
	{
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.unload();
		FlxG.maxElapsed = 0.05;
		FlxG.fixedTimestep = false;
		#if html5
		FlxG.log.redirectTraces = true;
		#end
		//FlxG.camera.antialiasing = true;
		FlxG.camera.bgColor = 0xff8d57f7;
		FlxG.worldBounds.set(-100000, -100000, 200000, 200000);
	}

	function loadEntity(entity:EntityData):Void
	{
		switch (entity.name)
		{
			case "player":
				player = new Player(entity.x, entity.y + 35);
				add(player);
				FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
			case "carrot":
				var carrot = new Carrot(entity.x + 28, entity.y - 18);
				carrot.clipRect = new FlxRect(0, 0, 128, 53);
				carrots.add(carrot);
			case "carrot_x2":
				var carrot = new Carrot(entity.x + 56, entity.y - 64, 2);
				carrot.clipRect = new FlxRect(0, 0, 256, 106);
				carrots.add(carrot);
			case "sawblade":
				var sawblade = new Sawblade(entity.x + 37, entity.y + 17);
				sawblades.add(sawblade);
		}
	}

	function playerTileCollision(player:Player, tiles:FlxTilemap) {
		if (player.justTouched(FLOOR)) {
			if (player.isTouching(LEFT)) {
				player.velocity.x = player.speed;
				player.facingRight = true;
				player.toAngle(0.0, Player.quickTurnSpeed);
			}
			else if (player.isTouching(RIGHT)) {
				player.velocity.x = -player.speed;
				player.facingRight = false;
				player.toAngle(0.0, Player.quickTurnSpeed);
			}
		}
		else if (player.isTouching(FLOOR)) {
			if (player.justTouched(LEFT)) {
				player.velocity.x = player.speed;
				player.facingRight = true;
				player.toAngle(0.0, Player.slowTurnSpeed);
			}
			else if (player.justTouched(RIGHT)) {
				player.velocity.x = -player.speed;
				player.facingRight = false;
				player.toAngle(0.0, Player.slowTurnSpeed);
			}
		}
		
		else if (player.isTouching(RIGHT)) {
			player.toAngle(-90.0, Player.slowTurnSpeed);
		}
		else if (player.isTouching(LEFT)) {
			player.toAngle(90.0, Player.slowTurnSpeed);
		}
	}

	function playerCarrotOverlap(player:Player, carrot:Carrot):Void
	{
		if (carrot.state == 3) return;

		carrot.overlappingPlayer = true;

		if (carrot.state == 0) {
			carrot.state = 1;
			if (carrot.size == 2) trace("state set to 1");
			carrot.carrotHealth--;
			carrot.y -= 67;
			
			if (carrot.carrotHealth <= 0) {
				carrot.flash();
				carrot.clipRect = null;
				FlxTween.tween(carrot, { y: carrot.y - 12 }, 0.65, {type: PINGPONG, ease: FlxEase.quadInOut});
			}
			else {
				carrot.clipRect = new FlxRect(0, 0, carrot.clipRect.width, carrot.clipRect.height + 67);
			}
			
		}
		else if (carrot.state == 2) {
			FlxTween.tween(carrot, { y: carrot.y - 75, alpha: 0.25 }, 0.5, { ease: FlxEase.quadOut, onComplete: function(_) { carrot.kill(); }});
			carrot.state = 3;
			if (carrot.size == 2) trace("state set to 3");
			carrot.flash();
			//carrot.kill();
			player.carrots += carrot.size;
		}
	}

	function playerSawbladeOverlap(player:Player, sawblade:Sawblade):Void
	{
		if (player.alive) {
			player.deathBySawblade();
			
			bloodEmitter.x = player.x + player.width * 0.5;
			bloodEmitter.y = player.y + player.height * 0.5;
			bloodEmitter.emitting = true;
			new FlxTimer(timers).start(0.04, function(t:FlxTimer) {
				bloodEmitter.emitting = false;
			});

			sawblade.animation.pause();
			new FlxTimer(timers).start(0.27, function(t:FlxTimer) {
				sawblade.animation.resume();

				bloodEmitter.emitting = true;

				sawbladeSound = FlxG.sound.play("assets/sounds/sawblade.mp3", 0.4);
				FlxG.timeScale = 0.4;
				//sawbladeSound.pitch = 0.9;
				FlxTween.tween(FlxG, { timeScale: 1.0 }, 1.0, { ease: FlxEase.quadOut });  // keep these 2 the same
				//FlxTween.tween(sawbladeSound, { pitch: 1.0 }, 1.0, { ease: FlxEase.quadOut });  // keep these 2 the same

				//bunnyEmitter.x = player.x + player.width * 0.5;
				//bunnyEmitter.y = player.y + player.height * 0.5;
				//player.kill();
				//bunnyEmitter.start(true);
			});

			new FlxTimer(timers).start(0.31, function(t:FlxTimer) {
				bunnyEmitter.x = player.x + player.width * 0.5;
				bunnyEmitter.y = player.y + player.height * 0.5;
				player.kill();
				bunnyEmitter.start(true);
			});

			new FlxTimer(timers).start(0.37, function(t:FlxTimer) {
				bloodEmitter.emitting = false;
			});

			new FlxTimer(timers).start(3.70, function(t:FlxTimer) {
				FlxG.camera.fade(FlxG.camera.bgColor, 0.26, function() {
					fadeSprite.exists = true;
					FlxG.camera.stopFX();
					//new FlxTimer(timers).start(1.0, function(t:FlxTimer) {
						
						FlxG.switchState(PlayState.new);
					//});
				});
			});

		}
	}
}
