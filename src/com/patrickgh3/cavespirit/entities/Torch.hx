package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
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
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		graphic = Image.createRect(4, 4, 0xff0000);
		light = new Light(x + 64 + 2, y + 64 + 2, 1, 1);
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