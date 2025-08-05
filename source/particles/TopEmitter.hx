package particles;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class TopEmitter extends FlxEmitter {
    override public function emitParticle():FlxParticle {
        var p = super.emitParticle();
        remove(p, true);
        add(p); // ensure it's drawn on top
        return p;
    }
}