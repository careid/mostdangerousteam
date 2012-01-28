package
{
	import org.flixel.*;

	public class Bot extends Hydraman
	{
		protected var m_waypoints:Array;
		
		public function Bot(X:int,Y:int,waypoints:Array)
		{
			super(X, Y);
			m_waypoints = new Array();
			for each (var fuckin_waypoint:WayPoint in waypoints)
			{
				m_waypoints.push(fuckin_waypoint);
			}
		}
		
		override public function update():void
		{
			trace(m_waypoints.length);
			if (m_waypoints.length > 0)
			{
				jump =  (y - 30 > m_waypoints[0].y);
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
			else
			{
				//goLeft = goRight = jump = false;
				goLeft = false;
				goRight = false;
				jump = false;
			}
			super.update();
		}
	}
}