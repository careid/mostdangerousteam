package
{
	import org.flixel.FlxSprite;
	//////
	/// Class PowerupEntity is an entity in the world that, when touched, is collected by the player.
	/// The player then has a copy of this powerup.
	/////
	public class PowerupEntity extends FlxSprite
	{
		[Embed(source = "./graphics/powerups.png")] public var Image:Class;
		
		public var powerup : Powerup;
		
		public function PowerupEntity(X : Number=0, Y : Number=0,  powerup : Powerup=null)
		{
			super(X, Y);
			this.powerup  = powerup;
			loadGraphic(Image, true, false, 14, 14, false);
			addAnimation("boomerang", [0]);
			addAnimation("doublejump", [1]);
			addAnimation("stamina", [2]);
			addAnimation("spikes", [3]);
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
			this.kill();
			return powerup;
		}
		
		////
		/// Callback for operlapping with a character.
		/// \param powerupEntity powerup to be collected.
		/// \param theCharacter character to collect the powerup.
		////
		public static function overlapCharacter(powerupEntity : PowerupEntity, theCharacter: Character ) : void
		{
			powerupEntity.collect(theCharacter);
		}
		
	}
}