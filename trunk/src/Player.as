package
{
	import adobe.utils.CustomActions;
	import flash.events.TimerEvent;
	import org.flixel.*;
	import flash.utils.Timer;
	
	public class Player extends Hydraman
	{
		public var startTime:Number;
		public var numEyes:Number;
		protected var m_waypoint_timer:Timer;
		
		public function Player(X:int=0,Y:int=0,runLevel:int=3,staminaLevel:int=3,healthLevel:int=3)
		{
			m_run_level = runLevel;
			m_stamina_level = staminaLevel;
			m_health_level = healthLevel;
			m_waypoints = new Array();
			m_waypoint_timer = new Timer(1000);
			m_waypoint_timer.addEventListener(TimerEvent.TIMER, scheduled_waypoint_push);
			m_waypoint_timer.start();
			
			
			numEyes = 0;
			super(X, Y, true);
			push_waypoint();
		}
		
		override public function destroy():void
		{
			m_waypoint_timer.stop();
			super.destroy();
		}
		
		public function timeTravel(X:int,Y:int,runLevel:int,staminaLevel:int,healthLevel:int):Player
		{
			var noob:Player = new Player(X, Y,runLevel,staminaLevel,healthLevel);
			noob.copyPowerups(this);
			return noob;
		}
		
		override public function update():void
		{
			goLeft = FlxG.keys.LEFT;
			goRight = FlxG.keys.RIGHT;
			jump = FlxG.keys.justPressed("X");
			dash = FlxG.keys.pressed("C");
			usePowerup = FlxG.keys.justPressed("Z");
			if (FlxG.keys.justPressed("DOWN"))
			{
				cyclePowerups();
			}
			
			var state:int = getState(goLeft, goRight, jump, usePowerup, dash);
			if (m_stateHistory.length < 2 || m_stateHistory[m_stateHistory.length - 1] != state)
			{
				m_stateHistory.push(state);
				m_stateHistory.push(m_timeLeft);
			}


			super.update();
		}
		
		protected function scheduled_waypoint_push(e:TimerEvent):void
		{
			push_waypoint();
		}
		
		public function push_waypoint():void
		{
			m_waypoints.push(new WayPoint(this));
		}
		
		public function get_waypoints():Array
		{
			return m_waypoints;
		}

	}
}