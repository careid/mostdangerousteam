package
{
	import org.flixel.*;

	public class WayPoint extends FlxObject
	{
		public var timeLeft:Number;
		public function WayPoint(player:Player)
		{
			super(player.x, player.y, player.width, player.height);
			timeLeft = (FlxG.state as PlayState).timeLeft;
			velocity = player.velocity;
			acceleration = player.velocity;
		}
	}
}