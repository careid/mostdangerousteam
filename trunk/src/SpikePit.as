package  
{
	import org.flixel.*;
	public class SpikePit extends FlxSprite
	{	
		[Embed(source = "graphics/conveyor.png")] protected var ImgConveyor:Class;
		
		public function SpikePit(X:Number=0,Y:Number=0) 
		{
			super(X, Y);
			loadGraphic(ImgConveyor, true, false, 32, 32);
			
			addAnimation("go", [3,2,1,0], 12);
			play("go");
			
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
		
		public static function overlap(a:FlxObject, b:Character):void
		{
			b.squash();
		}
	}

}