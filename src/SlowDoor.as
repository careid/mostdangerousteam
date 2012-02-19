package  
{
	import org.flixel.*;
	public class SlowDoor extends Door
	{
		protected const SLOWDOORSPEED:Number = 10;
		
		[Embed(source = "graphics/slow_door.png")] protected var ImgSlowDoor:Class;
		
		public function SlowDoor(X:Number=0,Y:Number=0) 
		{
			super(X, Y);
			loadGraphic(ImgSlowDoor, false);
			disableTime = 0;
		}
		
		override public function switchState(newState:uint):void
		{
			if (state == newState)
			{
				return;
			}
			switch(newState)
			{
				case CLOSING:
					if (state == UP)
					{
						groundHeight = y + height - HINGEMARGIN;
						velocity.y = SLOWDOORSPEED;
					}
					break;
				case OPENING:
					if (state == DOWN)
					{
						hingeHeight = y - height + HINGEMARGIN;
						velocity.y = -SLOWDOORSPEED;
					}
					break;
				case UP:
					velocity.y = 0;
					break;
				case DOWN:
					velocity.y = 0;
					break;
				default:
					break;
			}
			state = newState;
		}
	}
}