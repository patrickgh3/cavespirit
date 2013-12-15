package com.patrickgh3.cavespirit;

import com.patrickgh3.cavespirit.scenes.GameScene;
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
		rect = new Rectangle(0, 0, tilewidth, tileheight);
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
				//if (x == 0 || x == levelwidth - 1 || y == 0 || y == levelheight - 1) mask[x][y] = 1;
				//else mask[x][y] = 0;
				mask[x][y] = 0;
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
				y = Std.parseInt(ent.get("y")) + 4;
				HXP.scene.add(new Torch(x, y));
			}
			for (ent in layer.elementsNamed("NPCHuman"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y"));
				var b:Int = Std.parseInt(ent.get("behavior"));
				var m:String = ent.get("message");
				if (m == "none") m = null;
				var s:String = ent.get("sprite");
				HXP.scene.add(new NPCHuman(x, y, s, b, m));
			}
			for (ent in layer.elementsNamed("NPCFairy"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y"));
				var m:String = ent.get("message");
				if (m == "none") m = null;
				var s:String = ent.get("sprite");
				HXP.scene.add(new NPCFairy(x, y, s, null, m)); // TODO: partner fairies!
			}
			for (ent in layer.elementsNamed("PlayerHuman"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y")) + 4;
				HXP.scene.add(GameScene.human = new PlayerHuman(x, y));
			}
			for (ent in layer.elementsNamed("PlayerFairy"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y"));
				HXP.scene.add(GameScene.fairy = new PlayerFairy(x, y));
			}
			for (ent in layer.elementsNamed("DeathTrigger"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y"));
				var width:Int = Std.parseInt(ent.get("width"));
				var height:Int = Std.parseInt(ent.get("height"));
				var e:Entity = new Entity(x, y);
				e.width = width;
				e.height = height;
				e.type = "deathtrigger";
				HXP.scene.add(e);
			}
			for (ent in layer.elementsNamed("LevelTrigger"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y"));
				var width:Int = Std.parseInt(ent.get("width"));
				var height:Int = Std.parseInt(ent.get("height"));
				var e:Entity = new Entity(x, y);
				e.width = width;
				e.height = height;
				e.type = "leveltrigger";
				HXP.scene.add(e);
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
				mask[x][y] = 1;
				if (tx == 0 && ty == 0) continue;
				
				rect.x = tx * tilewidth;
				rect.y = ty * tilewidth;
				var g:Graphic = new Image("gfx/tileset.png", rect);
				var e:Entity = new Entity(x * 8, y * 8, g);
				HXP.scene.add(e);
			}
		}
		for (layer in xml.elementsNamed("tiles"))
		{
			for (tile in layer.elementsNamed("tile"))
			{
				tx = Std.parseInt(tile.get("tx"));
				ty = Std.parseInt(tile.get("ty"));
				x = Std.parseInt(tile.get("x"));
				y = Std.parseInt(tile.get("y"));
				if (!(tx == 0 && ty == 0)) continue;
				
				var top:Bool = checkmask(x, y - 1) == 1;
				var bottom:Bool = checkmask(x, y + 1) == 1;
				var left:Bool = checkmask(x - 1, y) == 1;
				var right:Bool = checkmask(x + 1, y) == 1;
				var topleft:Bool = checkmask(x - 1, y - 1) == 1;
				var topright:Bool = checkmask(x + 1, y - 1) == 1;
				var bottomleft:Bool = checkmask(x - 1, y + 1) == 1;
				var bottomright:Bool = checkmask(x + 1, y + 1) == 1;
				
				// surrounded
				if (top && bottom && left && right)
				{
					rect.x = 1 + Util.randInt(3);
					rect.y = 0;
				}
				// corners
				else if (!top && !left)
				{
					rect.x = 0;
					rect.y = 2;
				}
				else if (!top && !right)
				{
					rect.x = 1;
					rect.y = 2;
				}
				else if (!bottom && !left)
				{
					rect.x = 2;
					rect.y = 2;
				}
				else if (!bottom && !right)
				{
					rect.x = 3;
					rect.y = 2;
				}
				// edges
				else if (!top)
				{
					rect.x = 0;
					rect.y = 1;
				}
				else if (!bottom)
				{
					rect.x = 1;
					rect.y = 1;
				}
				else if (!left)
				{
					rect.x = 2;
					rect.y = 1;
				}
				else if (!right)
				{
					rect.x = 3;
					rect.y = 1;
				}
				rect.x *= tilewidth;
				rect.y *= tileheight;
				var g:Graphic = new Image("gfx/tileset.png", rect);
				var e:Entity = new Entity(x * 8, y * 8, g);
				HXP.scene.add(e);
			}
		}
	}
	
	private static function checkmask(x:Int, y:Int):Int
	{
		if (x < 0 || x >= levelwidth || y < 0 || y >= levelheight) return 1;
		else return mask[x][y];
	}
	
}