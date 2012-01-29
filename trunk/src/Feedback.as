package 
{
	import flash.display.BitmapData;
	import org.flixel.FlxCamera;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Feedback extends FlxSprite
	{
		protected var buffer:BitmapData;
		
		public function Feedback(X:int, Y:int, buffer:BitmapData)
		{
			super(X, Y, null);
			this.buffer = buffer;
			this.scrollFactor = new FlxPoint(0, 0);
			this.scale = new FlxPoint(.9, .9);
			visible = false;
		}
		
		override public function update():void
		{
			framePixels = buffer.clone();
			super.update();
		}
	}
	
}