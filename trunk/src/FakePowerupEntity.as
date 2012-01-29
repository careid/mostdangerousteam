package  
{
	import org.flixel.*;
	
	public class FakePowerupEntity extends PowerupEntity
	{
		public var owner:Character;
		
		public function FakePowerupEntity(X:Number, Y:Number, character:Character)
		{
			super(X, Y);
			owner = character;
		}
		
		override public function collect(character : Character) : Powerup
		{
			if (character != owner) {
				character.canFuckUp = true;
			}
			return null;
		}	
	}

}