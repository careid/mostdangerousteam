package
{
	import adobe.utils.CustomActions;
	import flash.events.TimerEvent;
	import org.flixel.*;
	import flash.utils.Timer;
	
	public class Player extends Hydraman
	{
		public var startTime:Number;
		
		public function Player(X:int=0,Y:int=0,runLevel:int=3,staminaLevel:int=3,healthLevel:int=3)
		{
			m_run_level = runLevel;
			m_stamina_level = staminaLevel;
			m_health_level = healthLevel;
			super(X, Y,true);
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
			
			var state:int = getState(goLeft, goRight, jump, usePowerup, dash);
			if (m_stateHistory.length < 2 || m_stateHistory[m_stateHistory.length - 1] != state)
			{
				m_stateHistory.push(state);
				m_stateHistory.push(m_timeLeft);
			}

			super.update();
		}		
	}
}