package com.patrickgh3.cavespirit.scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.patrickgh3.cavespirit.entities.*;
import com.patrickgh3.cavespirit.Level;
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
	}
	
	override public function update():Void
	{
		// game logic here
		super.update();
		if (Input.pressed(Key.F)) changeLevel(0);
	}
	
	private function changeLevel(levelindex:Int)
	{
		removeAll();
		
		#if !flash
        var atlas = TextureAtlas.loadTexturePacker("atlas/assets.xml");
		#end
		add(new Entity(0, 0, new Backdrop(#if flash "gfx/background.png" #else atlas.getRegion("background") #end)));
		add(lighting = new Lighting());
		
		Level.loadLevel(levelindex);
	}
	
}