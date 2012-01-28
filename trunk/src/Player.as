package
{
	import org.flixel.*;

	public class Player extends Character
	{
		[Embed(source="graphics/main.png")] protected var ImgPlayer:Class;
		
		public function Player(X:int,Y:int)
		{
			super(X,Y);
			loadGraphic(ImgPlayer, true, true,26,26);
			super.setup();
			offset.y -= 1;
		}
		
		override public function update():void
		{
			
			goLeft = FlxG.keys.LEFT;
			goRight = FlxG.keys.RIGHT;
			jump = FlxG.keys.justPressed("X");
			super.update();
		}
	}
}