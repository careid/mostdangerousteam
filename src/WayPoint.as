package
{
	import org.flixel.*;

	public class WayPoint extends FlxObject
	{
		public var timeLeft:Number;
		public function WayPoint(player:Player)
		{
			super(player.x, player.y, player.width, player.height);
			timeLeft = player.m_timeLeft;
			velocity = player.velocity;
			acceleration = player.velocity;
		}
	}
}