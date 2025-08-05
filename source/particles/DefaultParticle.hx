package particles;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.effects.particles.FlxParticle;

class DefaultParticle extends FlxParticle
{
    public function new()
    {
        super();
        
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (exists && lifespan > 0) {
            var t = age / lifespan; // age = how far along this particle is (0 to 1)
            var easedT = FlxEase.quadOut(t); // or use any FlxEase function

            var currentScale = FlxMath.lerp(0.7, 1.0, easedT);
            scale.set(currentScale, currentScale);

            var currentAlpha = FlxMath.lerp(1.0, 0.0, easedT);
            alpha = currentAlpha;

            /*if (age >= 0.5) {
                velocity.set(0.0, 0.0);
            }*/
        }
    }
}