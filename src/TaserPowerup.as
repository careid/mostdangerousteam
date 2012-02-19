package  
{

	import org.flixel.*;
	
	/////
	/// Class used to drop taser traps.
	/////
	public class TaserPowerup extends AmmoPowerup
	{
		
		public function TaserPowerup() 
		{
			super(20); // 20 ammo per powerup
			animationName = "taser";
			continuousUse = true;
		}
		
		
		override public function activate(target:Character = null):Boolean 
		{
			if (super.activate(target))
			{
				trace("Spark!");
				createTaserSpark(target);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function createTaserSpark(target:Character = null): void
		{
			var  taserSpark : TaserSpark = new TaserSpark(character);
			var playState : PlayState = (PlayState)(FlxG.state);
			playState.sparks.add(taserSpark);
			character.m_recharge = 0.5;
		}
		
	}

}