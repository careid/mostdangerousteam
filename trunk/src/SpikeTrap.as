package  
{
	import org.flixel.FlxSprite;

	public class SpikeTrap extends FlxSprite
	{
		[Embed(source = "./graphics/spikes.png")] public var Image:Class;
		private var isActive : Boolean = false;
		
		/////
		/// \param X x position of the spike trap.
		/// \param Y y position of the spike trap.
		/// \param vX x velocity of the spike trap.
		/// \param vY y velocity of the spike trap.
		/////
		public function SpikeTrap(X : Number, Y : Number, vX : Number , vY : Number) 
		{
			super(X, Y);
			velocity.x = vX;
			velocity.y = vY;
			acceleration.y = 400;
			
			loadGraphic(Image, true);
			addAnimation("inactive", [0], 0, false);
			addAnimation("activating", [0, 1, 2, 3, 4], 15, false);
			play("inactive");
			offset.x = (width - 10) / 2;
			offset.y = (height - 7);
			width = 10;
			height = 7;

		}

		override public function update():void 
		{
			if(isTouching(FLOOR))
			{
				drag.x = 400;
				drag.y = 400;
			}
			if (!isActive && Math.abs(velocity.x * velocity.x + velocity.y * velocity.y) < 0.01)
			{
				play("activating");
				width = 34;
				height = 24;
				offset.x = 1;
				offset.y = 12;
				y -= 20;
				isActive = true;
			}
			super.update();
		}
		
		
		////
		/// Callback for operlapping with a character.
		/// \param spikes the spikes.
		/// \param theCharacter character to check against. Kills immediately.
		////
		public static function overlapCharacter(spikes : SpikeTrap, theCharacter: Character ) : void
		{
			if (spikes.isActive)
			{
				theCharacter.kill();
				spikes.kill();
			}
		}
	}

}