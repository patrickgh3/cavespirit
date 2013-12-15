package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.patrickgh3.cavespirit.scenes.GameScene;
import flash.geom.Point;

/**
 * Human character with standard platformer physics.
 */
class Human extends Entity
{
	inline static var runspeed:Float = 0.5;
	private inline static var grav:Float = 0.05;
	private inline static var jumpspeed:Float = 1.5;
	
	private var onGround:Bool = false;
	private var velocity:Point;
	private var sprite:Spritemap;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		velocity = new Point();
		graphic = sprite = new Spritemap("gfx/human.png", 12, 24);
		sprite.add("idle", [0]);
		sprite.add("walk", [1, 0], 4);
		sprite.add("jump", [2]);
		sprite.add("fall", [3]);
		sprite.play("walk");
		layer = -2;
		width = 8;
		height = 20;
		graphic.x = -2;
		graphic.y = -4;
	}
	
	override public function update():Void
	{
		velocity.y += grav;
		
		move();
		
		if (onGround && velocity.x == 0) sprite.play("idle");
		else if (onGround && velocity.x != 0) sprite.play("walk");
		else if (!onGround && velocity.y < 0) sprite.play("jump");
		else if (!onGround && velocity.y > 0.25) sprite.play("fall");
	}
	
	private function move():Void
	{
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
				if (this._class == "com.patrickgh3.cavespirit.entities.NPCHuman") cast(this, NPCHuman).hadcollision = true; // this is so bad
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
				if (velocity.y > 0)
				{
					onGround = true;
				}
				velocity.y = 0;
			}
			i++;
		}
	}
	
	private function walkRight():Void
	{
		velocity.x = runspeed;
		sprite.flipped = true;
	}
	
	private function walkLeft():Void
	{
		velocity.x = -runspeed;
		sprite.flipped = false;
	}
	
	private function walkStop():Void
	{
		velocity.x = 0;
	}
	
	private function jump():Void
	{
		velocity.y = -jumpspeed;
		onGround = false;
	}
	
}