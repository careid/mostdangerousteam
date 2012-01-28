package
{
	import org.flixel.*;

	public class WayPoint extends FlxObject
	{
		public var powerup:Powerup;
		public var jump:Boolean;
		public function WayPoint(player:Player,pu:Powerup)
		{
			super(player.x - player.width/2 - 1, player.y - player.height/2 - 1, 2, 2);//player.width, player.height);
			powerup = pu;
			jump = player.jump;
			velocity = player.velocity;
			acceleration = player.velocity;
		}
	}
}