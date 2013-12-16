package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.patrickgh3.cavespirit.scenes.GameScene;

/**
 * Fairy death animation. :(
 */
class DyingFairy extends Entity
{
	private var sprite:Spritemap;
	private var state:Int = 0;
	private var count:Int = 0;
	private static inline var stopy:Int = 120 - 3;
	
	private var sfxFlap:Sfx;
	private var sfxDeath:Sfx;
	private var sfxStep:Sfx;

	public function new(x:Int, y:Int) 
	{
		super(x, y);
		graphic = sprite = new Spritemap("gfx/deathfairy.png", 16, 16);
		sprite.add("slowfly", [0, 1, 2, 3], 1.5);
		sprite.flipped = true;
		sfxFlap = new Sfx("snd/flap.wav");
		sfxDeath = new Sfx("snd/death.wav");
		sfxStep = new Sfx("snd/step.wav");
		layer = -3;
	}
	
	override public function update():Void
	{
		if (state == 0)
		{
			count++;
			if (count == 2) sprite.play("slowfly");
			if (count == 120)
			{
				state = 1;
				sprite.pause();
				sprite.setFrame(4);
				sfxFlap.play(0.5);
			}
		}
		else if (state == 1)
		{
			y += 0.5;
			if (y > stopy)
			{
				y = stopy;
				state = 2;
				count = 0;
				sprite.setFrame(5);
				sfxStep.play(0.25);
				sfxFlap.play(0.5);
				GameScene.sfxMusic.stop();
			}
		}
		else if (state == 2)
		{
			count++;
			if (count == 90)
			{
				sprite.setFrame(6);
				sfxFlap.play(0.5);
			}
			else if (count == 180)
			{
				sprite.setFrame(5);
				sfxDeath.play(0.25);
				sfxFlap.play(1);
				state = -1;
				count = 0;
			}
		}
		else if (state == -1 && sprite.alpha > 0)
		{
			count++;
			sprite.alpha = Math.min((180 - count + 300) / 180, 1);
			if (sprite.alpha == 0)
			{
				HXP.scene.remove(this);
				GameScene.fairy = null;
			}
		}
	}
	
}