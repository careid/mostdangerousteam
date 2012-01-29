package 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxCamera;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
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
			width = 320;
			height = 240;
			
			x = (width - scale.x * width) / 2;
			y = (height - scale.y * height) / 2;
		}
		
		override public function update():void
		{
			framePixels = buffer.clone();
			
			//scale = new FlxPoint(scale.x * 0.999, scale.y * 0.999);
			super.update();
		}
	}
	
}