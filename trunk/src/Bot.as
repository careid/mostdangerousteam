package
{
	import org.flixel.*;

	public class Bot extends Hydraman
	{
		protected var m_waypoints:Array;
		
		public function Bot(old_player:Player)
		{
			super(old_player.x,old_player.y);
			copyPowerups(old_player);
			m_waypoints = new Array();
			for each (var waypoint:WayPoint in old_player.get_waypoints())
				m_waypoints.push(waypoint);
			m_run_level = old_player.m_run_level;
			m_stamina_level = old_player.m_stamina_level;
		}
		
		override public function update():void
		{
			trace(m_waypoints.length);
			if (m_waypoints.length > 0)
			{
				var wp:WayPoint = m_waypoints[0];
				jump =  (y - 30 > wp.y);
				// when you hit a waypoint, move onto the next one
				//var dx:int = wp.x - x;
				//var dy:int = wp.y - y;
				if (overlaps(wp)) //dx*dx + dy*dy < 20)
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
					goLeft  = (x > wp.x);
					goRight = (x < wp.x);
					if (x == wp.x)
						velocity.x = 0;
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