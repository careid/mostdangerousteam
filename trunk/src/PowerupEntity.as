package
{
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
			character.addPowerup(powerup);
			powerup.onAdd();
			return powerup;
		}
		
		
	}
}