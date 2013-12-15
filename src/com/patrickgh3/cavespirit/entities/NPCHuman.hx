package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.patrickgh3.cavespirit.scenes.GameScene;
import com.patrickgh3.cavespirit.Util;

/**
 * Non player character human.
 */
class NPCHuman extends Human
{
	private var behavior:Int;
	private var message:String;
	private var text:Entity;
	private var texthitbox:Entity;
	private var messagecount:Int = -1;
	
	public var hadcollision:Bool;
	
	private var count:Int = 0;
	private var countgoal:Int = 2;
	private var state:Int = state_wait;
	private inline static var state_wait:Int = 0;
	private inline static var state_walk:Int = 1;
	
	public inline static var ai_nothing:Int = 0;
	public inline static var ai_pace:Int = 1;
	
	public function new(x:Int, y:Int, imagesrc:String, behavior:Int, message:String = null) 
	{
		super(x, y, imagesrc);
		this.behavior = behavior;
		this.message = message;
		if (message != null)
		{
			var t:Text = new Text(message, -32, -5);
			t.size = 8;
			text = new Entity(0, 0, t);
			text.layer = -4;
			texthitbox = new Entity();
			texthitbox.width = 48;
			texthitbox.height = 32;
		}
	}
	
	override public function update():Void
	{
		if (behavior != ai_nothing) count++;
		if (count == countgoal)
		{
			if (state == state_wait)
			{
				state = state_walk;
				if (sprite.flipped == true) walkRight();
				else walkLeft();
			}
			else if (state == state_walk)
			{
				state = state_wait;
				walkStop();
			}
			count = 0;
			if (state == state_wait) countgoal = 120 + Util.randInt(120);
			else if (state == state_walk) countgoal = 30 + Util.randInt(30);
		}
		
		hadcollision = false;
		super.update();
		if (hadcollision || !Util.collidelevelmask(this, Util.sign(velocity.x) * 2, 1))
		{
			if (velocity.x > 0) walkLeft();
			else walkRight();
		}
		
		if (message != null)
		{
			texthitbox.x = x - 48;
			texthitbox.y = y - 32;
			text.x = x;
			text.y = y;
		}
		
		if (messagecount >= 0) messagecount++;
		if (messagecount == 60 * 5)
		{
			messagecount = -2;
			HXP.scene.remove(text);
		}
		
		if (texthitbox != null && messagecount == -1
			&& (Util.entityCollide(texthitbox, GameScene.human) || Util.entityCollide(texthitbox, GameScene.fairy)))
		{
			messagecount = 0;
			HXP.scene.add(text);
			count = 0;
			countgoal = 90 + Util.randInt(60);
			state == state_wait;
			sprite.flipped = false;
		}
		
	}
	
}