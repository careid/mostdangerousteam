package  
{
	import org.flixel.*;
	public class Door extends FlxSprite
	{
		public static const CLOSING:uint = 0;
		public static const OPENING:uint = 1;
		public static const CHILL:uint = 2;
		
		public var state:uint = CHILL;
		
		protected const DOORSPEED:Number = 100;
		protected const HINGEMARGIN:Number = 3;
		
		public var closing:Boolean = false;
		protected var hingeHeight:Number;
		protected var groundHeight:Number;
		
		[Embed(source = "graphics/main.png")] protected var ImgDoor:Class;
		
		public function Door(X:Number,Y:Number) 
		{
			super(X, Y);
			//loadGraphic(ImgDoor, false);
			makeGraphic(36, 36);
			
			setup();
		}
		
		protected function setup():void
		{
			immovable = true;
			
			hingeHeight = y - height + HINGEMARGIN;
			groundHeight = y;
		}
		
		override public function update():void
		{
			switch(state)
			{
				case OPENING:
					if (y < hingeHeight)
					{
						y = hingeHeight;
						switchState(CHILL);
					}
					break;
				case CLOSING:
					if (y > groundHeight)
					{
						y = groundHeight
						switchState(CHILL);
					}
					break;
				default:
					break;
			}
			super.update();
		}
		
		public function switchState(newState:uint):void
		{
			if (state == newState)
			{
				return;
			}
			state = newState;
			switch(newState)
			{
				case CLOSING:
					velocity.y = DOORSPEED;
					break;
				case CHILL:
					velocity.y = 0;
					break;
				case OPENING:
					velocity.y = -DOORSPEED;
					break;
				default:
					break;
			}
		}
		
	}

}