package  
{
	import org.flixel.*;
	public class DoorSwitch extends FlxSprite
	{
		public static const DOWN:uint = 0;
		public static const UP:uint = 1;
		
		public var state:uint = UP;
		
		protected var door:Door;
		
		public var id:int;
		
		[Embed(source = "graphics/button.png")] protected var ImgDoor:Class;
		
		public function DoorSwitch(X:Number=0,Y:Number=0) 
		{
			super(X, Y);
			loadGraphic(ImgDoor, true, false, 32, 32);
			addAnimation("up", [0]);
			addAnimation("down", [1]);
		}
		
		public function connectDoor(doors:FlxGroup):void
		{
			var d:Door;
			var i:int;
			for (i = 0; i < doors.length; i++)
			{
				d = doors.members[i];
				if (d.id == id)
				{
					door = d;
				}
			}
		}
		
		override public function update():void
		{
			switch(state)
			{
				case DOWN:
					play("down");
					break;
				case UP:
					play("up");
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
				case DOWN:
					if (state == UP)
					{
						if (door)
						{
							door.switchState(Door.OPENING);
						}
						else
						{
							trace("no door");
						}
					}
					break;
				case UP:
					break;
				default:
					break;
			}
			state = newState;
		}
		
		public static function overlap(a:FlxObject, b:FlxObject):void
		{
			DoorSwitch(a).switchState(DOWN);
		}
		
	}

}