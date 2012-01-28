package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class SpikeTrap extends FlxSprite
	{
		[Embed(source = "./graphics/spikes.png")] public var Image:Class;
		public static const CLOSED:uint = 0;
		public static const OPENING:uint = 1;
		public static const OPEN:uint = 2;
		private var activation : uint = CLOSED;
		private var landing_zone : FlxPoint = null;
		
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
			
			loadGraphic(Image, true, false, 36, 36);
			addAnimation("inactive", [0], 0, false);
			addAnimation("activating", [0, 1, 2, 3, 4], 15, false);
			play("inactive");
			offset.x = (36 - 7) / 2;
			offset.y = (36 - 7);
			width  = 7;
			height = 7;

		}

		override public function update():void 
		{
			if(isTouching(FLOOR))
			{
				drag.x = 400;
				drag.y = 400;
			}
			if (activation == CLOSED && Math.abs(velocity.x * velocity.x + velocity.y * velocity.y) < 0.01)
			{
				play("activating");
				width = 34;
				height = 24;
				offset.x = 0;
				offset.y = 36 - height;
				y -= 18;
				x -= 14;
				landing_zone = new FlxPoint(x, y);
				//isActive = true;
				activation = OPENING;
			}
			else if (activation == OPENING)
			{
				if (landing_zone != null && landing_zone.y + 4 < y)
				{
					x = landing_zone.x - 15;
					y = landing_zone.y;
					landing_zone = null;
				}
				if (finished) activation = OPEN;
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
			if (spikes.activation == OPEN)
			{
				theCharacter.hit();
				spikes.kill();
			}
		}
	}

}