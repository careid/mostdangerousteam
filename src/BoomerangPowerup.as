package  
{
	import org.flixel.*;
	/////
	/// This powerup allows the player to throw a boomeraing to kill enemies.
	/// The boomerang returns to the player, then the powerup recharges.
	/////
	public class BoomerangPowerup extends ChargingPowerup
	{
		
		public function BoomerangPowerup()
		{
			super(100, 0);
			animationName = "boomerang";
		}
		
		
		/////
		/// Creates a boomerang if fully charged. Otherwise, doesn't.
		/////
		override public function activate(target:Character = null) : Boolean 
		{
			if (super.activate(target))
			{
				createBoomerang(target);
				return true;
			}
			
			return false;
		}
		
		/////
		/// Creates a boomerang facing away from the character. The boomerang
		/// will return to the character, and the boomerang power will recharge.
		/////
		protected function createBoomerang(target:Character = null) : void
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
				throwLeft = (target.x < character.x);
			}
			
			
			if (throwLeft)
			{
				character.facing = FlxObject.LEFT;
				offsetX = -30;
				vX = -500;
			}
			else
			{
				character.facing = FlxObject.RIGHT;
				offsetX = 20;
				vX = 500;
			}
			
			var  boomerang : Boomerang = new Boomerang(character, offsetX + character.x, offsetY + character.y, character.velocity.x + vX, character.velocity.y);
			var playState : PlayState = (PlayState)(FlxG.state);
			playState.boomerangs.add(boomerang);
		}
		
		
	}

}