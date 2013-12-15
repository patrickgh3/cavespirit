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
	private static inline var targetrange:Float = 2;
	private static inline var speed:Float = 0.65;
	private var light:Light;
	private var movingextra:Bool = false; // to prevent getting stuck on corners, move until past the corner, then stop.
	
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
		var numcollisions:Int = 0;
		// horizontal movement
		var diff:Float;
		var collision:Bool;
		var i:Int = 0;
		while (i < Math.abs(velocity.x))
		{
			diff = Math.min(1, Math.abs(velocity.x) - i) * Util.sign(velocity.x);
			x += diff;
			collision = Util.collidelevelmask(this) || x < HXP.camera.x || x + width > HXP.camera.x + GameScene.prefwidth;
			if (collision)
			{
				x -= diff;
				//velocity.x = 0;
				numcollisions++;
				movingextra = true;
			}
			i++;
		}
		// vertical movement
		i = 0;
		while (i < Math.abs(velocity.y))
		{
			diff = Math.min(1, Math.abs(velocity.y) - i) * Util.sign(velocity.y);
			y += diff;
			collision = Util.collidelevelmask(this);
			if (collision)
			{
				y -= diff;
				//velocity.y = 0;
				numcollisions++;
				movingextra = true;
			}
			i++;
		}
		
		if (numcollisions == 2)
		{
			travelling = false;
			velocity.x = velocity.y = 0;
		}
		
		if (movingextra && numcollisions == 0)
		{
			travelling = false;
			velocity.x = velocity.y = 0;
			movingextra = false;
		}
	}
	
	private function flyToPoint(x:Int, y:Int):Void
	{
		velocity.x = velocity.y = 0;
		target.x = x - 6;
		target.y = y - 6;
		if (Math.pow(target.x - this.x, 2) + Math.pow(target.y - this.y, 2) < 3 * 3) return;
		
		travelling = true;
		
		var angle:Float = HXP.angle(this.x, this.y, target.x, target.y);
		if (angle > 90 && angle < 270) sprite.flipped = false;
		else sprite.flipped = true;
		
		velocity.x = speed * Math.cos(angle * 0.0174532925);
		velocity.y = speed * -Math.sin(angle * 0.0174532925);
	}
	
	private function closeToTarget():Bool
	{
		return Math.abs(x - target.x) < targetrange && Math.abs(y - target.y) < targetrange;
	}
	
}