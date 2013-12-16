package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.patrickgh3.cavespirit.scenes.GameScene;

/**
 * Button on title screen.
 */
class PlayButton extends Entity
{
	private static var clicked:Bool = false;
	private var fairy:Bool;
	
	public function new(x:Int, y:Int, fairy:Bool) 
	{
		super(x, y);
		this.fairy = fairy;
		graphic = new Image("gfx/button1.png");
		width = 32;
		height = 16;
		clicked = false;
	}
	
	override public function update():Void
	{
		if (!clicked && Input.mousePressed && GameScene.fadeoverlay.state == FadeOverlay.state_idle
			&& Input.mouseX >= x && Input.mouseX < x + width
			&& Input.mouseY >= y && Input.mouseY < y + height)
		{
			clicked = true;
			if (fairy)
			{
				GameScene.fairypath = true;
				GameScene.fadeoverlay.fadeout(0);
			}
			else
			{
				GameScene.fairypath = false;
				GameScene.fadeoverlay.fadeout(1);
			}
			graphic = new Image("gfx/button2.png");
		}
	}
	
}