package com.patrickgh3.cavespirit.entities;

import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.patrickgh3.cavespirit.scenes.GameScene;
import com.patrickgh3.cavespirit.Util;

/**
 * Fairy the player controls.
 */
class PlayerFairy extends Fairy
{
	public var partner:PlayerHuman;
	private var count:Int = 0;
	private var fadetime:Int = 360;
	private var holdtime:Int = 60;
	private var distance:Int = 20;
	private var heartcount:Int = 0;
	private var heartspeed:Int = 1;
	private var sfxHeart1:Sfx;
	private var sfxHeart2:Sfx;
	public var locked:Bool = false;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y, "gfx/fairy.png");
		sprite.flipped = true;
		if (GameScene.human == null) light.scale = 0;
		else
		{
			partner = GameScene.human;
			if (GameScene.levelindex == 2)
			{
				count = holdtime + fadetime;
				light.scale = 0;
			}
		}
		sfxHeart1 = new Sfx("snd/heart1.wav");
		sfxHeart2 = new Sfx("snd/heart2.wav");
	}
	
	override public function update():Void
	{
		if (GameScene.fadeoverlay.state == 1 && GameScene.fadeoverlay.count == 68) HXP.scene.remove(this);
		if (Input.mousePressed && !locked)
		{
			super.flyToPoint(Std.int(HXP.camera.x) + Input.mouseX, Std.int(HXP.camera.y) + Input.mouseY);
		}
		
		super.update();
		
		if (partner != null)
		{
			if (Math.pow(x + 4 - (partner.x + 4), 2) + Math.pow(y + 4 - (partner.y + 10), 2) < distance * distance)
			{
				count -= 4;
				if (count < 0) count = 0;
				updateLight();
				
				heartcount++;
				if (heartcount == heartspeed)
				{
					heartcount = 0;
					heartspeed = 30 + Util.randInt(60);
					heart();
				}
			}
			else
			{
				if (count < holdtime + fadetime) count++;
				updateLight();
				heartcount = heartspeed - 1;
			}
		}
		
		if (partner == null && count < holdtime + fadetime && GameScene.levelindex == 7)
		{
			count++;
			updateLight();
			heartcount = 0;
		}
		
		if (collide("leveltrigger", x, y) != null)
		{
			GameScene.fadeoverlay.fadeout(-2);
		}
		
		if (GameScene.levelindex == 2 && count < holdtime + fadetime && GameScene.musicstarted == false && GameScene.fadeoverlay.state == FadeOverlay.state_idle)
		{
			cast(HXP.scene, GameScene).startMusic();
			GameScene.musicstarted = true;
		}
		
		if (GameScene.levelindex == 7 && !GameScene.fairypath && x >= 220 && GameScene.fadeoverlay.state == FadeOverlay.state_idle)
		{
			HXP.scene.remove(this);
			HXP.scene.add(new DyingFairy(Std.int(x) - 3, Std.int(y) - 3));
		}
	}
	
	private function updateLight():Void
	{
		light.scale = Math.min((fadetime - count + holdtime) / fadetime, 1) * Fairy.maxscale;
	}
	
	private function heart():Void
	{
		if (Math.random() < 0.5)
		{
			HXP.scene.add(new HeartParticle(x + 4, y + 4, true));
			sfxHeart1.play(0.25);
		}
		else
		{
			HXP.scene.add(new HeartParticle(partner.x + 4, partner.y + 10, false));
			sfxHeart2.play(0.25);
		}
	}
	
	public function isrecharged():Bool
	{
		return count <= 4;
	}
	
	public function stopTravelling():Void
	{
		travelling = false;
		movingextra = false;
	}
	
}