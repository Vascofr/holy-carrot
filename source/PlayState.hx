package;

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

	override public function create():Void
	{
		super.create();
		flixelInit();

		FlxG.stage.addChild(new FPS(26, 26, 0x33dd33));

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

		ogmoLoader.loadEntities(loadEntity, "entities");

		tilemap.pixelPerfectPosition = true;
		
		/*decals = ogmoLoader.loadDecals("decals", "assets/ogmo");
		decals.forEach(function(decal) {
			cast(decal, FlxSprite).x = Std.int(cast(decal, FlxSprite).x);
			cast(decal, FlxSprite).y = Std.int(cast(decal, FlxSprite).y);
			cast(decal, FlxSprite).offset.x = Std.int(cast(decal, FlxSprite).offset.x);
			cast(decal, FlxSprite).offset.y = Std.int(cast(decal, FlxSprite).offset.y);
		});*/
	}

	override public function update(elapsed:Float):Void
	{
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

		FlxG.overlap(player, carrots, playerCarrotOverlap);
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
				var carrot = new Carrot(entity.x + 27, entity.y - 100 + 80);
				carrots.add(carrot);
			
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
		carrot.overlappingPlayer = true;

		if (carrot.state == 0) {
			carrot.state = 1;
			carrot.y -= 80;
		}
		else if (carrot.state == 2) {
			carrot.kill();
			player.carrots++;
		}
	}
}
