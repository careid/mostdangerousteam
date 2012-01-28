package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
	    [Embed(source = "../maps/map.csv", mimeType = "application/octet-stream")] public var Level1:Class;
		
		protected var level:Level;
		protected var player:Player;
		protected var startPosition:FlxPoint;
		protected var state:uint;
		
		protected var END:uint = 0;
		protected var START:uint = 1;
		protected var MID:uint = 2;
		
		protected var timeMachine:TimeMachine;
		protected var TIMEMACHINEX:Number = 200;
		protected var TIMEMACHINEY:Number = 100;
		
		protected var checkPoints:Array;
		
		protected var timeLeft:Number = 0;
		
		protected var debugTimer:FlxText;
		protected var staminaText:FlxText;
		
		protected var debugPowerup:Powerup;
		protected var debugPowerupEntity:PowerupEntity;
		
		public function PlayState(timeLeft:Number,startPosition:FlxPoint = null)
		{
			this.startPosition = startPosition;
			this.timeLeft = timeLeft;
			super();
		}
		
		override public function create():void
		{
			FlxG.bgColor = 0xffaaaaaa;
			
			//get level
			level = new Level();
			level.loadFromCSV(new Level1(), this);
			
			//add player
			if (!startPosition)
			{
				player = new Player(FlxG.width/2 - 5, 200);
			}
			else 
			{
				player = new Player(startPosition.x, startPosition.y);
			}
			add(player);
			
			//add time machine
			timeMachine = new TimeMachine(TIMEMACHINEX,TIMEMACHINEY);
			add(timeMachine);
			
			//set camera
			FlxG.camera.setBounds(-1000,0,2000,240,true);
			FlxG.camera.follow(player,FlxCamera.STYLE_PLATFORMER);
			
			//add checkpoints
			checkPoints = new Array();
			//NOTE: the threshold should be in increasing order
			checkPoints = [new CheckPoint(new FlxPoint(200, 100), 0.0, 10.0),
							new CheckPoint(new FlxPoint(50, 100), 5.0, 15.0)]
			
			//set starting variables
			state = MID;
			
			//debug shit
			staminaText = new FlxText(0, 0, 200);
			debugTimer = new FlxText(310, 0, 200);
			staminaText.scrollFactor.x = 0;
			debugTimer.scrollFactor.x = 0;
			add(staminaText);
			add(debugTimer);
			
			debugPowerup = new StaminaRechargePowerup();
			debugPowerupEntity = new PowerupEntity(50, 50, null, debugPowerup);
			debugPowerupEntity.makeGraphic(32, 32);
			add(debugPowerupEntity);
		}
		
		override public function update():void
		{
			timeLeft -= FlxG.elapsed;
			if (timeLeft < 0)
			{
				timeLeft = 0;
			}
			
			super.update();
			
			FlxG.collide(level.tileMap, player);
			
			updateStateEvents();
			
			debugShit();
			
			staminaText.text = String(Math.floor(player.stamina));
		}
		
		public function debugShit():void
		{
			debugTimer.text = String(Math.floor(timeLeft));
			FlxG.overlap(debugPowerupEntity, player, PowerupEntity.overlapCharacter);
		}
		
		public function transitionState(newState:uint):void 
		{
			state = newState;
			switch(state)
			{
				case START:
					break;
				case MID:
					break;
				case END:
					FlxG.fade(0xffffff, 1, restartLevel);
					break;
				default:
					break;
			}
		}
		
		private function updateStateEvents():void 
		{
			switch(state)
			{
				case START:
					break;
				case MID:
					if (timeLeft <= 0)
					{
						FlxG.fade(0xff000000, 1, gameOver);
					}
					FlxG.overlap(player, timeMachine, reachGoal);
					break;
				case END:
					break;
				default:
					break;
			}
		}
		
		private function restartLevel():void 
		{
			//find out which checkpoint the player gets sent to
			var i:int;
			var bestCheckPoint:CheckPoint = checkPoints[0]; //hopefully checkPoints is never empty
			for (i = 0; i < checkPoints.length; i++)
			{
				var c:CheckPoint = checkPoints[i];
				if (timeLeft > c.threshold && c.threshold > bestCheckPoint.threshold)
				{
					bestCheckPoint = c;
				}
			}
			
			FlxG.switchState(new PlayState(bestCheckPoint.time,bestCheckPoint.position));
		}
		
		private function reachGoal(a:FlxObject,b:FlxObject):void
		{
			transitionState(END);
		}
		
		private function gameOver():void
		{
			FlxG.switchState(new GameOverState());
		}
		
	}
}
