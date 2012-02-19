package  
{
	import org.flixel.*;

	public class Shield extends FlxSprite
	{
		[Embed(source = "./graphics/shield.png")] public var Image:Class;
		
		public static const MAX_LIFESPAN : Number = 0.3;
		public var m_thrower : Character;
		public var lifespan : Number;
		protected var m_trackSpeed : Number = 10;
		
		////
		/// \param X the x position of the shield.
		/// \param Y the y position of the shield.
		/// \param vX the x velocity of the shield.
		/// \param vY the y velocity of the shield.
		/////
		public function Shield(thrower : Character) 
		{
			super(thrower.x, thrower.y + 7);
			loadGraphic(Image, true);
			addAnimation("shield", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 30, true);
			play("shield");
			m_thrower = thrower;
			offset.x = offset.y = 8;
			width = 11;
			height = 11;
			lifespan = MAX_LIFESPAN;
		}
		
		
		override public function update():void 
		{
			if (m_thrower.alive)
			{
				x = m_thrower.x;
				y = m_thrower.y + 7;
				velocity = m_thrower.velocity;
			}
			
			lifespan -= FlxG.elapsed;
			if (lifespan <= 0)
			{
				(FlxG.state as PlayState).shields.remove(this);
				kill();
				m_thrower.m_recharge = 0;
			}
			
			super.update();
		}
		
		////
		/// Callback for operlapping with a character.
		/// \param shield the shield.
		/// \param theCharacter character to check against. If the character is the thrower, resets the shield.
		///        otherwise kills the character.
		////
		public static function overlapCharacter(shield : Shield, theCharacter: Character ) : void
		{
			if (theCharacter != shield.m_thrower && !theCharacter.flickering)
			{
				theCharacter.hit(1, theCharacter.die);
			}
		}
		
		public static function overlapSpikes(shield : Shield, spikes : SpikeTrap) : void
		{
			if (spikes.activation == SpikeTrap.OPEN)
			{
				spikes.activation = SpikeTrap.CLOSING;
				spikes.play("closing");
				trace("CLAP!");
			}
		}
	}

}