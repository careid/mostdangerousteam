package  
{

	/////
	/// A powerup which has no ammo, but rather a charging rate.
	/////
	public class ChargingPowerup extends AmmoPowerup
	{
		public var charge : Number;
		public var maxCharge : Number;
		public var chargeRate : Number;
		
		public function ChargingPowerup(maxCharge : Number=0, chargeRate : Number=0) 
		{
			super(1);
			this.maxCharge = maxCharge;
			this.charge = maxCharge;
			this.chargeRate = chargeRate;
			animationName = "charging";
		}
		
		
		/////
		/// \return true if could activate, false otherwise.
		/////
		override public function activate(target:Character = null) : Boolean 
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
		
		override public function update():void 
		{
			charge += chargeRate;
			if (charge > maxCharge)
			{
				charge = maxCharge;
			}
			super.update();
		}
		
	}

}