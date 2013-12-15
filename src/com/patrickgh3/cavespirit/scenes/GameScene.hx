package com.patrickgh3.cavespirit.scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.HXP;
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
	public static var human:PlayerHuman;
	public static var fairy:PlayerFairy;
	public static var fadeoverlay:FadeOverlay;
	public var levelindex:Int;
	
	public inline static var prefwidth:Int = 192;
	public inline static var prefheight:Int = 144;

	public function new()
	{
		super();
		fadeoverlay = new FadeOverlay();
	}
	
	override public function update():Void
	{
		super.update();
		
		if (Input.pressed(Key.F)) changeLevel(0);
		else if (Input.pressed(Key.G)) changeLevel(1);
		else if (Input.pressed(Key.DIGIT_2)) changeLevel(2);
		else if (Input.pressed(Key.DIGIT_3)) changeLevel(3);
		
		// camera (todo: smooth?)
		if (fairy == null && human == null) return;
		// only human
		if (fairy == null)
		{
			setCamera(human.x - prefwidth / 2, human.y - prefheight / 2);
		}
		// only fairy
		else if (human == null)
		{
			setCamera(fairy.x - prefwidth / 2, fairy.y - prefheight / 2);			
		}
		// if both within preferred rect, then we're happy. just move the camera to center both.
		//else if (Math.abs(fairy.x - human.x) < prefwidth - 20 && Math.abs(fairy.y - human.y) < prefheight - 20)
		else
		{
			camera.x = Std.int((fairy.x + human.x) / 2 - prefwidth / 2);
			camera.y = Std.int((fairy.y + human.y) / 2 - prefheight / 2);
		}
		
		camera.x = Math.max(0, camera.x);
		camera.x = Math.min(Level.levelwidth * Level.tilewidth - prefwidth, camera.x);
		camera.y = Math.max(0, camera.y);
		camera.y = Math.min(Level.levelheight * Level.tileheight - prefheight, camera.y);
		
		if (Input.pressed(Key.R)) fadeoverlay.fadeout(-1);
	}
	
	private function setCamera(x:Float, y:Float)
	{
		camera.x = Std.int(x);
		camera.y = Std.int(y);
	}
	
	// special levelindex codes
	// -1 : reload the same level
	// -2 : load the next sequential level
	// >=0 : Load the specified level
	public function changeLevel(levelindex:Int)
	{
		if (levelindex == -1) levelindex = this.levelindex;
		else if (levelindex == -2) levelindex = this.levelindex + 1;
		this.levelindex = levelindex;
		
		removeAll();
		fairy = null;
		human = null;
		
		#if !flash
        var atlas = TextureAtlas.loadTexturePacker("atlas/assets.xml");
		#end
		add(new Entity(0, 0, new Backdrop(#if flash "gfx/background.png" #else atlas.getRegion("background") #end)));
		add(lighting = new Lighting());
		
		Level.loadLevel(levelindex);
		
		add(fadeoverlay);
		fadeoverlay.fadein();
	}
	
}