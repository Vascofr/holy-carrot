package particles;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.effects.particles.FlxParticle;

class BloodParticle extends FlxParticle
{
    var resized:Bool = false;
    var updatedDown:Bool = false;

    public function new()
    {
        super();
    }

    override public function update(elapsed:Float):Void
    {    
        if (!resized) {
            resized = true;
            
            offset.x = Std.int((width - 4) * 0.5);
            width = 4;
            height = 4;
            //offset.y = -6;

            velocity.x *= 14;
            velocity.y *= 14;

            acceleration.y *= 12;
        }


        if (isTouching(DOWN)) {
            //active = false;
            velocity.set(0.0, 0.0);
            acceleration.set(0.0, 0.0);
            drag.x = 1000;
            if (scale.x < 1.0) {
                scale.x += elapsed * 0.5;
            }
            angle = 0.0;
            angularVelocity = 0.0;
            angularAcceleration = 0.0;

            if (scale.x < 0.7) {
                scale.x += elapsed * 0.4;
                //scale.x = 1.0;
            }
        }

        else
            super.update(elapsed);
    }
}