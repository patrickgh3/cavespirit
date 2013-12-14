package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.patrickgh3.cavespirit.Util;

/**
 * Non player character human.
 */
class NPCHuman extends Human
{
	private var behavior:Int;
	private var message:String;
	private var text:Entity;
	
	public var hadcollision:Bool;
	
	private var count:Int = 0;
	private var countgoal:Int = 1;
	private var state:Int = state_wait;
	private inline static var state_wait:Int = 0;
	private inline static var state_walk:Int = 1;
	
	public inline static var ai_nothing:Int = 0;
	public inline static var ai_pace:Int = 1;
	
	public function new(x:Int, y:Int, behavior:Int, message:String = null) 
	{
		super(x, y);
		this.behavior = behavior;
		this.message = message;
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
			if (state == state_wait) countgoal = 90 + Util.randInt(120);
			else if (state == state_walk) countgoal = 40 + Util.randInt(60);
		}
		
		hadcollision = false;
		super.update();
		if (hadcollision || !Util.collidelevelmask(this, Util.sign(velocity.x) * 2, 1))
		{
			if (velocity.x > 0) walkLeft();
			else walkRight();
		}
		
	}
	
}