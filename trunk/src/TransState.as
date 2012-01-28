package
{
	import mx.core.ButtonAsset;
	import org.flixel.*;

	public class TransState extends FlxState
	{
		protected const MAXDISPLAYTIME:Number = 3.0;
		
		protected const RUN:uint = 0;
		protected const STAMINA:uint = 1;
		protected const HEALTH:uint = 2;
		
		protected var buttons:Array;
		
		protected var timeLeft:Number;
		protected var index:int;
		protected var players:Array;
		
		protected var displayText:FlxText;
		protected var displayTimer:Number = MAXDISPLAYTIME;
		
		protected var planet:FlxSprite;
		
		protected const SPIN:uint = 0;
		protected const STOP:uint = 1;
		protected var phase:uint = SPIN;
		
		protected var runLevel:int = 0;
		protected var staminaLevel:int = 0;
		protected var healthLevel:int = 0;
		
		protected var exp:int;
		
		public function TransState(index:int,timeLeft:Number,players:Array,exp:int=0)
		{
			this.index = index;
			this.timeLeft = timeLeft;
			this.players = players;
			var player:Player = players[players.length - 1];
			runLevel = player.m_run_level;
			staminaLevel = player.m_stamina_level;
			healthLevel = player.m_health_level;
			this.exp = exp;
			super();
		}
		
		override public function create():void
		{
			var i:int;
			
			planet = new FlxSprite(100, 100);
			planet.makeGraphic(50, 50);
			planet.angularVelocity = -0.2*timeLeft;
			add(planet);
			
			displayText = new FlxText(0, 0, FlxG.width, "Traveling back "+int(timeLeft)+" seconds...");
			add(displayText);
			
			buttons = new Array();
			for (i = 0; i < 3; i++)
			{
				buttons.push(new Button(i * 50 + 30, 100));
				add(buttons[i]);
			}
			
			buttons[0].setText("Press Z for RUN " + String(runLevel+1));
			buttons[1].setText("Press X for STAMINA " + String(staminaLevel+1));
			buttons[2].setText("Press C for HEALTH " + String(healthLevel+1));
			
			FlxG.flash(0xffffffff, 0.5);
			
			exp = 3;
		}
		
		override public function update():void 
		{
			displayTimer -= FlxG.elapsed;
			
			if (exp > 0)
			{
				updateButtons();
			}
			
			switch (phase) 
			{
				case SPIN:
					if (displayTimer < 0)
					{
						planet.angularVelocity = 0.3;
						phase = STOP;
					}
					break;
				case STOP:
					if (exp <= 0)
					{
						FlxG.fade(0xffffffff, 0.5,startLevel);
					}
					break;
				default:
					break;
			}
			
			super.update();
		}
		
		protected function updateButtons():void
		{
			var b:Button;
			if (FlxG.keys.justPressed("Z"))
			{
				b = buttons[RUN];
				b.flash();
				runLevel += 1;
				exp -= 1;
				buttons[0].setText("Press Z for RUN " + String(runLevel + 1));
			}
			else if (FlxG.keys.justPressed("X"))
			{
				b = buttons[STAMINA];
				b.flash();
				staminaLevel += 1;
				exp -= 1;
				buttons[1].setText("Press X for STAMINA " + String(staminaLevel+1));
			}
			else if (FlxG.keys.justPressed("C"))
			{
				b = buttons[HEALTH];
				b.flash();
				healthLevel += 1;
				exp -= 1;
				buttons[2].setText("Press C for HEALTH " + String(healthLevel+1));
			}
		}
		
		protected function startLevel():void
		{
			FlxG.switchState(new PlayState(index,players,runLevel,staminaLevel,healthLevel));
		}
	}
}
