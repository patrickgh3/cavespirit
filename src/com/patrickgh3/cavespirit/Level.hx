package com.patrickgh3.cavespirit;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.patrickgh3.cavespirit.entities.*;
import flash.geom.Rectangle;
import openfl.Assets;

/**
 * Holds info for the level.
 */
class Level
{
	public static var mask:Array<Array<Int>>;
	
	public inline static var tilewidth:Int = 8;
	public inline static var tileheight:Int = 8;
	public static var levelwidth:Int;
	public static var levelheight:Int;
	
	private static var rect:Rectangle;
	
	public static function init():Void
	{
		rect = new Rectangle();
	}
	
	public static function loadLevel(levelindex:Int):Void
	{
		var tx:Int;
		var ty:Int;
		var x:Int;
		var y:Int;
		var path:String = "lvl/level" + Std.string(levelindex) + ".oel";
		var xml:Xml = Xml.parse(Assets.getText(path)).firstElement();
		
		levelwidth = cast(Std.parseInt(xml.get("width")) / tilewidth, Int);
		levelheight = cast(Std.parseInt(xml.get("height")) / tileheight, Int);
		
		// initialize mask
		mask = new Array<Array<Int>>();
		x = 0;
		while (x < levelwidth)
		{
			mask.push(new Array<Int>());
			y = 0;
			while (y < levelheight)
			{
				if (x == 0 || x == levelwidth - 1 || y == 0 || y == levelheight - 1) mask[x][y] = 1;
				else mask[x][y] = 0;
				y++;
			}
			x++;
		}
		
		// load entities
		for (layer in xml.elementsNamed("entities"))
		{
			for (ent in layer.elementsNamed("Torch"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y"));
				HXP.scene.add(new Torch(x, y));
			}
			for (ent in layer.elementsNamed("NPCHuman"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y"));
				var b:Int = Std.parseInt(ent.get("behavior"));
				var m:String = ent.get("message");
				HXP.scene.add(new NPCHuman(x, y, b, m));
			}
			for (ent in layer.elementsNamed("NPCFairy"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y"));
				var m:String = ent.get("message");
				HXP.scene.add(new NPCFairy(x, y, null, m)); // TODO: partner fairies!
			}
			for (ent in layer.elementsNamed("PlayerHuman"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y"));
				HXP.scene.add(new PlayerHuman(x, y));
			}
			for (ent in layer.elementsNamed("PlayerFairy"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y"));
				HXP.scene.add(new PlayerFairy(x, y));
			}
			
		}
		
		// load tiles
		for (layer in xml.elementsNamed("tiles"))
		{
			for (tile in layer.elementsNamed("tile"))
			{
				tx = Std.parseInt(tile.get("tx"));
				ty = Std.parseInt(tile.get("ty"));
				x = Std.parseInt(tile.get("x"));
				y = Std.parseInt(tile.get("y"));
				rect.x = tx * tilewidth;
				rect.y = ty * tilewidth;
				rect.width = tilewidth;
				rect.height = tileheight;
				var g:Graphic = new Image("gfx/tileset.png", rect);
				var e:Entity = new Entity(x * 8, y * 8, g);
				HXP.scene.add(e);
				mask[x][y] = 1;
			}
		}
	}
	
}