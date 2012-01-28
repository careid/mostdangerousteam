package
{
	import flash.text.engine.BreakOpportunity;
	import org.flixel.*;

	public class PlayState extends FlxState
	{
	    [Embed(source = "../maps/level1.csv", mimeType = "application/octet-stream")] public var Level1CSV:Class;
	    [Embed(source = "../maps/level1.xml", mimeType = "application/octet-stream")] public var Level1XML:Class;
		[Embed(source = "../maps/testThing.txt", mimeType = "application/octet-stream")] public var ShitTest:Class;
		
		protected var level:Level;
		protected var player:Player;
		protected var tileMap:FlxTilemap;
		protected var startIndex:int;
		protected var state:uint;
		protected var characters:FlxGroup;
		
		protected var END:uint = 0;
		protected var START:uint = 1;
		protected var MID:uint = 2;
		
		protected var checkPoints:Array;
		public var boomerangs:FlxGroup;
		public var spikes:FlxGroup;
		
		protected var timeLeft:Number = 0;
		
		protected var staminaText:FlxText;
		protected var debugDoor:Door;
		
		protected var doors:FlxGroup;
		
		protected var bots:FlxGroup;
		
		protected var countDowns:FlxGroup;
		
		protected var oldPlayer:Player;
		
		public function PlayState(startIndex:int = 0,oldPlayer:Player=null)
		{
			this.startIndex = startIndex;
			this.oldPlayer = oldPlayer;
			super();
		}
		
		override public function create():void
		{
			FlxG.bgColor = 0xff000000;
			
			var i:int;
			
			//get level
			level = new Level();
			level.loadFromCSV(new ShitTest());
			add(level.tileMap);
			level.loadFromXML(new Level1XML());
			add(level.timeMachine);
			add(level.doors);
			add(level.powerups);
			timeLeft = level.checkPoints[startIndex].time;
			
			//add countdown
			countDowns = new FlxGroup();
			for (i = 0; i < 15; i++)
			{
				countDowns.add(new CountDown(Math.random()*FlxG.height,Math.random()*FlxG.width, timeLeft));
			}
			add(countDowns);
			
			boomerangs = new FlxGroup();
			spikes = new FlxGroup();

			add(boomerangs);
			add(spikes);
			
			//add characters
			characters = new FlxGroup();
			add(characters);
			
			//LOOK GUYS
			oldPlayer;
			//add player
			if (level.checkPoints != null && level.checkPoints.length == 0)
			{
				// This should only run if there are no checkpoints in the level's XML file
				player = new Player(FlxG.width/2 - 5, 200);
			}
			else 
			{
				player = new Player(level.checkPoints[startIndex].x, level.checkPoints[startIndex].y);
			}
			characters.add(player);
			
			//add bots
			bots = new FlxGroup();
			characters.add(bots);
			
			//set camera
			FlxG.camera.setBounds(-1000,0,2000,2400,true);
			FlxG.camera.follow(player,FlxCamera.STYLE_PLATFORMER);
			
			//set starting variables
			state = MID;
			
			//debug shit
			staminaText = new FlxText(0, 0, 200);
			staminaText.scrollFactor.x = 0;
			add(staminaText);
			add(new FlxText(0, 40, FlxG.width, "press D to door \npress B to bot"));
			
			//add doors
			doors = new FlxGroup();
			add(doors);
			debugDoor = new Door(50, 100);
			doors.add(debugDoor);
			
			FlxG.flash(0xffffffff, 0.7);
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
			FlxG.collide(level.tileMap, spikes);
			FlxG.collide(doors, characters);
			FlxG.overlap(level.powerups, player, PowerupEntity.overlapCharacter);
			FlxG.overlap(boomerangs, player, Boomerang.overlapCharacter);
			FlxG.overlap(boomerangs, bots, Boomerang.overlapCharacter);
			FlxG.overlap(spikes, player, SpikeTrap.overlapCharacter);
			FlxG.overlap(spikes, bots, SpikeTrap.overlapCharacter);
			
			if (!player.alive)
			{
				endGame();
			}
			
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
				player.push_waypoint();
				bots.add(makeBot(player.get_waypoints()));
			}
		}
		
		public function makeBot(waypoints:Array):Bot
		{
			var p0:WayPoint = waypoints[0];
			return new Bot(p0.x, p0.y, waypoints);
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
					FlxG.fade(0xffffff, 0.7, restartLevel);
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
						endGame();
					}
					FlxG.overlap(player, level.timeMachine, reachGoal);
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
			var bestIndex:int = 0; //hopefully checkPoints is never empty
			for (i = 0; i < level.checkPoints.length; i++)
			{
				var c:CheckPoint = level.checkPoints[i];
				if (timeLeft > c.threshold)
				{
					bestIndex = i;
				}
				else
				{
					break;
				}
			}
			
			FlxG.switchState(new TransState(bestIndex,level.checkPoints[startIndex].time,player));
		}
		
		private function reachGoal(a:FlxObject,b:FlxObject):void
		{
			transitionState(END);
		}
		
		private function endGame():void
		{
			FlxG.fade(0xff000000, 1, gameOver);
		}
		
		private function gameOver():void
		{
			FlxG.switchState(new GameOverState());
		}
		
	}
}
