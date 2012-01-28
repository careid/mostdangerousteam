package  
{
	import org.flixel.FlxSprite;

	/////
	/// Class Powerup is used to enhance the properties of the player
	/// when it is picked up. Powerups can only be used once.
	//////
	public class Powerup
	{
		public var character : Character;
		public var charge : Number;
		public var maxCharge : Number;
		public var chargeRate : Number;
		
		public function Powerup(maxCharge : Number, chargeRate : Number) 
		{
			this.maxCharge = maxCharge;
			this.charge = maxCharge;
			this.chargeRate = chargeRate;
		}
		
		/////
		/// Override this to activate the effect of the powerup.
		/// \return true if the powerup could be activated, false otherwise.
		/////
		public function activate() : Boolean 
		{
			if (isCharged())
			{
				charge = 0;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		////
		/// Returns whether or not the powerup is charged.
		/// \return true if the powerup is fully charged, false otherwise.
		////
		public function isCharged() : Boolean
		{
			return charge >= maxCharge;
		}
		
		/////
		/// Updates the powerup. Recharges if necessary.
		/////
		public function update() : void
		{
			charge += chargeRate;
			if (charge > maxCharge)
			{
				charge = maxCharge;
			}
		}
	}
	

}