package  
{
	import flash.utils.Timer;
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
		protected var disableTime:Number;
		
		public var id:int;
		
		[Embed(source = "graphics/door.png")] protected var ImgDoor:Class;
		
		public function Door(X:Number=0,Y:Number=0) 
		{
			super(X, Y);
			loadGraphic(ImgDoor, false);
			disableTime = 0;
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
			if (disableTime > 0)
			{
				disableTime -= FlxG.elapsed;
				if (disableTime <= 0)
				{
					allowCollisions = ANY;
				}
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
						groundHeight = y + height - HINGEMARGIN;
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
		
		public static function crush(a:FlxObject, b:FlxObject):void 
		{
			var d:Door;
			var c:Character;
			if (a is Door)
			{
				d = a as Door;
				c = b as Character;
			}
			else
			{
				d = b as Door;
				c = a as Character;
			}
			if (d.state == CLOSING)
			{
				if (c.y > d.y)
				{
					d.allowCollisions = UP;
					d.disableTime = 0.5;
					c.hit(19, c.squash);
					c.velocity.x = 0;
					c.velocity.y = 0;
				}
			}
		}
		
	}

}