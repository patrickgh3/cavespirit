package com.patrickgh3.cavespirit.scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.patrickgh3.cavespirit.entities.*;
import com.patrickgh3.cavespirit.Level;
import com.patrickgh3.cavespirit.Util;
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
	public static var levelindex:Int;
	public static var sfxMusic:Sfx;
	public static var musicstarted:Bool = false;
	
	public static var muted:Bool = false;
	
	public inline static var prefwidth:Int = 192;
	public inline static var prefheight:Int = 144;
	
	public static var tickcount:Int = 0;
	private var sfxDrip:Sfx;
	private var soundcount:Int = 0;
	private var soundcountgoal:Int = 1;
	
	public static var fairypath:Bool;
	public static var fairypathcompleted:Bool = false;
	public static var humanpathcompleted:Bool = false;
	public static var sv_cheats:Bool = false;

	public function new()
	{
		super();
		fadeoverlay = new FadeOverlay();
		sfxMusic = new Sfx("snd/music.wav");
		sfxDrip = new Sfx("snd/drip.wav");
	}
	
	override public function update():Void
	{
		super.update();
		
		if (levelindex == -4 && Input.pressed(Key.ENTER))
		{
			fadeoverlay.fadeout( -3);
			musicstarted = false;
		}
		
		soundcount++;
		if (soundcount == soundcountgoal)
		{
			soundcount = 0;
			soundcountgoal = 120 + Util.randInt(240);
			sfxDrip.play(0.05);
		}
		
		tickcount++;
		if (tickcount == 5) changeLevel(-3);
		
		if (sv_cheats)
		{
		if (Input.pressed(Key.F)) changeLevel(0);
		else if (Input.pressed(Key.G)) changeLevel(1);
		else if (Input.pressed(Key.DIGIT_2)) changeLevel(2);
		else if (Input.pressed(Key.DIGIT_3)) changeLevel(3);
		else if (Input.pressed(Key.DIGIT_4)) changeLevel(4);
		else if (Input.pressed(Key.DIGIT_5)) changeLevel(5);
		else if (Input.pressed(Key.DIGIT_6)) changeLevel(6);
		else if (Input.pressed(Key.DIGIT_7)) changeLevel(7);
		else if (Input.pressed(Key.DIGIT_8)) changeLevel(8);
		else if (Input.pressed(Key.Y)) changeLevel(-3);
		else if (Input.pressed(Key.C)) changeLevel( -4);
		}
		
		// enable cheats
		if (Input.check(Key.P) && Input.check(Key.J) && Input.check(Key.T))sv_cheats = true;
		
		if (Input.pressed(Key.M))
		{
			if (muted)
			{
				muted = false;
				if (musicstarted && levelindex <= 6) startMusic();
			}
			else if (!muted)
			{
				muted = true;
				sfxMusic.stop();
			}
		}
		
		// camera (todo: smooth?)
		if (fairy == null && human == null)
		{
			//return;
		}
		// only human
		else if (fairy == null)
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
		
		if (Input.pressed(Key.R) && levelindex != 8 && levelindex != -3 && levelindex != -4) fadeoverlay.fadeout(-1);
		
		if (human != null && levelindex == 2 && !musicstarted && human.x > 160)
		{
			human.locked = true;
		}
		
		if (fairy != null && levelindex == 2 && !musicstarted && fairy.x > 160)
		{
			fairy.locked = true;
			fairy.stopTravelling();
		}
		
		if (human != null && fairy != null && levelindex == 2 && fairy.x > 160 && human.x > 160 && !musicstarted)
		{
			human.locked = true;
			fairy.locked = true;
			fairy.flyToPoint(Std.int(human.x) + 8, Std.int(human.y) - 2);
		}
		
		if (human != null && fairy != null && human.locked && fairy.isrecharged())
		{
			human.locked = false;
			fairy.locked = false;
		}
	}
	
	private function setCamera(x:Float, y:Float)
	{
		camera.x = Std.int(x);
		camera.y = Std.int(y);
	}
	
	public function startMusic():Void
	{
		sfxMusic.loop(0.5);
	}
	
	// special levelindex codes
	// -1 : reload the same level
	// -2 : load the next sequential level
	// -3 : load the title level
	// >=0 : Load the specified level
	public function changeLevel(levelindex:Int)
	{
		if (GameScene.levelindex == 0 && levelindex == -2)
		{
			if (fairypath) levelindex = 1;
			else levelindex = 2;
		}
		else if (GameScene.levelindex == 1 && levelindex == -2)
		{
			if (fairypath) levelindex = 2;
			else levelindex = 0;
		}
		else if (GameScene.levelindex == 8)
		{
			levelindex = -4;
			if (fairypath) fairypathcompleted = true;
			else humanpathcompleted = true;
		}
		else
		{
			if (levelindex == -1) levelindex = GameScene.levelindex;
			else if (levelindex == -2) levelindex = GameScene.levelindex + 1;
		}
		
		GameScene.levelindex = levelindex;
		
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