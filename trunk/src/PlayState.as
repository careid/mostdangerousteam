package
{
	import flash.geom.Point;
	import flash.text.engine.BreakOpportunity;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FX.StarfieldFX;

	public class PlayState extends FlxState
	{
	    [Embed(source = "../maps/level1.csv", mimeType = "application/octet-stream")] public var Level1CSV:Class;
	    [Embed(source = "../maps/level1.xml", mimeType = "application/octet-stream")] public var Level1XML:Class;
		[Embed(source = "../maps/testThing.txt", mimeType = "application/octet-stream")] public var ShitTest:Class;		
		
		protected const LEVELBOTTOM:int = 600;
		
		protected var level:Level;
		protected var player:Player;
		protected var staminaBar:FlxBar;
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
		
		protected var oldPlayers:Array;
		
		protected var starfield:StarfieldFX;
		protected var cameraScrollVelocity:FlxPoint;
		protected var cameraPreviousScroll:FlxPoint;
		
		protected var runLevel:int;
		protected var staminaLevel:int;
		protected var healthLevel:int;
		
        public function PlayState(startIndex:int = 0,oldPlayers:Array=null,runLevel:int=0,staminaLevel:int=0,healthLevel:int=0)
		{
			this.startIndex = startIndex;
			this.oldPlayers = oldPlayers;
			this.cameraPreviousScroll = new FlxPoint();
			this.cameraScrollVelocity = new FlxPoint();
			this.runLevel = runLevel;
			this.staminaLevel = staminaLevel;
			this.healthLevel = healthLevel;
			super();
		}
		
		override public function create():void
		{
			FlxG.bgColor = 0xff000000;
			
			var i:int;
			
			// First, background stars.
			FlxG.addPlugin(new FlxSpecialFX());

			starfield = FlxSpecialFX.starfield();
			starfield.active = true;
			starfield.create(0,0, FlxG.width, FlxG.height, 100);
			starfield.setStarSpeed(0, 0);
			starfield.sprite.scrollFactor.x = 0;
			starfield.sprite.scrollFactor.y = 0;
			starfield.sprite.blend = "normal";
			starfield.sprite.antialiasing = true;
			add(starfield.sprite);
			
			//get level
			level = new Level();
			level.loadFromCSV(new ShitTest());
			add(level.tileMap);
			level.loadFromXML(new Level1XML());
			add(level.timeMachine);
			add(level.doors);
			add(level.powerups);
			timeLeft = level.checkPoints[startIndex].time;
			
			boomerangs = new FlxGroup();
			spikes = new FlxGroup();

			add(boomerangs);
			add(spikes);
			
			//add characters
			characters = new FlxGroup();
			add(characters);
			
			//add player
			if (level.checkPoints != null && level.checkPoints.length == 0)
			{
				// This should only run if there are no checkpoints in the level's XML file
				player = new Player(3008,  228);
			}
			else if (oldPlayers != null) // asshole
			{
				trace("TIME TRAVEL!!!");
				player = oldPlayers[0].timeTravel(level.checkPoints[startIndex].x, level.checkPoints[startIndex].y,runLevel,staminaLevel,healthLevel);
				oldPlayers = [];
			}
			else
			{
				player = new Player(level.checkPoints[startIndex].x, level.checkPoints[startIndex].y,runLevel,staminaLevel,healthLevel);
			}
			characters.add(player);
			
			//add bots
			bots = new FlxGroup();
			for each (var past_self:Player in oldPlayers)
				bots.add(Bot(past_self));
			characters.add(bots);
			
			//set camera
			FlxG.camera.setBounds(-10000,0,20000,24000,true);
			FlxG.camera.follow(player,FlxCamera.STYLE_PLATFORMER);
			
			//add countdown
			countDowns = new FlxGroup();
			for (i = 0; i < 3; i++)
			{
				countDowns.add(new CountDown(player.x + (Math.random()-0.5)*FlxG.height, player.y + (Math.random()-0.5)*FlxG.width, timeLeft));
			}
			add(countDowns);
			
			//set starting variables
			state = MID;
			
			//debug shit
			staminaText = new FlxText(0, 0, 200);
			staminaText.text = "Stamina: ";
			staminaText.scrollFactor.x = 0;
			staminaText.scrollFactor.y = 0;
			staminaBar = new FlxBar(15, 15, FlxBar.FILL_LEFT_TO_RIGHT, 100, 10, player, "stamina", 0, 100, true);
			staminaBar.scrollFactor.x = 0;
			staminaBar.scrollFactor.y = 0;
		
			add(staminaBar);
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
			
			cameraScrollVelocity.x = cameraPreviousScroll.x - FlxG.camera.scroll.x;
			cameraScrollVelocity.y = cameraPreviousScroll.y - FlxG.camera.scroll.y;
			cameraPreviousScroll.x = FlxG.camera.scroll.x;
			cameraPreviousScroll.y = FlxG.camera.scroll.y;
			
			starfield.setStarSpeed( cameraScrollVelocity.x*0.1, cameraScrollVelocity.y*0.1);
			
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
			
			var countdown_members:Array = countDowns.members;
			for (var i:int = 0; i < countDowns.length; i++)
			{
				var cd:CountDown = countdown_members[i];
				var members:Array = cd.members;
				var visible:Boolean = false;
				for (var j:int = 0; j < cd.length; j++)
				{
					var d:FlxSprite = members[j];
					if (d.onScreen(FlxG.camera))
					{
						visible = true;
						break;
					}
				}
				
				if (visible)
					continue;
					
				var dx:int = 0;
				var dy:int = 0;
				if (player.velocity.x > 0)
				{
					if (members[cd.length-1].x < FlxG.camera.scroll.x)
					{
						dx = FlxG.camera.scroll.x + FlxG.camera.width + members[cd.length-1].x - 2 * members[0].x;
						dy = FlxG.camera.scroll.y + (Math.random() - 0.5) * FlxG.camera.height - members[0].y;
					}
				} else if (player.velocity.x < 0)
				{
					if (members[0].x > FlxG.camera.scroll.x + FlxG.camera.width)
					{
						dx = FlxG.camera.scroll.x - 2 * members[cd.length-1].x + members[0].x;
						dy = FlxG.camera.scroll.y + (Math.random() - 0.5) * FlxG.camera.height - members[0].y;
					}
				}
				if (player.velocity.y > 0)
				{
					if (members[0].y < FlxG.camera.scroll.y)
					{
						dx = FlxG.camera.scroll.x + (Math.random() - 0.5) * FlxG.camera.width - members[0].y;
						dy = FlxG.camera.scroll.y + FlxG.camera.height + members[0].height - members[0].y;
					}
				}
				else if (player.velocity.y < 0)
				{
					if (members[0].y > player.y && members[0].y > FlxG.camera.scroll.y + FlxG.camera.height)
					{
						dx = FlxG.camera.scroll.x + (Math.random() - 0.5) * FlxG.camera.width - members[0].y;
						dy = FlxG.camera.scroll.y - members[0].height - members[0].y;
					}
				}
				
				for (var j:int = 0; j < 6; j++)
				{
					var d:FlxSprite = members[j];
					d.x += dx;
					d.y += dy;
				}
			}
			
			if (player.y > LEVELBOTTOM)
			{
				gameOver();
			}
			
			updateStateEvents();
			
			debugShit();

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
				bots.add(Bot(player));
			}
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
					FlxSpecialFX.remove(starfield);
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
			FlxSpecialFX.remove(starfield);
			
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
			
			if (oldPlayers)
			{
				oldPlayers.unshift(player);
			}
			else
			{
				oldPlayers = [player];
			}
			FlxG.switchState(new TransState(bestIndex,level.checkPoints[startIndex].time,oldPlayers));
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
			FlxSpecialFX.remove(starfield);
			
			FlxG.switchState(new GameOverState());
		}
		
	}
}
