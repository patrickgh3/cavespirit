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
	//private var velocity:Point;
	private var sprite:Spritemap;
	private var firsttick:Bool = true;
	private var travelling:Bool = false;
	private var target:Point;
	private static inline var targetrange:Int = 3;
	private static inline var speed:Float = 1;
	private var light:Light;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		//velocity = new Point();
		target = new Point();
		graphic = sprite = new Spritemap("gfx/fairy.png", 16, 16);
		sprite.add("fly", [0, 1, 2, 3], 6);
		light = new Light(0, 0, 1, 1);
		GameScene.lighting.add(light);
		layer = -3;
		width = 8;
		height = 8;
		graphic.x = -4;
		graphic.y = -4;
	}
	
	override public function update():Void
	{
		if (!firsttick) sprite.play("fly");
		firsttick = false;
		
		if (travelling)
		{
			move();
			if (closeToTarget()) travelling = false;
		}
		
		light.x = Std.int(x + 64 + 4);
		light.y = Std.int(y + 64 + 4);
	}
	
	private function move():Void
	{
		moveAtAngle(HXP.angle(x, y, target.x, target.y), speed);
		if (Util.collidelevelmask(this))
		{
			moveAtAngle(HXP.angle(x, y, target.x, target.y), -speed);
			travelling = false;
		}
	}
	
	private function flyToPoint(x:Int, y:Int):Void
	{
		target.x = x - 8;
		target.y = y - 8;
		if (Math.pow(target.x - this.x, 2) + Math.pow(target.y - this.y, 2) < 3 * 3) return;
		travelling = true;
		var angle:Float = HXP.angle(this.x, this.y, target.x, target.y);
		if (angle > 90 && angle < 270) sprite.flipped = false;
		else sprite.flipped = true;
		//var theta:Float = HXP.angle(x, y, target.x, target.y);
		//velocity.x = speed * Math.cos(theta);
		//velocity.y = speed * Math.sin(theta);
	}
	
	private function closeToTarget():Bool
	{
		return Math.abs(x - target.x) < targetrange && Math.abs(y - target.y) < targetrange;
	}
	
}