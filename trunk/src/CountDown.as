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
		
		public function CountDown(X:Number,Y:Number,timeLeft:Number) 
		{
			super();
			
			timer = timeLeft;
			
			time = [0, 0, 0];
			previousTime = [0,0,0];
			
			//set the time
			digits = new Array();
			var x:int = X;
			var i:int, j:int;
			for (i = 0; i < 3; i++)
			{
				digits.push(new Array());
				for (j = 0; j < 2; j++)
				{
					var d:Digit = new Digit(x, Y);
					x += d.width;
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