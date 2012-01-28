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
		/////
		public function activate() : void 
		{
			
		}
	}
	

}