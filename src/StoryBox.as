package  
{
	import org.flixel.*;
	public class StoryBox extends FlxSprite
	{
		public var text:String;
		public var level:int;
		
		public function StoryBox(X:Number=0,Y:Number=0) 
		{
			super(X, Y);
		}
		
		public function setup():void
		{
			makeGraphic(width, height);
			alpha = 0.0;
		}
		
	}

}