package  
{
	import org.flixel.*;

	public class Boomerang extends FlxSprite
	{
		[Embed(source = "./graphics/boomerang.png")] public var Image:Class;
		
		public var m_thrower : Character;
		protected var m_trackSpeed : Number = 10;
		
		////
		/// \param X the x position of the boomerang.
		/// \param Y the y position of the boomerang.
		/// \param vX the x velocity of the boomerang.
		/// \param vY the y velocity of the boomerang.
		/////
		public function Boomerang(thrower : Character, X : Number, Y : Number, vX : Number , vY : Number) 
		{
			super(X, Y);
			velocity.x = vX;
			velocity.y = vY;
			maxVelocity.x = 500;
			maxVelocity.y = 500;
			loadGraphic(Image, true);
			addAnimation("boomerang", [0, 1, 2], 30, true);
			play("boomerang");
			m_thrower = thrower;
			offset.x = offset.y = 8;
			width = 11;
			height = 11;
		}
				
		////
		/// Callback for operlapping with a character.
		/// \param boomerang the boomerang.
		/// \param theCharacter character to check against. If the character is the thrower, resets the boomerang.
		///        otherwise kills the character.
		////
		public static function overlapCharacter(boomerang : Boomerang, theCharacter: Character ) : void
		{
			var powerup : BoomerangPowerup = (boomerang.m_thrower.getPowerupOfType(BoomerangPowerup) as BoomerangPowerup);
			if (powerup != null)
			{
				powerup.charge = powerup.maxCharge;
			}
			
			var playState : PlayState = (PlayState)(FlxG.state);
			playState.boomerangs.remove(boomerang);
			boomerang.kill();
			
			if (theCharacter != boomerang.m_thrower && !theCharacter.flickering)
			{
				if (powerup != null)
					powerup.ammo -= 1;
				boomerang.m_thrower.m_recharge = 0.5;
				theCharacter.hit(8, theCharacter.die);
			}
			/*if (theCharacter == boomerang.m_thrower)
			{
				var powerup : BoomerangPowerup = (BoomerangPowerup)(theCharacter.getPowerupOfType(BoomerangPowerup));
				if (powerup != null)
				{
					powerup.charge = powerup.maxCharge;
				}
				
				var playState : PlayState = (PlayState)(FlxG.state);
				playState.boomerangs.remove(boomerang);
				boomerang.kill();
			}
			else
			{
				if (!theCharacter.flickering)
				{
					theCharacter.hit(4, theCharacter.die);
				}
			}*/
		}
		
		override public function update():void 
		{
			var diffX : Number = 0;
			var diffY : Number = 0;
			
			if (m_thrower.alive)
			{
				diffX = m_thrower.x - x;
				diffY = m_thrower.y - y;
				
				acceleration.x = m_trackSpeed * diffX - velocity.x;
				acceleration.y = m_trackSpeed * diffY - velocity.y;
			}
			
			super.update();
		}
		
		public static function overlapSpikes(boomerang:Boomerang, spikes : SpikeTrap) : void
		{
			if (spikes.activation == SpikeTrap.OPEN)
			{
				spikes.activation = SpikeTrap.CLOSING;
				spikes.play("closing");
				trace("CLAP!");
			}
		}
		
		public static function overlapShield(boomerang:Boomerang, shield : Shield) : void
		{
			var powerup : BoomerangPowerup = (shield.m_thrower.getPowerupOfType(BoomerangPowerup) as BoomerangPowerup);
			
			if ( shield.m_thrower != boomerang.m_thrower )
			{
				if (powerup == null)
				{
					shield.m_thrower.addPowerup(new BoomerangPowerup());
				}
				else
				{
					powerup.ammo += 1;
					powerup.charge = powerup.maxCharge;
				}
				boomerang.m_thrower.m_recharge = 0.5;
				boomerang.x -= boomerang.velocity.x;
				boomerang.y -= boomerang.velocity.y;
				boomerang.velocity.x *= -1;
				boomerang.velocity.y *= -1;
				boomerang.m_thrower = shield.m_thrower;
			}
		}
	}

}