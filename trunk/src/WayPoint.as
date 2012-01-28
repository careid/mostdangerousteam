package
{
	import org.flixel.*;

	public class WayPoint extends FlxObject
	{
		public var powerup:Powerup;
		public var jump:Boolean;
		public function WayPoint(X:int,Y:int,W:int,H:int,jmp:Boolean,pu:Powerup)
		{
			super(X, Y, W, H);
			powerup = pu;
			jump = jmp;
		}
	}
}