package com.patrickgh3.cavespirit.entities;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.patrickgh3.cavespirit.scenes.GameScene;

/**
 * Human the player controls.
 */
class PlayerHuman extends Human
{
	public var locked:Bool = false;
	private var jumpdisabled:Bool = false;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y, "gfx/human.png");
		sprite.flipped = true;
	}
	
	override public function update():Void
	{
		if (locked)
		{
			sprite.play("idle");
			velocity.x = velocity.y = 0;
			return;
		}
		
		var right:Bool = Input.check(Key.D);
		var left:Bool = Input.check(Key.A);
		var jump:Bool = Input.pressed(Key.W) || Input.pressed(Key.SPACE);
		if (jumpdisabled) jump = false;
		
		if (right) super.walkRight();
		else if (left) super.walkLeft();
		else super.walkStop();
		
		if (jump && onGround)
		{
			super.jump();
			onGround = false;
		}
		
		super.update();
		
		if (collide("deathtrigger", x, y) != null)
		{
			GameScene.fadeoverlay.fadeout(-1);
		}
		
		if (collide("leveltrigger", x, y) != null)
		{
			GameScene.fadeoverlay.fadeout(-2);
		}
		
		if (GameScene.levelindex == 7 && GameScene.fairypath && x > 193) jumpdisabled = true;
		
		if (GameScene.levelindex == 7 && GameScene.fairypath && x >= 220 && GameScene.fadeoverlay.state == FadeOverlay.state_idle)
		{
			HXP.scene.remove(this);
			HXP.scene.add(new DyingHuman(Std.int(x) - 6, 104));
			GameScene.fairy.partner = null;
		}
	}
	
}