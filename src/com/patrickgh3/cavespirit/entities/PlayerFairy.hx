package com.patrickgh3.cavespirit.entities;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.patrickgh3.cavespirit.scenes.GameScene;
import com.patrickgh3.cavespirit.Util;

/**
 * Fairy the player controls.
 */
class PlayerFairy extends Fairy
{
	private var partner:PlayerHuman;
	private var count:Int = 0;
	private var fadetime:Int = 420;
	private var holdtime:Int = 60;
	private var distance:Int = 20;
	private var heartcount:Int = 0;
	private var heartspeed:Int = 1;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y, "gfx/fairy.png");
		sprite.flipped = true;
		if (GameScene.human == null) light.scale = 0;
		else partner = GameScene.human;
	}
	
	override public function update():Void
	{
		if (Input.mousePressed)
		{
			super.flyToPoint(Std.int(HXP.camera.x) + Input.mouseX, Std.int(HXP.camera.y) + Input.mouseY);
		}
		
		super.update();
		
		if (partner != null)
		{
			if (Math.pow(x + 4 - (partner.x + 4), 2) + Math.pow(y + 4 - (partner.y + 10), 2) < distance * distance)
			{
				count -= 3;
				if (count < 0) count = 0;
				updateLight();
				
				heartcount++;
				if (heartcount == heartspeed)
				{
					heartcount = 0;
					heartspeed = 40 + Util.randInt(120);
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
	}
	
	private function updateLight():Void
	{
		light.scale = Math.min((fadetime - count + holdtime) / fadetime, 1) * Fairy.maxscale;
	}
	
	private function heart():Void
	{
		if (Math.random() < 0.5) HXP.scene.add(new HeartParticle(x + 4, y + 4, true));
		else HXP.scene.add(new HeartParticle(partner.x + 4, partner.y + 10, false));
	}
	
}