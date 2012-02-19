package  
{

	import org.flixel.*;
	
	/////
	/// Class used to drop shields
	/////
	public class ShieldPowerup extends AmmoPowerup
	{
		
		public function ShieldPowerup() 
		{
			super(10);
			animationName = "shield";
			continuousUse = true;
		}
		
		
		override public function activate(target:Character = null):Boolean 
		{
			if (super.activate(target))
			{
				createShield(target);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function createShield(target:Character = null): void
		{
			var  shield : Shield = new Shield(character, character.x, character.y, character.velocity.x, character.velocity.y);
			var playState : PlayState = (PlayState)(FlxG.state);
			playState.shields.add(shield);
		}
		
	}

}