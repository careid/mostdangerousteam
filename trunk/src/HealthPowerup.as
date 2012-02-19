package  
{

	/////
	/// Fully recharges the player's stamina when activated.
	/////
	public class HealthPowerup extends AutoUsePowerup
	{
		
		public function HealthPowerup() 
		{
			animationName = "health";
		}
		
		
		/////
		/// Refill half of the player's health
		/////
		override public function activate(target:Character = null):Boolean 
		{
			character.health = Math.min(character.max_health, character.health + character.max_health / 2);
			character.stamina = character.maxstamina;
			shouldBeDiscarded = true;
			return true;
		}
		

		
		
	}

}