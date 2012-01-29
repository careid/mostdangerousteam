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
		protected const RINGRADIUS:Number = 155;
		
		protected const SPIN:uint = 0;
		protected const STOP:uint = 1;
		protected var phase:uint = SPIN;
		
		protected var runLevel:int = 0;
		protected var staminaLevel:int = 0;
		protected var healthLevel:int = 0;
		
		protected var eyeSprite:FlxSprite;
		protected var numEats:Number;
		protected var exp:int;
		protected var numEyes:Number;
		protected var eyesString:FlxText;
		
		protected var newLevel:Boolean;
		
		protected var timeMachine:FlxSprite;
		
		[Embed(source = "graphics/spacestation.png")] protected var SpaceStationImage:Class;
		[Embed(source = "graphics/eyescollected.png")] protected var EyesImage:Class;
		[Embed(source = "graphics/main-icon.png")] protected var ManImage:Class;
		[Embed(source = "graphics/machine-icon.png")] protected var MachineImage:Class;
		
		public function TransState(index:int,timeLeft:Number,players:Array,player:Player=null,newLevel:Boolean=false)
		{
			this.index = index;
			this.timeLeft = timeLeft;
			this.players = players;
			runLevel = player.m_run_level;
			staminaLevel = player.m_stamina_level;
			healthLevel = player.m_health_level;
			eyeSprite = new FlxSprite(20, 10);
			eyeSprite.loadGraphic(EyesImage, true);
			eyeSprite.addAnimation("Nothing", [0]);
			eyeSprite.addAnimation("Eat", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 10, false);
			numEyes = player.numEyes;
			eyeSprite.play("Nothing");
			this.exp = numEyes;
			eyesString = new FlxText(20, 50, 60);
			eyesString.text = "Eyes Collected: " + numEyes;
			super();
			add(eyeSprite);
			add(eyesString);
			numEats = 0;
			this.newLevel = newLevel;
		}
		
		override public function create():void
		{
			var i:int;
			
			planet = new FlxSprite(25, 25);
			planet.loadGraphic(SpaceStationImage);
			planet.angularVelocity = 0.4 * timeLeft;
			planet.blend = "normal";
			planet.antialiasing = true;
			add(planet);
			
			displayText = new MyText(0, 0, FlxG.width, "Traveling back " + int(timeLeft) + " seconds...");
			add(displayText);
			
			buttons = new Array();
			for (i = 0; i < 3; i++)
			{
				var b:Button = new Button(i * 59 + 30, 150);
				buttons.push(b);
				add(b);
			}
			
			buttons[RUN].play("Run");
			buttons[RUN].setCounter(runLevel);
			buttons[STAMINA].play("Fuel");
			buttons[STAMINA].setCounter(staminaLevel);
			buttons[HEALTH].play("Health");
			buttons[HEALTH].setCounter(healthLevel);
			
			FlxG.flash(0xffffffff, 0.5);
			
			timeMachine = new FlxSprite(0, 0,MachineImage);
			add(timeMachine);
			
			add(new FlxSprite(planet.x + planet.width / 2, planet.y, ManImage));
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
			if (numEats < numEyes)
			{
				if (eyeSprite.finished)
				{
					eyeSprite.play("Eat");
					numEats ++;
				}
			}
			
			eyesString.text = "Eyes Collected: " + exp;
			
			updateTimeMachine();
			
			super.update();
		}
		
		protected function updateTimeMachine():void 
		{
			timeMachine.y = Math.sin(3.14 * (planet.angle-90) / 180)*RINGRADIUS + planet.y + planet.height / 2;
			timeMachine.x = Math.cos(3.14 * (planet.angle-90) / 180)*RINGRADIUS + planet.x + planet.width / 2;
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
				buttons[RUN].setCounter(runLevel);
				buttons[RUN].flicker(0.5);
			}
			else if (FlxG.keys.justPressed("X"))
			{
				b = buttons[STAMINA];
				b.flash();
				staminaLevel += 1;
				exp -= 1;
				buttons[STAMINA].setCounter(staminaLevel);
				buttons[STAMINA].flicker(0.5);
			}
			else if (FlxG.keys.justPressed("C"))
			{
				b = buttons[HEALTH];
				b.flash();
				healthLevel += 1;
				exp -= 1;
				buttons[HEALTH].setCounter(healthLevel);
				buttons[HEALTH].flicker(0.5);
			}
		}
		
		protected function startLevel():void
		{
			FlxG.switchState(new PlayState(index,players,runLevel,staminaLevel,healthLevel,newLevel));
		}
	}
}
