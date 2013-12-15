package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

/**
 * Human death animation. :(
 */
class DyingHuman extends Entity
{
	private var sprite:Spritemap;
	private var count:Int = 0;
	private var sfxStep:Sfx;
	private var sfxJump:Sfx;
	private var sfxDeath:Sfx;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		graphic = sprite = new Spritemap("gfx/deathhuman.png", 24, 24);
		layer = -2;
		sfxStep = new Sfx("snd/step.wav");
		sfxJump = new Sfx("snd/jump.wav");
		sfxDeath = new Sfx("snd/death.wav");
	}
	
	override public function update():Void
	{
		if (count < 1000) count++;
		if (count == 1)
		{
			sprite.setFrame(1);
			sfxStep.play(0.25);
		}
		else if (count == 30)
		{
			sprite.setFrame(2);
			sfxStep.play(0.25);
		}
		else if (count == 120)
		{
			sprite.setFrame(1);
			sfxJump.play(0.25);
		}
		else if (count == 150)
		{
			sprite.setFrame(2);
			sfxStep.play(0.25);
		}
		else if (count == 210)
		{
			sprite.setFrame(3);
			sfxStep.play(0.25);
		}
		else if (count == 270)
		{
			sprite.setFrame(4);
			sfxDeath.play(0.25);
		}
	}
	
}