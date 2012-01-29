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
		
		
		override public function activate(target:Character = null):Boolean 
		{
			if (super.activate(target))
			{
				createSpikeTrap(target);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function createSpikeTrap(target:Character = null): void
		{
			var offsetX : Number = 0;
			var offsetY : Number = 0;
			var vX : Number = 0;
			var vY : Number = 0;
			var throwLeft:Boolean;
			
			if (target == null)
			{
				throwLeft = (character.facing == FlxObject.LEFT);
			}
			else // aim at someone
			{
				throwLeft = (target.x < character.x && character.velocity.x >= 0);
			}
			
			
			if (throwLeft)
			{
				character.facing = FlxObject.LEFT;
				offsetX = -5;
				offsetY = -5;
				vX = -50;
				vY = -100;
			}
			else
			{
				character.facing = FlxObject.RIGHT;
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