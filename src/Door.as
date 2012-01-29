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
		
		public var id:int;
		
		[Embed(source = "graphics/door.png")] protected var ImgDoor:Class;
		
		public function Door(X:Number=0,Y:Number=0) 
		{
			super(X, Y);
			loadGraphic(ImgDoor, false);
		}
		
		public function setup():void
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
			if (state == newState)
			{
				return;
			}
			switch(newState)
			{
				case CLOSING:
					if (state == UP)
					{
						groundHeight = y + height-HINGEMARGIN;
						velocity.y = DOORSPEED;
					}
					break;
				case OPENING:
					if (state == DOWN)
					{
						hingeHeight = y - height + HINGEMARGIN;
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
		
		public static function crush(a:FlxObject,b:FlxObject):void 
		{
			var d:Door = Door(a);
			var c:Character = Character(b);
			if (d.state == CLOSING)
			{
				if (c.x + c.offset.x + c.width > d.x + d.offset.x && c.x + c.offset.x < d.x + d.offset.x + d.width && c.y > d.y)
				{
					c.squash();
				}
			}
		}
		
	}

}