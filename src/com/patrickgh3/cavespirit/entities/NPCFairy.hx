package com.patrickgh3.cavespirit.entities;

/**
 * Non player character fairy.
 */
class NPCFairy extends Fairy
{
	private var message:String;
	private var partner:NPCHuman;

	public function new(x:Int, y:Int, partner:NPCHuman = null, message:String = null) 
	{
		super(x, y);
		this.partner = partner;
		this.message = message;
	}
	
	override public function update():Void
	{
		super.update();
	}
	
}