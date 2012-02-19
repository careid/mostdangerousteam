package
{
	import org.flixel.*;

	public class Bot extends Hydraman
	{
		[Embed(source = "sounds/explosion.mp3")] public var ExplosionSnd:Class;
		
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
			
			FlxG.play(ExplosionSnd);
		}
		
		override public function update():void
		{
			if (m_stateHistory.length >= 2)
			{
				var state:int = m_stateHistory[0];
				var time:Number = m_stateHistory[1];
				if (time >= (FlxG.state as PlayState).timeLeft)
				{
					m_stateHistory.shift();
					m_stateHistory.shift();
					setState(state);
				}
			}
			/*else
			{
				setState(0);
			}*/
			
			if (m_waypoints.length > 0)
			{
				var timeLeft:Number = (FlxG.state as PlayState).timeLeft;
				var wp:WayPoint = m_waypoints[0];
				//trace("Waypoint: ", wp.x, wp.y, wp.timeLeft);
				//trace("My point: ", x, y, timeLeft);
				// when you hit a waypoint, move onto the next one
				if (!canFuckUp && wp.timeLeft >= timeLeft && !onScreen() && !wp.onScreen())
				{
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
			
			var playState:PlayState = (FlxG.state as PlayState);
			var player:Character = playState.player;
			// weapons
			if (m_currentPowerup != null)
			{
				if (playState.level.tileMap.ray(player.origin,this.origin))
				{
					var dx:Number = player.x - x;
					var dy:Number = player.y - y;
					if (m_currentPowerup.animationName == "shield" && dx * dx + dy * dy <= 100 * 100)
					{
						activateCurrentPowerup();
					}
					else if (m_currentPowerup.animationName == "taser" && dx * dx + dy * dy <= 20 * 20)
					{
						activateCurrentPowerup();
					}
					else if (m_currentPowerup.animationName == "boomerang" && Math.random() < 0.01 && dx * dx + dy * dy <= 100 * 100)
					{
						activateCurrentPowerup(player);
					}
				}
				else if (m_currentPowerup.animationName == "spikes" && Math.random() < 0.01)
				{
					var dx:Number = player.x - x;
					var dy:Number = player.y - y;
					
					if ((dx > 0) == (velocity.x > 0))
					{ // 2 tiles ahead
						if (dx*dx+dy*dy <= 64*64)
							activateCurrentPowerup(player);
					}
					else
					{ // 3 tiles behind
						if (dx*dx+dy*dy <= 96*96)
							activateCurrentPowerup(player);
					}
				}
			}
			
			super.update();
		}
	}
}