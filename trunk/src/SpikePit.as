package  
{
	import org.flixel.*;
	public class SpikePit extends FlxSprite
	{	
		[Embed(source = "graphics/spikepit.png")] protected var ImgSpikepit:Class;
		
		public function SpikePit(X:Number=0,Y:Number=0) 
		{
			super(X, Y);
			loadGraphic(ImgSpikepit, true, false, 32, 32);
			
			addAnimation("go", [1, 2, 3, 0], 12, false);
			addAnimation("stop", [0], 12, false);
			play("go");
			
		}
		
		override public function update():void
		{
			if (finished && Math.random() < 0.1)
			{
				play("go");
			}
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