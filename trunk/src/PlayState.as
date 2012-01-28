package
{
	import flash.text.engine.BreakOpportunity;
	import org.flixel.*;

	public class PlayState extends FlxState
	{
	    [Embed(source = "../maps/level1.csv", mimeType = "application/octet-stream")] public var Level1:Class;
		
		protected var level:Level;
		protected var player:Player;
		protected var startPosition:FlxPoint;
		protected var state:uint;
		protected var characters:FlxGroup;
		
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
		protected var debugDoor:Door;
		
		protected var debugPowerup:Powerup;
		protected var debugPowerupEntity:PowerupEntity;
		
		protected var doors:FlxGroup;
		
		protected var bots:FlxGroup;
		
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
			
			//add characters
			characters = new FlxGroup();
			add(characters);
			
			//add player
			if (!startPosition)
			{
				player = new Player(FlxG.width/2 - 5, 200);
			}
			else 
			{
				player = new Player(startPosition.x, startPosition.y);
			}
			characters.add(player);
			
			//add bots
			bots = new FlxGroup();
			characters.add(bots);
			
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
			
			//add doors
			doors = new FlxGroup();
			add(doors);
			debugDoor = new Door(50, 100);
			doors.add(debugDoor);
			
			
			debugPowerup = new StaminaRechargePowerup();
			debugPowerupEntity = new PowerupEntity(50, 50, debugPowerup);
			debugPowerupEntity.play("stamina");
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
			
			FlxG.collide(level.tileMap, characters);
			FlxG.collide(doors, characters);
			
			updateStateEvents();
			
			debugShit();
			
			staminaText.text = String(Math.floor(player.stamina));
			
		}
		
		public function debugShit():void
		{
			if (FlxG.keys.justPressed("D"))
			{
				if (debugDoor.state == Door.DOWN)
				{
					debugDoor.switchState(Door.OPENING);
				}
				else
				{
					debugDoor.switchState(Door.CLOSING);
				}
			}
			
			if (FlxG.keys.justPressed("B"))
			{
				//BRUCE
				bots.add(new Bot(0, 0, null));
			}
			
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
