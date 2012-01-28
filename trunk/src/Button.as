package  
{
	import org.flixel.*;
	public class Button extends FlxSprite
	{
		//[Embed(source = "graphics/main.png")] protected var ImgDoor:Class;
		public var text:MyText;
		protected var flashTimer:Number;
		protected var maxFlashTimer:Number;
		protected var flashing:Boolean;
		
		public function Button(X:Number=0,Y:Number=0) 
		{
			super(X, Y);
			//loadGraphic(ImgDoor, false);
			makeGraphic(36, 36,0xffff0000);
			
			text = new MyText(X, Y, width);
		}
		
		override public function update():void
		{
			if (flashing)
			{
				flashTimer += FlxG.elapsed;
				if (flashTimer >= maxFlashTimer)
				{
					flashing = false;
				}
				else
				{
					_alpha = flashTimer / maxFlashTimer; 
				}
			}
			else
			{
				_alpha = 1.0;
			}
			text.update();
			super.update();
		}
		
		override public function draw():void
		{
			super.draw();
			text.draw();
		}
		
		public function setText(words:String):void
		{
			text.text = words;
		}
		
		public function flash(duration:Number=0.5):void
		{
			flashTimer = 0.0;
			flashing = true;
			maxFlashTimer = duration;
		}
		
	}

}