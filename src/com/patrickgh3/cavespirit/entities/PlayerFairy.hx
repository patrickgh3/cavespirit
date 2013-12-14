package com.patrickgh3.cavespirit.entities;

import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * Fairy the player controls.
 */
class PlayerFairy extends Fairy
{
	public function new(x:Int, y:Int) 
	{
		super(x, y);
	}
	
	override public function update():Void
	{
		if (Input.mousePressed)
		{
			super.flyToPoint(Input.mouseX, Input.mouseY);
		}
		
		super.update();
	}
	
}