package  
{
	import org.flixel.*;
	public class Button extends FlxSprite
	{
		[Embed(source = "graphics/storebuttons.png")] protected var ImgButton:Class;
		public var counter:Counter;
		protected var flashTimer:Number;
		protected var maxFlashTimer:Number;
		protected var flashing:Boolean;
		
		public function Button(X:Number=0,Y:Number=0,mode:String="Run") 
		{
			super(X, Y);
			loadGraphic(ImgButton, true, false,59,70);
			
			addAnimation("Run", [0]);
			addAnimation("Fuel", [1]);
			addAnimation("Health", [2]);
			
			counter = new Counter(X+37, Y+52);
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
			counter.update();
			super.update();
		}
		
		override public function draw():void
		{
			super.draw();
			counter.draw();
		}
		
		public function setCounter(value:int):void
		{
			counter.value = value;
		}
		
		public function flash(duration:Number=0.5):void
		{
			flashTimer = 0.0;
			flashing = true;
			maxFlashTimer = duration;
		}
		
	}

}