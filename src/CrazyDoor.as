package  
{
	import org.flixel.*;
	public class CrazyDoor extends Door
	{
		protected var INTERVAL:Number = 2.0;
		protected var timer:Number = 0.0;
		
		override protected function setup():void
		{
			super.setup();
			state = UP;
			id = -1;
		}
		
		override public function update():void
		{
			switch (state) {
				case UP:
					timer += FlxG.elapsed;
					if (timer > INTERVAL)
					{
						timer = 0;
						switchState(CLOSING);
					}
					break;
				case DOWN:
					switchState(OPENING);
					break;
				default:
					break;
			}
			super.update();
		}
		
	}

}