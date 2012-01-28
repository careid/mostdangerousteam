package  
{

	import org.flixel.*;
	
	/////
	/// Class used to drop spike traps.
	/////
	public class SpikePowerup extends AmmoPowerup
	{
		
		public function SpikePowerup() 
		{
			super(1);
			animationName = "spikes";
		}
		
		
		override public function activate():Boolean 
		{
			if (super.activate())
			{
				createSpikeTrap();
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function createSpikeTrap(): void
		{
			var offsetX : Number = 0;
			var offsetY : Number = 0;
			var vX : Number = 0;
			var vY : Number = 0;
			
			if (character.facing == FlxObject.LEFT)
			{
				offsetX = -5;
				offsetY = -5;
				vX = -50;
				vY = -100;
			}
			else
			{
				offsetX = 5;
				offsetY = -5;
				vX = 50;
				vY = -100;
			}
			
			var  spikeTrap : SpikeTrap = new SpikeTrap(offsetX + character.x, offsetY + character.y, character.velocity.x + vX, character.velocity.y + vY);
			var playState : PlayState = (PlayState)(FlxG.state);
			playState.spikes.add(spikeTrap);
		}
		
	}

}