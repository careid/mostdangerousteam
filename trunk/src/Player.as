package
{
	import flash.events.TimerEvent;
	import org.flixel.*;
	import flash.utils.Timer;
	
	public class Player extends Character
	{
		[Embed(source = "graphics/main.png")] protected var ImgPlayer:Class;
		protected var m_waypoints:Array;
		protected var m_waypoint_timer:Timer;
		
		public function Player(X:int,Y:int)
		{
			super(X, Y);
			m_waypoints = new Array();
			push_waypoint();
			m_waypoint_timer = new Timer(1000);
			m_waypoint_timer.addEventListener(TimerEvent.TIMER, scheduled_waypoint_push);
			m_waypoint_timer.start();
			loadGraphic(ImgPlayer, true, true,26,26);
			super.setup();
			offset.y -= 1;
			offset.x = 6;
			width = 15;
		}
		
		override public function update():void
		{
			get_movement();
			super.update();
		}
		
		public function get_movement():void
		{
			goLeft = FlxG.keys.LEFT;
			goRight = FlxG.keys.RIGHT;
			jump = FlxG.keys.justPressed("X");
			dash = FlxG.keys.pressed("C");
		}
		
		protected function scheduled_waypoint_push(e:TimerEvent):void
		{
			push_waypoint();
		}
		
		public function push_waypoint():void
		{
			trace("pushing waypoint...");
			m_waypoints.push(new WayPoint(x, y, width, height, jump, null));
		}
		
		public function get_waypoints():Array
		{
			return m_waypoints;
		}
	}
}