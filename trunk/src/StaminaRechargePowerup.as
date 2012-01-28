package  
{

	/////
	/// Fully recharges the player's stamina when activated.
	/////
	public class StaminaRechargePowerup extends AutoUsePowerup
	{
		
		public function StaminaRechargePowerup() 
		{
			animationName = "stamina";
		}
		
		
		/////
		/// Fully recharges the player's stamina and returns true.
		/////
		override public function activate():Boolean 
		{
			character.stamina = character.maxstamina;
			shouldBeDiscarded = true;
			return true;
		}
		
		
	}

}