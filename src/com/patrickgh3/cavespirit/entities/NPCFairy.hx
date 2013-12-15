package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.patrickgh3.cavespirit.scenes.GameScene;
import com.patrickgh3.cavespirit.Util;
import flash.geom.Point;

/**
 * Non player character fairy.
 */
class NPCFairy extends Fairy
{
	private var message:String;
	private var behavior:Int;
	private inline static var ai_idle:Int = 0;
	private inline static var ai_pace:Int = 1;
	private var text:Entity;
	private var texthitbox:Entity;
	private var messagecount:Int = -1;
	private var count:Int = 0;
	private var countgoal:Int = 1;
	private var center:Point;

	public function new(x:Int, y:Int, imagesrc:String, behavior:Int, message:String = null) 
	{
		super(x, y, imagesrc);
		this.behavior = behavior;
		if (behavior == ai_idle) light.scale = 0;
		center = new Point(x, y);
		this.message = message;
		if (message != null)
		{
			var t:Text = new Text(message, -48, -8);
			t.size = 8;
			text = new Entity(0, 0, t);
			text.layer = -4;
			texthitbox = new Entity();
			texthitbox.width = 64;
			texthitbox.height = 32;
		}
	}
	
	override public function update():Void
	{
		super.update();
		
		if (behavior == ai_pace)
		{
			count++;
			if (count == countgoal)
			{
				flyToPoint(Std.int(center.x) + Util.randInt(24) - 12, Std.int(center.y) + Util.randInt(24) - 12);
				count = 0;
				countgoal = 90 + Util.randInt(60);
			}
		}
		
		if (message != null)
		{
			texthitbox.x = x - 64;
			texthitbox.y = y - 16;
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
			&& ((Util.entityCollide(texthitbox, GameScene.human) || Util.entityCollide(texthitbox, GameScene.fairy))
			|| (GameScene.human.x >= this.x - 8 || GameScene.fairy.x > this.x - 8)))
		{
			messagecount = 0;
			HXP.scene.add(text);
			sprite.flipped = false;
		}
	}
	
}