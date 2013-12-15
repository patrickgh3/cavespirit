package com.patrickgh3.cavespirit.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.patrickgh3.cavespirit.scenes.GameScene;

/**
 * Non player character fairy.
 */
class NPCFairy extends Fairy
{
	private var message:String;
	private var partner:NPCHuman;
	private var text:Entity;
	private var texthitbox:Entity;
	private var messagecount:Int = -1;

	public function new(x:Int, y:Int, partner:NPCHuman = null, message:String = null) 
	{
		super(x, y);
		this.partner = partner;
		this.message = message;
		if (message != null)
		{
			var t:Text = new Text(message, -48, -5);
			t.size = 8;
			text = new Entity(0, 0, t);
			text.layer = -2;
			texthitbox = new Entity();
			texthitbox.width = 64;
			texthitbox.height = 32;
		}
	}
	
	override public function update():Void
	{
		super.update();
		
		texthitbox.x = x - 64;
		texthitbox.y = y - 32;
		text.x = x;
		text.y = y;
		
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
			trace("a");
		}
	}
	
}