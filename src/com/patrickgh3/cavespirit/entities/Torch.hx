package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;
import com.patrickgh3.cavespirit.scenes.GameScene;
import com.patrickgh3.cavespirit.Util;

/**
 * Static source of light.
 */
class Torch extends Entity
{
	private var light:Light;
	private var count:Int = 0;
	private var countgoal:Int = 60;
	private var fadevelocity:Float = 0.003;
	private var sprite:Spritemap;
	private var sfxCrack1:Sfx;
	private var sfxCrack2:Sfx;
	private var sfxCrack3:Sfx;
	private var soundcount:Int = 0;
	private var soundcountgoal:Int = 1;
	private var hitbox:Entity;
	private var hbwidth:Int = 96;
	
	public function new(x:Int, y:Int, scale:Float) 
	{
		super(x, y);
		graphic = sprite = new Spritemap("gfx/torch.png", 12, 12);
		sprite.add("idle", [0, 1], 3);
		sprite.play("idle");
		sprite.x = -2;
		sprite.y = -1;
		light = new Light(x + 64 + 3, y + 64 + 3, scale, 1);
		GameScene.lighting.add(light);
		sfxCrack1 = new Sfx("snd/crackle1.wav");
		sfxCrack2 = new Sfx("snd/crackle2.wav");
		sfxCrack3 = new Sfx("snd/crackle3.wav");
		hitbox = new Entity(x - hbwidth / 2, y - hbwidth / 2);
		hitbox.width = hitbox.height = hbwidth;
	}
	
	override public function update():Void
	{
		count++;
		if (count == countgoal)
		{
			fadevelocity *= -1;
		}
		else if (count == countgoal * 2)
		{
			fadevelocity *= -1;
			count = 0;
		}
		light.scale += fadevelocity;
		
		if (!onCamera) return;
		if (GameScene.fairy != null && GameScene.human == null && !Util.entityCollide(hitbox, GameScene.fairy)) return;
		if (GameScene.human != null && GameScene.fairy == null && !Util.entityCollide(hitbox, GameScene.human)) return;
		if (GameScene.fairy != null && GameScene.human != null && !(Util.entityCollide(hitbox, GameScene.fairy) || Util.entityCollide(hitbox, GameScene.human))) return;
		soundcount++;
		if (soundcount == soundcountgoal)
		{
			soundcount = 0;
			soundcountgoal = 6 + Util.randInt(15);
			if (Math.random() < 0.33) sfxCrack1.play(0.1);
			else if (Math.random() < 0.5) sfxCrack2.play(0.1);
			else sfxCrack3.play(0.1);
		}
	}
	
}