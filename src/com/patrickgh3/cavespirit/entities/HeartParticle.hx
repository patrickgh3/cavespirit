package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * Particle given off by playerhuman and playerfairy.
 */
class HeartParticle extends Entity
{
	private var angle:Float;
	private var count:Int = 0;
	private inline static var  fadetime:Int = 30;
	private var sprite:Image;
	
	public function new(x:Float, y:Float, colorpink:Bool) 
	{
		super(x, y);
		angle = Math.random() * 360;
		if (colorpink) graphic = sprite = new Image("gfx/heart.png", new Rectangle(0, 0, 8, 8));
		else graphic = sprite = new Image("gfx/heart.png", new Rectangle(8, 0, 8, 8));
		layer = -4;
		graphic.x = graphic.y = -4;
	}
	
	override public function update():Void
	{
		moveAtAngle(angle, 0.5);
		sprite.alpha = (fadetime - count) / fadetime;
		if (count == fadetime) HXP.scene.remove(this);
		count++;
	}
	
}