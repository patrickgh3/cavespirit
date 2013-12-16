package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.patrickgh3.cavespirit.scenes.GameScene;

/**
 * Black rectangle which does the fade transitions.
 */
class FadeOverlay extends Entity
{
	public var count:Int = 0;
	private var fadetime:Int = 40;
	private var image:Image;
	public var state:Int;
	public inline static var state_idle:Int = 0;
	private inline static var state_fadeout:Int = 1;
	private inline static var state_fadein:Int = 2;
	private var targetlevel:Int = -1;

	public function new() 
	{
		super(0, 0);
		graphic = image = Image.createRect(196 + 4, 144 + 4, 0x000000);
		image.alpha = 0;
		layer = -4;
	}
	
	override public function update():Void
	{
		x = HXP.camera.x - 2;
		y = HXP.camera.y - 2;
		
		if (state == state_fadeout)
		{
			count++;
			image.alpha = count / fadetime;
			if (count == fadetime)
			{
				state = state_idle;
				count = 0;
				image.alpha = 1;
				cast(HXP.scene, GameScene).changeLevel(targetlevel);
			}
		}
		if (state == state_fadein)
		{
			count++;
			image.alpha = (fadetime - count) / fadetime;
			if (count == fadetime)
			{
				state = state_idle;
				count = 0;
				image.alpha = 0;
			}
		}
	}
	
	public function fadeout(targetlevel:Int):Void
	{
		//if (GameScene.levelindex == -3) fadetime = 180;
		//else fadetime = 40;
		this.targetlevel = targetlevel;
		if (state != state_idle) return;
		state = state_fadeout;
		image.alpha = 0;
		
	}
	
	public function fadein():Void
	{
		if (state != state_idle) return;
		state = state_fadein;
		image.alpha = 1;
	}
}