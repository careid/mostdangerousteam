package  
{
	import org.flixel.*;
	public class DoorSwitch extends FlxSprite
	{
		public static const DOWN:uint = 0;
		public static const UP:uint = 1;
		
		public var state:uint = UP;
		
		protected var door:Door;
		
		protected var id:int;
		
		[Embed(source = "graphics/main.png")] protected var ImgDoor:Class;
		
		public function DoorSwitch(X:Number=0,Y:Number=0) 
		{
			super(X, Y);
			//loadGraphic(ImgDoor, false);
			makeGraphic(36, 36);
		}
		
		public function connectDoor(doors:Array):void
		{
			var d:Door;
			var i:int;
			for (i = 0; i < doors.length; i++)
			{
				d = doors[i];
				if (d.ID == id)
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
					break;
				case UP:
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
		
	}

}