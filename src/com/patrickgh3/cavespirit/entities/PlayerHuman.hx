package com.patrickgh3.cavespirit.entities;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.patrickgh3.cavespirit.scenes.GameScene;

/**
 * Human the player controls.
 */
class PlayerHuman extends Human
{
	public function new(x:Int, y:Int) 
	{
		super(x, y, "gfx/human.png");
		sprite.flipped = true;
	}
	
	override public function update():Void
	{
		var right:Bool = Input.check(Key.D);
		var left:Bool = Input.check(Key.A);
		var jump:Bool = Input.pressed(Key.W) || Input.pressed(Key.SPACE);
		
		if (right) super.walkRight();
		else if (left) super.walkLeft();
		else super.walkStop();
		
		if (jump && onGround)
		{
			super.jump();
			onGround = false;
		}
		
		super.update();
		
		// todo: if collision with death trigger, call fadeout.
		//if (Input.pressed(Key.R)) GameScene.fadeoverlay.fadeout(-1);
	}
	
}