package  
{
	import org.flixel.*;
	public class CheckPoint 
	{
		public var position:FlxPoint;
		public var threshold:Number;
		public var time:Number;
		public function CheckPoint(position:FlxPoint,threshold:Number,time:Number) 
		{
			this.position = position;
			this.threshold = threshold;
			this.time = time;
		}
		
	}

}