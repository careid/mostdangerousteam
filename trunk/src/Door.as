package  
{
	import org.flixel.*;
	public class Door extends FlxSprite
	{
		public static const CLOSING:uint = 0;
		public static const OPENING:uint = 1;
		public static const DOWN:uint = 2;
		public static const UP:uint = 3;
		
		public var state:uint = DOWN;
		
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
						switchState(UP);
					}
					break;
				case CLOSING:
					if (y > groundHeight)
					{
						y = groundHeight
						switchState(DOWN);
					}
					break;
				default:
					break;
			}
			super.update();
		}
		
		public function switchState(newState:uint):void
		{
			switch(newState)
			{
				case CLOSING:
					if (state != DOWN)
					{
						velocity.y = DOORSPEED;
					}
					break;
				case OPENING:
					if (state != UP)
					{
						velocity.y = -DOORSPEED;
					}
					break;
				case UP:
					velocity.y = 0;
					break;
				case DOWN:
					velocity.y = 0;
					break;
				default:
					break;
			}
			state = newState;
		}
		
	}

}