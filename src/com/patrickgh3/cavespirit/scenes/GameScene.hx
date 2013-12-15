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
	
	public inline static var prefwidth:Int = 256;
	public inline static var prefheight:Int = 192;

	public function new()
	{
		super();
	}
	
	override public function update():Void
	{
		super.update();
		
		if (Input.pressed(Key.T)) changeLevel(-1);
		else if (Input.pressed(Key.F)) changeLevel(0);
		else if (Input.pressed(Key.G)) changeLevel(1);
		else if (Input.pressed(Key.DIGIT_2)) changeLevel(2);
		
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
	}
	
	private function setCamera(x:Float, y:Float)
	{
		camera.x = Std.int(x);
		camera.y = Std.int(y);
	}
	
	private function changeLevel(levelindex:Int)
	{
		removeAll();
		fairy = null;
		human = null;
		
		#if !flash
        var atlas = TextureAtlas.loadTexturePacker("atlas/assets.xml");
		#end
		add(new Entity(0, 0, new Backdrop(#if flash "gfx/background.png" #else atlas.getRegion("background") #end)));
		add(lighting = new Lighting());
		
		Level.loadLevel(levelindex);
	}
	
}