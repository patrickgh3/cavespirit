package com.patrickgh3.cavespirit;

import com.haxepunk.graphics.Text;
import com.patrickgh3.cavespirit.scenes.GameScene;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.patrickgh3.cavespirit.entities.*;
import flash.geom.Rectangle;
import openfl.Assets;
import flash.display.BlendMode;

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
		if (levelindex == -3) path = "lvl/leveltitle.oel";
		if (levelindex == -4) path = "lvl/levelcredits.oel";
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
		
		if (levelindex == -3)
		{
			var t:Text = new Text("Spirit Cave");
			t.size = 16;
			t.color = 0x355473;
			var e:Entity = new Entity(48, 40, t);
			HXP.scene.add(e);
			
			var u:Text = new Text("Press M to mute");
			u.size = 8;
			u.color = 0x23384D;
			//HXP.scene.add(new Entity(64 - 4, 112 - 8, u));
			
			y = 96 - 16 + 8;
			x = 56;
			HXP.scene.add(new PlayButton(x, y, true));
			HXP.scene.add(new PlayButton(x + 48, y, false));
			
			y = 64;
			x = 24;
			if (GameScene.fairypathcompleted)
			{
				var e:Entity = new Entity(x, y, new Image("gfx/ghosthuman.png"));
				cast(e.graphic, Image).alpha = 0.6;
				cast(e.graphic, Image).blend = BlendMode.LIGHTEN;
				HXP.scene.add(e);
			}
			if (GameScene.fairypathcompleted && GameScene.humanpathcompleted)
			{
				var e:Entity = new Entity(x + 32, y + 8, new Image("gfx/ghostheart.png"));
				cast(e.graphic, Image).alpha = 0.6;
				cast(e.graphic, Image).blend = BlendMode.LIGHTEN;
				HXP.scene.add(e);
			}
			if (GameScene.humanpathcompleted)
			{
				var e:Entity = new Entity(x + 64, y + 8, new Image("gfx/ghostfairy.png"));
				cast(e.graphic, Image).alpha = 0.6;
				cast(e.graphic, Image).blend = BlendMode.LIGHTEN;
				HXP.scene.add(e);
			}
			
		}
		else if (levelindex == -4)
		{
			var t:Text = new Text("Spirit Cave");
			t.size = 8;
			t.color = 0x355473;
			HXP.scene.add(new Entity(48, 24, t));
			
			t = new Text("a game by Patrick Traynor");
			t.size = 8;
			t.color = 0x355473;
			HXP.scene.add(new Entity(48, 48, t));
			
			t = new Text("powered by HaxePunk");
			t.size = 8;
			t.color = 0x355473;
			HXP.scene.add(new Entity(48, 56, t));
			
			t = new Text("Thank you for playing.");
			t.size = 8;
			t.color = 0x355473;
			HXP.scene.add(new Entity(48, 56, t));
		}
		else if (levelindex == 1)
		{
			HXP.scene.add(new Entity(64, 184, new Image("gfx/hint1.png")));
			HXP.scene.add(new Entity(144 - 4, 200, new Image("gfx/hint2.png")));
		}
		else if (levelindex == 0)
		{
			HXP.scene.add(new Entity(80, 80, new Image("gfx/hint3.png")));
		}
		
		// load entities
		for (layer in xml.elementsNamed("entities"))
		{
			for (ent in layer.elementsNamed("Torch"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y"));
				var scale:Float = Std.parseFloat(ent.get("scale"));
				if (levelindex == -3 && y > 72) x += 4;
				HXP.scene.add(new Torch(x, y, scale));
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
				var b:Int = Std.parseInt(ent.get("behavior"));
				HXP.scene.add(new NPCFairy(x, y, s, b, m));
			}
			for (ent in layer.elementsNamed("PlayerHuman"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y")) + 4;
				if (levelindex == 8 && GameScene.fairypath) continue;
				HXP.scene.add(GameScene.human = new PlayerHuman(x, y));
			}
			for (ent in layer.elementsNamed("PlayerFairy"))
			{
				x = Std.parseInt(ent.get("x"));
				y = Std.parseInt(ent.get("y"));
				if (levelindex == 8 && !GameScene.fairypath) continue;
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