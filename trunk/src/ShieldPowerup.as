package  
{

	import org.flixel.*;
	
	/////
	/// Class used to drop shields
	/////
	public class ShieldPowerup extends AmmoPowerup
	{
		protected var shield : Shield = null;
		
		public function ShieldPowerup() 
		{
			super(10);
			animationName = "shield";
			continuousUse = true;
		}
		
		
		override public function activate(target:Character = null):Boolean 
		{
			if (character.m_recharge == 0 && super.activate(target))
			{
				if (shield == null || shield.lifespan <= 0)
				{
					createShield(target);
				}
				else
				{
					shield.lifespan = Shield.MAX_LIFESPAN;
				}
				character.m_recharge = 0.25;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function createShield(target:Character = null): void
		{
			shield = new Shield(character);
			(FlxG.state as PlayState).shields.add(shield);
			character.m_recharge = 0.1;
		}
		
	}

}