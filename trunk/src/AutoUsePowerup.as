package  
{

	public class AutoUsePowerup extends Powerup
	{
		
		public function AutoUsePowerup() 
		{
			
		}
		
	
		/////
		/// Auto-use powerups are activated automatically when added.
		/////
		override public function onAdd():void 
		{
			activate();
			shouldBeDiscarded = true;
			super.onAdd();
		}
		
	}

}