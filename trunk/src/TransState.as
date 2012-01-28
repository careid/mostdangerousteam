package
{
	import org.flixel.*;

	public class TransState extends FlxState
	{
		protected const MAXDISPLAYTIME:Number = 3.0;
		
		protected var timeLeft:Number;
		protected var index:int;
		protected var displayText:FlxText;
		protected var displayTimer:Number = MAXDISPLAYTIME;
		
		protected var planet:FlxSprite;
		
		protected const SPIN:uint = 0;
		protected const STOP:uint = 1;
		protected var phase:uint = SPIN;
		
		public function TransState(index:int,timeLeft:Number)
		{
			this.index = index;
			this.timeLeft = timeLeft;
			super();
		}
		
		override public function create():void
		{
			planet = new FlxSprite(100, 100);
			planet.makeGraphic(50, 50);
			planet.angularVelocity = -0.2*timeLeft;
			add(planet);
			
			displayText = new FlxText(0, 0, FlxG.width, "Traveling back "+int(timeLeft)+" seconds...");
			add(displayText);
			
			FlxG.flash(0xffffffff, 0.5);
		}
		
		override public function update():void 
		{
			displayTimer -= FlxG.elapsed;
			
			switch (phase) 
			{
				case SPIN:
					if (displayTimer < 0)
					{
						planet.angularVelocity = 0.3;
						FlxG.fade(0xffffffff, 0.5,startLevel);
						phase = STOP;
					}
					break;
				case STOP:
					break;
				default:
					break;
			}
			
			super.update();
		}
		
		protected function startLevel():void
		{
			FlxG.switchState(new PlayState(index));
		}
	}
}
