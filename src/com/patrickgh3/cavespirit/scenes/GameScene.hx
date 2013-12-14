package com.patrickgh3.cavespirit.scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.Scene;
import com.patrickgh3.cavespirit.entities.*;
import flash.display.BlendMode;

/**
 * Main game scene.
 */
class GameScene extends Scene
{
	public static var lighting:Lighting;

	public function new()
	{
		super();
		
		#if !flash
        var atlas = TextureAtlas.loadTexturePacker("atlas/assets.xml");
		#end
		add(new Entity(0, 0, new Backdrop(#if flash "gfx/background.png" #else atlas.getRegion("background") #end)));
		
		add(lighting = new Lighting());
		lighting.add(new Light(20, 20, 1, 1));
		
		var h:PlayerHuman = new PlayerHuman(32, 32);
		h.layer = -2;
		add(h);
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