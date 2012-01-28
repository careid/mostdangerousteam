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
	
	//////
	/// Class PowerupEntity is an entity in the world that, when touched, is collected by the player.
	/// The player then has a copy of this powerup.
	/////
	public class PowerupEntity extends FlxSprite
	{
		public var powerup : Powerup;
		
		public function PowerupEntity(X : Number, Y : Number, simpleGraphic : Class,  powerup : Powerup)
		{
			this.powerup  = powerup;
			super(X, Y, simpleGraphic);
		}
	
		/////
		/// Set's the powerup's character field to the provided character. Returns the powerup.
		/// \param character, the character collecting the powerup.
		/////
		public function collect(character : Character) : Powerup
		{
			powerup.character = character;
			return powerup;
		}
		
		
	}

}