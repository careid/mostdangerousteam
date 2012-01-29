package
{
	import org.flixel.*;
	
	public class Counter extends FlxGroup
	{
		
		//array index code names
		protected const T:int = 0;
		protected const O:int = 1;
		
		public var value:int = 0;
		
		protected var digits:Array;
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		public function Counter(X:Number=0,Y:Number=0) 
		{
			super();
			x = X;
			y = Y;
			setup();
		}
		
		public function setup():void
		{
			var x:int = x;
			
			//set the time
			digits = new Array();
			var i:int, j:int;
			for (i = 0; i < 2; i++)
			{
				var d:Digit = new Digit(x, y);
				x += 4;
				digits.push(d);
				add(d);
				d.scrollFactor.x = d.scrollFactor.y = 0;
			}
			
			syncCounter();
		}
		
		private function syncCounter():void
		{
			var t:int, o:int;
			t = Math.floor(value / 10);
			o = Math.floor(value % 10);
			digits[T].play(String(t));
			digits[O].play(String(o));
		}
		
		override public function update():void
		{
			super.update();
			syncCounter();
		}
		
	}

}