package
{
	import org.flixel.*;
	
	public class Hydraman extends Character
	{
		[Embed(source = "graphics/main.png")] protected var ImgHydraman:Class;
		
		protected static const LEFT_SHIFT:int    = 0;
		protected static const RIGHT_SHIFT:int   = 1;
		protected static const JUMP_SHIFT:int    = 2;
		protected static const POWERUP_SHIFT:int = 3;
		protected static const DASH_SHIFT:int    = 4;
		
		protected static const LEFT_MASK:int    = 1 << LEFT_SHIFT;
		protected static const RIGHT_MASK:int   = 1 << RIGHT_SHIFT;
		protected static const JUMP_MASK:int    = 1 << JUMP_SHIFT;
		protected static const POWERUP_MASK:int = 1 << POWERUP_SHIFT;
		protected static const DASH_MASK:int    = 1 << DASH_SHIFT;
		
		public var m_run_level:int = 0;
		public var m_stamina_level:int = 0;
		public var m_health_level:int = 0;
		public var m_timeLeft:Number;
		public static var m_initialTimeLeft:Number;
		
		public var m_stateHistory:Array;
		public var m_waypoints:Array;
		public var startX:Number;
		public var startY:Number;
		
		public function Hydraman(X:int,Y:int,soundOn:Boolean = false)
		{
			super(X, Y, soundOn);
			startX = X;
			startY = Y;
			loadGraphic(ImgHydraman, true, true,26,26);
			super.setup(60+m_run_level*5,120+m_run_level*10,0.1+m_stamina_level*0.1,100+m_stamina_level*10,10+m_health_level*5);
			offset.y -= 1;
			offset.x = 6;
			width = 15;
			m_timeLeft = m_initialTimeLeft;
			m_stateHistory = new Array();
		}
		
		protected function setState(state:int):void {
			goLeft = new Boolean(LEFT_MASK & state);
			goRight = new Boolean(RIGHT_MASK & state);
			jump = new Boolean(JUMP_MASK & state);
			usePowerup = new Boolean(POWERUP_MASK & state);
			dash = new Boolean(DASH_MASK & state);
		}
		
		protected function getState(isLeft:Boolean, isRight:Boolean, isJump:Boolean, isPowerup:Boolean, isDash:Boolean):int
		{
			var ret:int = 0;
			if (isLeft) ret |= LEFT_MASK;
			if (isRight) ret |= RIGHT_MASK;
			if (isJump) ret |= JUMP_MASK;
			if (isPowerup) ret |= POWERUP_MASK;
			if (isDash) ret |= DASH_MASK;
			return ret;
		}
		
		override public function update():void
		{
			super.update();
			m_timeLeft -= FlxG.elapsed;
		}
		
		override public function kill() : void
		{
			// Spawn an eye.
			var eye : Eye = new Eye(x + 5, y + 12);
			if (facing != FlxObject.RIGHT)
			{
				eye.x = x + 2;
			}
			eye.acceleration.y = 400;
			(FlxG.state as PlayState).level.eyes.add(eye);
			super.kill();
		}
	}
}