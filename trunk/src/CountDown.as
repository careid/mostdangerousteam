package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxColor;
	
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
		
		private var num_digits:int;
		protected var digits:Array;
		
		protected var base:FlxSprite;
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		[Embed(source = "graphics/clockBase.png")] protected var ImgBase:Class;
		
		public function CountDown(num_digits:int = 3, background:Boolean=true)
		{
			super();
			this.num_digits = num_digits;
			if (background)
			{
				base = new FlxSprite(x, y, ImgBase);
				base.immovable = true;
				add(base);
			}
		}
		
		public function setup(x:int, y:int, timeLeft:Number=0):void
		{
			timer = timeLeft;
			time = [0, 0, 0];
			previousTime = [0,0,0];
			
			//set the time
			digits = new Array();
			var i:int, j:int;
			for (i = 0; i < num_digits; i++)
			{
				digits.push(new Array());
				for (j = 0; j < 2; j++)
				{
					var d:Digit = new Digit(x, y+13);
					x += d.width - 1;
					digits[i].push(d);
					add(d);
				}
				x += 2;
			}
			
			syncTime();
		}
		
		private function syncTime():void
		{
			var t:int, o:int, i:int;
			for (i = 0; i < num_digits; i++ )
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