package
{
	import org.flixel.*;
	
	public class CountDown extends FlxGroup
	{
		
		//array index code names
		protected const M:int = 0;
		protected const S:int = 1;
		protected const C:int = 2;
		protected const T:int = 0;
		protected const O:int = 1;
		
		public var timer:Number = 0;
		
		public var time:Array;
		public var previousTime:Array;
		
		protected var digits:Array;
		
		protected var base:FlxSprite;
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		[Embed(source = "graphics/clockBase.png")] protected var ImgBase:Class;
		
		public function CountDown(X:Number=0,Y:Number=0,timeLeft:Number=0) 
		{
			super();
			
		}
		
		public function setup():void
		{
			var x:int = x;
			base = new FlxSprite(x, y, ImgBase);
			base.immovable = true;
			add(base);
			
			time = [0, 0, 0];
			previousTime = [0,0,0];
			
			//set the time
			digits = new Array();
			var i:int, j:int;
			for (i = 0; i < 3; i++)
			{
				digits.push(new Array());
				for (j = 0; j < 2; j++)
				{
					var d:Digit = new Digit(x, y+13);
					x += d.width;
					digits[i].push(d);
					add(d);
					trace(d.y);
				}
				x += 1;
			}
			
			syncTime();
		}
		
		private function syncTime():void
		{
			var t:int, o:int, i:int;
			for (i = 0; i < 3; i++ )
			{
				if (time[i] != previousTime[i])
				{
					previousTime[i] = time[i];
					t = Math.floor(time[i] / 10);
					o = Math.floor(time[i] % 10);
					digits[i][T].play(String(t));
					digits[i][O].play(String(o));
				}
			}
		}
		
		override public function update():void
		{
			updateTime();
			super.update();
			syncTime();
		}
		
		private function updateTime():void
		{
			timer -= FlxG.elapsed;
			time[C] = Math.floor(timer * 100) % 100;
			time[S] = Math.floor(timer) % 60;
			time[M] = Math.floor(timer/60) % 60;
		}
		
	}

}