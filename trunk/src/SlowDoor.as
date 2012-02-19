package  
{
	import org.flixel.*;
	public class SlowDoor extends Door
	{
		override protected const DOORSPEED:Number = 10;
		
		[Embed(source = "graphics/slow_door.png")] protected var ImgSlowDoor:Class;
		
		public function SlowDoor(X:Number=0,Y:Number=0) 
		{
			super(X, Y);
			loadGraphic(ImgSlowDoor, false);
			disableTime = 0;
		}
	}
}