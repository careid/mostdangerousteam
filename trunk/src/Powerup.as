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
		public var shouldBeDiscarded : Boolean;
				
		public function Powerup() 
		{
			shouldBeDiscarded = false;
		}
		
		/////
		/// Override this to activate the effect of the powerup.
		/// \return true if the powerup could be activated, false otherwise.
		/////
		public function activate() : Boolean 
		{
			return true;
		}
		
		/////
		/// Updates the powerup. Recharges if necessary.
		/////
		public function update() : void
		{
		}
		
		/////
		/// Called when a powerup is added to a character.
		/////
		public function onAdd() : void
		{
			
		}
		
	}
	

}