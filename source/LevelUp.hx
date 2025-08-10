package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxSubState;

class LevelUp extends FlxSubState
{
    var bg:FlxSprite;
    var levelUpText:FlxText;
    var descriptionText:FlxText;
    var descriptionText2:FlxText;
    var clickText:FlxText;

    var levelUpTextY:Float = 85;
    var descriptionTextY:Float = 198;
    var descriptionText2Y:Float = 280;
    var clickTextY:Float = 358;

    var timeOpen:Float = 0.0;
    var closing:Bool = false;

    public function new() {
        super();

        bg = new FlxSprite(554, -400, "assets/images/level_up_bg.png");
        add(bg);

        FlxTween.tween(bg, { y: -40 }, 0.43, { ease: FlxEase.quadOut });

        levelUpText = new FlxText(bg.x, bg.y + levelUpTextY, 767, "Level Up!");
        levelUpText.setFormat("assets/fonts/ChelseaMarket-Regular.ttf", 64, 0xffffffff, FlxTextAlign.CENTER);
        add(levelUpText);

        descriptionText = new FlxText(bg.x, bg.y + descriptionTextY, 767, "Run faster,\njump higher!");
        descriptionText.setFormat("assets/fonts/ChelseaMarket-Regular.ttf", 40, 0xffffffff, FlxTextAlign.CENTER);
        add(descriptionText);

        descriptionText2 = new FlxText(bg.x, bg.y + descriptionText2Y, 767, " ");
        descriptionText2.setFormat("assets/fonts/ChelseaMarket-Regular.ttf", 40, 0xffffffff, FlxTextAlign.CENTER);
        add(descriptionText2);

        clickText = new FlxText(bg.x, bg.y + clickTextY, 767, "Click anywhere to continue");
        clickText.setFormat("assets/fonts/ChelseaMarket-Regular.ttf", 25, 0xffffffff, FlxTextAlign.CENTER);
        clickText.alpha = 0.55;
        add(clickText);

        switch (Player.level) {
            case 2:
                levelUpTextY -= 20;
                levelUpText.y = bg.y + levelUpTextY;

                //descriptionText.text = "Run faster, \njump higher!\n\nNew ability: Wall jump";
                descriptionTextY -= 35;
                descriptionText.y = bg.y + descriptionTextY;

                descriptionText2.text = "New ability: Wall jump";

            case 4:
                levelUpTextY -= 20;
                levelUpText.y = bg.y + levelUpTextY;

                descriptionText.text = "New ability: Ceiling run";
                descriptionTextY -= 35;
                descriptionText.y = bg.y + descriptionTextY;

                descriptionText2.text = "HOLD button while\ntouching ceiling";
                descriptionText2Y -= 48;
        }
    }

    override public function update(elapsed:Float) {
        levelUpText.y = bg.y + levelUpTextY;
        descriptionText.y = bg.y + descriptionTextY;
        descriptionText2.y = bg.y + descriptionText2Y;
        clickText.y = bg.y + clickTextY;

        super.update(elapsed);

        timeOpen += elapsed;
        if (timeOpen > 1.15) {
            if (!closing && (FlxG.mouse.justPressed || FlxG.keys.justPressed.ANY)) {
                closing = true;
                FlxG.sound.play("assets/sounds/click.wav", 0.7);
                FlxTween.tween(bg, { y: -400 }, 0.7, { ease: FlxEase.quadIn, onComplete: function(_) {
                    close();
                }});
            }
        }      

    }
}