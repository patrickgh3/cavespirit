package com.patrickgh3.cavespirit.entities;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * Human the player controls.
 */
class PlayerHuman extends Human
{
	public function new(x:Int, y:Int) 
	{
		super(x, y);
	}
	
	override public function update():Void
	{
		var right:Bool = Input.check(Key.D);
		var left:Bool = Input.check(Key.A);
		var jump:Bool = Input.pressed(Key.W);
		
		if (right) super.walkRight();
		else if (left) super.walkLeft();
		else super.walkStop();
		
		if (jump && onGround)
		{
			super.jump();
			onGround = false;
		}
		
		super.update();
	}
	
}