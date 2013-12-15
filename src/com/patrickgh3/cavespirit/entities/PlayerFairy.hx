package com.patrickgh3.cavespirit.entities;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * Fairy the player controls.
 */
class PlayerFairy extends Fairy
{
	public function new(x:Int, y:Int) 
	{
		super(x, y, "gfx/fairy.png");
	}
	
	override public function update():Void
	{
		if (Input.mousePressed)
		{
			super.flyToPoint(Std.int(HXP.camera.x) + Input.mouseX, Std.int(HXP.camera.y) + Input.mouseY);
		}
		
		super.update();
	}
	
}