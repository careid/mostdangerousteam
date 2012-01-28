package
{
	import adobe.utils.CustomActions;
	import flash.events.TimerEvent;
	import org.flixel.*;
	import flash.utils.Timer;
	
	public class Player extends Hydraman
	{
		protected var m_waypoints:Array;
		protected var m_waypoint_timer:Timer;
		
		public function Player(X:int=0,Y:int=0,level:int=0)
		{
			super(X, Y);
			this.m_level = level;
			m_waypoints = new Array();
			push_waypoint();
			m_waypoint_timer = new Timer(1000);
			m_waypoint_timer.addEventListener(TimerEvent.TIMER, scheduled_waypoint_push);
			m_waypoint_timer.start();
		}
		
		public function timeTravel(X:int,Y:int):Player
		{
			var noob:Player = new Player(X, Y);
			noob.copyPowerups(this);
			return noob;
		}
		
		override public function update():void
		{
			goLeft = FlxG.keys.LEFT;
			goRight = FlxG.keys.RIGHT;
			jump = FlxG.keys.justPressed("X");
			if (jump)
				push_waypoint();
			dash = FlxG.keys.pressed("C");
			usePowerup = FlxG.keys.justPressed("Z");

			super.update();
		}
		
		protected function scheduled_waypoint_push(e:TimerEvent):void
		{
			push_waypoint();
		}
		
		public function push_waypoint():void
		{
			m_waypoints.push(new WayPoint(this, null));
		}
		
		public function get_waypoints():Array
		{
			return m_waypoints;
		}
	}
}