package com.patrickgh3.cavespirit;

import com.haxepunk.Entity;

/**
 * Holds utility functions.
 */
class Util
{
	
	public static function collidelevelmask(e:Entity, xoffset:Int = 0, yoffset:Int = 0):Bool
	{
		e.x += xoffset;
		e.y += yoffset;
		if (isoffscreen(e))
		{
			e.x -= xoffset;
			e.y -= yoffset;
			return true;
		}
		
		// test the corners of the entity and a few midpoints to see if any are in a solid tile.
		var x1:Int = Math.floor(e.x / Level.tilewidth);
		var x2:Int = Math.floor((e.x + e.width - 1) / Level.tilewidth);
		var x3:Int = Std.int((x1 + x2) / 2);
		var y1:Int = Math.floor(e.y / Level.tileheight);
		var y2:Int = Math.floor((e.y + e.height - 1) / Level.tileheight);
		
		var y4:Int = Std.int((y1 + y2) / 2);
		var y3:Int = Std.int((y4 + y1) / 2);
		var y5:Int = Std.int((y4 + y2) / 2);
		//if (e.x < 0) x1 = -1;
		//if (e.y < 0) y1 = -1;
		//x1 = cast(Math.min(x1, Level.levelwidth), Int);
		//y1 = cast(Math.min(y1, Level.levelheight), Int);
		
		e.x -= xoffset;
		e.y -= yoffset;
		
		return Level.mask[x1][y1] == 1
			|| Level.mask[x1][y2] == 1
			|| Level.mask[x2][y1] == 1
			|| Level.mask[x2][y2] == 1
			|| Level.mask[x3][y1] == 1
			|| Level.mask[x3][y2] == 1
			|| Level.mask[x1][y3] == 1
			|| Level.mask[x1][y4] == 1
			|| Level.mask[x1][y5] == 1
			|| Level.mask[x2][y3] == 1
			|| Level.mask[x2][y4] == 1
			|| Level.mask[x2][y5] == 1;
	}
	
	public static function isoffscreen(e:Entity):Bool
	{
		return e.x < 0
			|| e.y < 0
			|| e.x + e.width - 1 > 800
			|| e.y + e.height - 1 > 600;
		
	}
	
	public static function sign(x:Float):Int
	{
		if (x > 0) return 1;
		else if (x < 0) return -1;
		else return 0;
	}
	
	public static function randInt(n:Int):Int
	{
		return Math.floor(Math.random() * n);
	}
	
	public static function rectCollide(x1:Float, y1:Float, w1:Float, h1:Float,
									   x2:Float, y2:Float, w2:Float, h2:Float):Bool
	{
		return x1 < x2 + w2
			&& x1 + w1 > x2
			&& y1 < y2 + h2
			&& y1 + h1 > y2;
	}
	
	public static function entityCollide(e1:Entity, e2:Entity):Bool
	{
		return rectCollide(e1.x, e1.y, e1.width, e1.height, e2.x, e2.y, e2.width, e2.height);
	}
	
}