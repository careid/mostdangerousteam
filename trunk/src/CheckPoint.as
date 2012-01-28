package  
{
	import org.flixel.*;
	public class CheckPoint extends FlxPoint
	{
		public var threshold:Number;
		public var time:Number;
		
		public function CheckPoint(threshold:Number=0,time:Number=0) 
		{
			this.threshold = threshold;
			this.time = time;
		}
		
	}

}