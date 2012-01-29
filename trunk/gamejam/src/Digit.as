package
{
	import org.flixel.*;
	
	public class Digit extends FlxSprite
	{
		[Embed(source = "graphics/countdown.png")] protected var ImgDigits:Class;
		
		private var timer:Number;
		private var speed:Number;
		private var currentNum:int;
		
		public function Digit(X:Number,Y:Number) 
		{
			super(X,Y);
			loadGraphic(ImgDigits, true, false, 5, 5);
			
			//generate animations associated with each frame
			var i:int;
			for (i = 0; i <= 9; i++)
			{
				addAnimation(String(i), [i], 0, false);
			}
			
			play("0");
		}
	}

}