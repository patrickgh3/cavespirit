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
		
		var x1:Int = Math.floor(e.x / Level.tilewidth);
		var x2:Int = Math.floor((e.x + e.width - 1) / Level.tilewidth);
		var y1:Int = Math.floor(e.y / Level.tileheight);
		var y2:Int = Math.floor((e.y + e.height - 1) / Level.tileheight);
		//if (e.x < 0) x1 = -1;
		//if (e.y < 0) y1 = -1;
		//x1 = cast(Math.min(x1, Level.levelwidth), Int);
		//y1 = cast(Math.min(y1, Level.levelheight), Int);
		
		e.x -= xoffset;
		e.y -= yoffset;
		
		return Level.mask[x1][y1] == 1
			|| Level.mask[x1][y2] == 1
			|| Level.mask[x2][y1] == 1
			|| Level.mask[x2][y2] == 1;
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
	
}