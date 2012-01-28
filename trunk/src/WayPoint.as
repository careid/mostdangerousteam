package
{
	import org.flixel.*;

	public class WayPoint extends FlxObject
	{
		public var powerup:Powerup;
		public var jump:Boolean;
		public var timeLeft:Number;
		
		public function WayPoint(player:Player,pu:Powerup)
		{
			super(player.x, player.y, player.width, player.height);
			powerup = pu;
			jump = player.jump;
			velocity = player.velocity;
			acceleration = player.velocity;
			timeLeft = player.m_timeLeft;
		}
	}
}