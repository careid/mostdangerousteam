package  
{
	/////
	/// This kind of powerup has an ammo counter. At each use, the ammo counter is reduced
	/// once it reaches zero, the ammo powerup is discarded.
	/////
	public class AmmoPowerup extends Powerup
	{
		public var ammo : Number;
		
		public function AmmoPowerup(ammo : Number) 
		{
			this.ammo = ammo;
			animationName = "ammo";
		}
		
		
		////
		/// \returns true if the powerup could be used, false if it is out of ammo.
		////
		override public function activate(target:Character = null) : Boolean 
		{
			if (ammo <= 0)
			{
				shouldBeDiscarded = true;
				return false;
			}
			else
			{
				ammo--;
				shouldBeDiscarded = ammo == 0;
				return true;
			}
		}
		
	}

}