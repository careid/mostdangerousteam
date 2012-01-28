package  
{
	import org.flixel.*;
	public class Conveyor extends FlxSprite
	{	
		[Embed(source = "graphics/main.png")] protected var ImgConveyor:Class;
		
		public function Conveyor(X:Number=0,Y:Number=0) 
		{
			super(X, Y);
			//loadGraphic(ImgConveyor, false);
			makeGraphic(32, 32);
			
			facing = RIGHT;
			immovable = true;
		}
		
		public function getShift(s:FlxSprite):void
		{
			if (facing == RIGHT)
			{
				s.x -= 100 * FlxG.elapsed;
			}
			else if (facing == LEFT)
			{
				s.x += 100 * FlxG.elapsed;
			}
		}
		
		public static function overlap(a:FlxObject, b:FlxObject):void
		{
			Conveyor(a).getShift(FlxSprite(b));
		}
	}

}