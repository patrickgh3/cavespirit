package com.patrickgh3.cavespirit.scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.Scene;
import com.patrickgh3.cavespirit.entities.*;
import flash.display.BlendMode;

/**
 * Main game scene.
 */
class GameScene extends Scene
{

	public function new()
	{
		super();
		add(new PlayerHuman(32, 32));
		add(new PlayerFairy(64, 64));
		
		/*var f:Entity = new Entity(0, 0, Image.createRect(64, 64, 0x000000, 0.5));
		cast(f.graphic, Image).blend = BlendMode.OVERLAY;
		add(f);
		var e:Entity = new Entity(8, 8, Image.createCircle(16, 0xffffff, 0.5));
		cast(e.graphic, Image).blend = BlendMode.SUBTRACT;
		add(e);*/
	}
	
	override public function update():Void
	{
		// game logic here
		super.update();
	}
	
}