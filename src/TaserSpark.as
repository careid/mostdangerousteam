package  
{
	import org.flixel.*;

	public class TaserSpark extends FlxSprite
	{
		[Embed(source = "./graphics/taserspark.png")] public var Image:Class;
		
		protected var m_thrower : Character;
		protected var m_trackSpeed : Number = 10;
		protected static const OFFSET_RIGHT : Number = 15;
		protected static const OFFSET_LEFT : Number = -14;
		protected static const OFFSET_TOP : Number = 8;
		private var done : Boolean;
		
		////
		/// \param X the x position of the taserSpark.
		/// \param Y the y position of the taserSpark.
		/// \param vX the x velocity of the taserSpark.
		/// \param vY the y velocity of the taserSpark.
		/////
		public function TaserSpark(thrower : Character) 
		{
			if (thrower.facing == FlxObject.RIGHT)
				x = thrower.x + OFFSET_RIGHT;
			else
				x = thrower.x + OFFSET_LEFT;
			y = thrower.y + OFFSET_TOP;
			super(x, y);
			loadGraphic(Image, true);
			addAnimation("taserSpark", [0, 1, 2], 30, false);
			play("taserSpark");
			m_thrower = thrower;
			width = 11;
			height = 11;
			done = false;
			update();
		}
		
		override public function update():void 
		{
			if (m_thrower.facing == FlxObject.RIGHT)
				x = m_thrower.x + OFFSET_RIGHT;
			else
				x = m_thrower.x + OFFSET_LEFT;
			y = m_thrower.y + OFFSET_TOP;
			
			if (done)
			{
				(FlxG.state as PlayState).sparks.remove(this);
				kill();
				m_thrower.m_recharge = 0;
			}
			if (finished)
				done = true;
			
			super.update();
		}
		
		////
		/// Callback for operlapping with a character.
		/// \param taserSpark the taserSpark.
		/// \param theCharacter character to check against. If the character is the thrower, resets the taserSpark.
		///        otherwise kills the character.
		////
		public static function overlapCharacter(taserSpark : TaserSpark, theCharacter: Character ) : void
		{
			var powerup : TaserPowerup = (taserSpark.m_thrower.getPowerupOfType(TaserPowerup) as TaserPowerup);
			
			if (theCharacter != taserSpark.m_thrower && !theCharacter.flickering)
			{
				(FlxG.state as PlayState).sparks.remove(taserSpark);
				taserSpark.kill();
				if (powerup != null)
					powerup.ammo -= 10;
				taserSpark.m_thrower.m_recharge = 0.5;
				theCharacter.electrocute();
			}
		}
		
		public static function overlapBoomerang(spark : TaserSpark, boomerang:Boomerang) : void
		{
			spark.m_thrower.electrocute();
			(FlxG.state as PlayState).sparks.remove(spark);
			spark.kill();
		}
		
		public static function overlapShield(spark : TaserSpark, shield : Shield) : void
		{
			shield.m_thrower.electrocute();
		}
	}

}