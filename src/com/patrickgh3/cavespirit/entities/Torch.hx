package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.patrickgh3.cavespirit.scenes.GameScene;

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
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		graphic = sprite = new Spritemap("gfx/torch.png", 12, 12);
		sprite.add("idle", [0, 1], 3);
		sprite.play("idle");
		sprite.x = -2;
		sprite.y = -1;
		light = new Light(x + 64 + 3, y + 64 + 3, 1, 1);
		GameScene.lighting.add(light);
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
	}
	
}