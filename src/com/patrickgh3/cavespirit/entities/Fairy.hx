package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.patrickgh3.cavespirit.scenes.GameScene;
import flash.geom.Point;

/**
 * Floating fairy which gives off light.
 */
class Fairy extends Entity
{
	private var velocity:Point;
	private var sprite:Spritemap;
	private var firsttick:Bool = true;
	private var travelling:Bool = false;
	private var target:Point;
	private var targetrange:Int = 3;
	private var light:Light;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		velocity = new Point();
		target = new Point();
		graphic = sprite = new Spritemap("gfx/fairy.png", 16, 16);
		sprite.add("fly", [0, 1, 2, 3], 6);
		light = new Light(0, 0, 1, 1);
		GameScene.lighting.add(light);
		layer = -3;
	}
	
	override public function update():Void
	{
		if (!firsttick) sprite.play("fly");
		firsttick = false;
		
		if (travelling)
		{
			moveAtAngle(HXP.angle(x, y, target.x, target.y), 1);
			if (closeToTarget()) travelling = false;
		}
		
		x += velocity.x;
		y += velocity.y;
		
		light.x = cast(x + 64 + 6, Int);
		light.y = cast(y + 64 + 6, Int);
		
		if (velocity.x > 0) sprite.flipped = true;
		else if (velocity.x < 0) sprite.flipped = false;
	}
	
	private function flyToPoint(x:Int, y:Int):Void
	{
		travelling = true;
		target.x = x - 8;
		target.y = y - 8;
	}
	
	private function closeToTarget():Bool
	{
		return Math.abs(x - target.x) < targetrange && Math.abs(y - target.y) < targetrange;
	}
	
}