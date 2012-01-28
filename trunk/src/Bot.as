package
{
	import org.flixel.*;

	public class Bot extends Hydraman
	{
		protected var canFuckUp:Boolean;
		
		public function Bot(old_player:Player)
		{
			super(old_player.startX, old_player.startY);
			canFuckUp = false;
			copyPowerups(old_player);
			m_stateHistory = new Array();
			for each (var thing in old_player.m_stateHistory)
				m_stateHistory.push(thing);
			m_waypoints = new Array();
			for each (var waypoint:WayPoint in old_player.get_waypoints())//m_waypoints)
			{
				//trace("Pushing waypoint ", waypoint.x, waypoint.y, waypoint.timeLeft);
				m_waypoints.push(waypoint);
			}
			m_run_level = old_player.m_run_level;
			m_stamina_level = old_player.m_stamina_level;
			m_timeLeft = old_player.startTime;
		}
		
		override public function update():void
		{
			if (m_stateHistory.length > 1)
			{
				var state:int = m_stateHistory[0];
				var time:Number = m_stateHistory[1];
				if (time >= m_timeLeft)
				{
					m_stateHistory.shift();
					m_stateHistory.shift();
					setState(state);
				}
			}
			
			if (m_waypoints.length > 0)
			{
				var wp:WayPoint = m_waypoints[0];
				//trace("Waypoint: ", wp.x, wp.y, wp.timeLeft);
				//trace("My point: ", x, y, m_timeLeft);
				// when you hit a waypoint, move onto the next one
				if (!canFuckUp && wp.timeLeft >= m_timeLeft)
				{
					trace("TELEPORT!");
					x = wp.x;
					y = wp.y;
				}
				if (overlaps(wp))
				{
					var hit:WayPoint = m_waypoints.shift();
				}
				if (m_waypoints.length > 0)
				{
					if (x == wp.x)
						velocity.x = 0;
				}
			}
	
			
			super.update();
		}
	}
}