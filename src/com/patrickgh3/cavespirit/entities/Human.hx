package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import flash.geom.Point;

/**
 * Human character with standard platformer physics.
 */
class Human extends Entity
{
	inline static var runspeed:Float = 0.5;
	
	private var velocity:Point;
	private var sprite:Spritemap;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		velocity = new Point();
		graphic = sprite = new Spritemap("gfx/human.png", 12, 24);
		sprite.add("idle", [0]);
		sprite.add("walk", [1, 0], 4);
		sprite.play("walk");
		layer = -2;
	}
	
	override public function update():Void
	{
		x += velocity.x;
		y += velocity.y;
	}
	
	private function walkRight():Void
	{
		velocity.x = runspeed;
		sprite.flipped = true;
		sprite.play("walk");
	}
	
	private function walkLeft():Void
	{
		velocity.x = -runspeed;
		sprite.flipped = false;
		sprite.play("walk");
	}
	
	private function walkStop():Void
	{
		velocity.x = 0;
		sprite.play("idle");
	}
	
}