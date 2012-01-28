package
{
	import org.flixel.*;

	public class WayPoint extends FlxPoint
	{
		public var powerup:Powerup;
		public var jump:Boolean;
		public function WayPoint(X:int,Y:int,jmp:Boolean,pu:Powerup)
		{
			super(X, Y);
			powerup = pu;
			jump = jmp;
		}
	}
}