package
{
	import org.flixel.*;

	public class Bot extends Player
	{
		public function Bot(X:int,Y:int,waypoints:Array)
		{
			super(X, Y);
			m_waypoints = waypoints;
		}
		
		override public function get_movement():void
		{
			if (m_waypoints.length > 0)
			{
				jump = (y - 10 > m_waypoints[0].y);
				// when you hit a waypoint, move onto the next one
				if (overlaps(m_waypoints[0]))
				{
					var hit:WayPoint = m_waypoints.shift();
					jump = hit.jump;
					if (hit.powerup != null)
					{
						hit.powerup.activate();
					}
				}
				if (m_waypoints.length > 0)
				{
					goLeft = (x > m_waypoints[0].x);
					goRight = (x < m_waypoints[0].x);
				}
			}
		}
	}
}