package
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.engine.BreakOpportunity;
	import flash.utils.Timer;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FX.StarfieldFX;
	
	public class PlayState extends FlxState
	{
	    [Embed(source = "../maps/level1.csv", mimeType = "application/octet-stream")] public var Level1CSV:Class;
	    [Embed(source = "../maps/level1.xml", mimeType = "application/octet-stream")] public var Level1XML:Class;
		[Embed(source = "../maps/testThing.txt", mimeType = "application/octet-stream")] public var TestThingCSV:Class;		
		[Embed(source = "../maps/testThing.xml", mimeType = "application/octet-stream")] public var TestThingXML:Class;		
		
		[Embed(source = "./graphics/hud.png")] public var HUD:Class;
		[Embed(source = "./graphics/powerups.png")] public var PowerupImage:Class;
		
		public static var GRAVITY:int = 400;
		
		protected var tiles:Array;
		protected var fallAccum:Number;
		protected var fallRate:Number;
		protected var fallAccel:Number;
		protected var fallJerk:Number;
		protected var fallBlocks:FlxGroup;
		
		public const LEVELBOTTOM:int = 600;
		
		public var level:Level;
		public var player:Player;
		protected var healthBar:FlxBar;
		protected var staminaBar:FlxBar;
		protected var startIndex:int;
		protected var state:uint;
		protected var characters:FlxGroup;
		protected var countdown:CountDown;
		
		protected var END:uint = 0;
		protected var START:uint = 1;
		protected var MID:uint = 2;
		
		protected var checkPoints:Array;
		public var boomerangs:FlxGroup;
		public var spikes:FlxGroup;
		
		protected var timeStart:Number = 0;
		protected var timeLeft:Number = 0;
		
		protected var doors:FlxGroup;
		
		protected var bots:FlxGroup;
		
		protected var oldPlayersIndex:int;
		protected var oldPlayers:Array;
		
		protected var starfield:StarfieldFX;
		protected var cameraScrollVelocity:FlxPoint;
		protected var cameraPreviousScroll:FlxPoint;
		
		protected var runLevel:int;
		protected var staminaLevel:int;
		protected var healthLevel:int;
		protected var isFirstIteration:Boolean = false;
		
		protected var eyeCounter:Counter;
		protected var itemDisplays:Array;
		
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
			
			var i:int, x:int, y:int;
			
			// First, background stars.
			FlxG.addPlugin(new FlxSpecialFX());
			//get level
			level = new Level();
			level.loadFromCSV(new TestThingCSV());
			level.loadFromXML(new TestThingXML());
			starfield = FlxSpecialFX.starfield();
			starfield.create(0 , 0, FlxG.width, FlxG.height, 100);
			starfield.active = true;
			starfield.sprite.scrollFactor.x = 0.0;
			starfield.sprite.scrollFactor.y = 0.0;
			starfield.setStarSpeed( -0.25, 0);
			add(starfield.sprite);
			add(level.tileMap);
			add(level.timeMachine);
			add(level.doors);
			add(level.doorSwitches);
			add(level.conveyors);
			add(level.spikepits);
			add(level.powerups);
			add(level.eyes);
			add(level.misc);
			timeLeft = level.checkPoints[startIndex].time;
			Hydraman.m_initialTimeLeft = timeLeft;
			for (i = 0; i < level.countDowns.length; i++)
			{
				var countdown:CountDown = level.countDowns.members[i] as CountDown;
				countdown.setup(countdown.x, countdown.y, timeLeft);
			}
			add(level.countDowns);
			
			tiles = new Array();
			FlxG.globalSeed = 12345;
			var data:Array = level.tileMap.getData();
			for (x = 0; x < level.tileMap.widthInTiles; x++)
			{
				for (y = 0; y < level.tileMap.heightInTiles; y++)
				{
					i = y * level.tileMap.widthInTiles + x;
					if (data[i] > 0)
						tiles.push(i);
				}
			}
			timeStart = level.checkPoints[level.checkPoints.length - 1].time;
			var timeEnd:Number = level.checkPoints[startIndex].time;
			// formula for increasing falling blocks from start of level
			// # fallen blocks = accel * time^2/2     accel = blocks * 2 / time ^ 2
			// Calc intermediate 
			fallAccum = 0;
			fallRate = 0;
			fallAccel = 0;
			fallJerk = 0.8 * tiles.length * 6.0 / Math.pow(timeStart, 3.0);	// Have all blocks fall by end of level
			
			fallBlocks = new FlxGroup();
			add(fallBlocks);
			
			// Simulate the falling from the start time until the current time
			for (timeLeft = timeStart; timeLeft > timeEnd; timeLeft -= FlxG.elapsed)
			{
				updateFallingBlocks();
				fallBlocks.preUpdate();
				fallBlocks.update();
				fallBlocks.postUpdate();
			}
			timeLeft = timeEnd;
			
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
			else if (oldPlayers != null && oldPlayers.length > 0) // asshole
			{
				trace("TIME TRAVEL!!!");
				player = oldPlayers[oldPlayers.length-1].timeTravel(level.checkPoints[startIndex].x, level.checkPoints[startIndex].y,runLevel,staminaLevel,healthLevel);
				oldPlayersIndex = 0;
				while (oldPlayersIndex < oldPlayers.length - 1 && oldPlayers[oldPlayersIndex].startTime > timeLeft)
					oldPlayersIndex++;
			}
			else
			{
				player = new Player(level.checkPoints[startIndex].x, level.checkPoints[startIndex].y, runLevel, staminaLevel, healthLevel);
				oldPlayers = [new Player(level.checkPoints[startIndex].x, level.checkPoints[startIndex].y, runLevel, staminaLevel, healthLevel)];
			}
			cameraScrollVelocity = new FlxPoint(player.x, player.y);
			cameraPreviousScroll = new FlxPoint(0, 0);
			characters.add(player);
			
			player.startTime = level.checkPoints[startIndex].time;
			
			// bots
			bots = new FlxGroup();
			characters.add(bots);
			
			//set camera
			FlxG.camera.setBounds(-10000,0,20000,24000,true);
			FlxG.camera.follow(player,FlxCamera.STYLE_PLATFORMER);
			
			//set starting variables
			state = MID;
			
			//hud
			var hud:FlxSprite = new FlxSprite(0, 0, HUD);
			hud.scrollFactor.x = hud.scrollFactor.y = 0;
			countdown = new CountDown(2);
			countdown.setup(68, -9, timeLeft);
			for (i = 0; i < countdown.length; i++)
			{
				countdown.members[i].scrollFactor.x = 0;
				countdown.members[i].scrollFactor.y = 0;
			}
			healthBar = new FlxBar(11, 3, FlxBar.FILL_LEFT_TO_RIGHT, 56, 6, player, "health", 0, player.max_health);
			healthBar.createFilledBar(0xff000000, 0xffff0000);
			healthBar.scrollFactor.x = 0;
			healthBar.scrollFactor.y = 0;
			staminaBar = new FlxBar(11, 14, FlxBar.FILL_LEFT_TO_RIGHT, 56, 6, player, "stamina", 0, 100, true);
			staminaBar.createFilledBar(0xff000000, 0xff0000ff);
			staminaBar.scrollFactor.x = 0;
			staminaBar.scrollFactor.y = 0;
			eyeCounter = new Counter(78, 16);
			
			add(hud);
			add(healthBar);
			add(staminaBar);
			add(eyeCounter);
			itemDisplays = new Array()
			for (i = 0; i < 5; i++)
			{
				itemDisplays.push(new FlxSprite(i * 12, 35));
				itemDisplays[i].loadGraphic(PowerupImage,true,false,16,16);
				itemDisplays[i].scrollFactor.x = itemDisplays[i].scrollFactor.y = 0;
				itemDisplays[i].addAnimation("boomerang", [0]);
				itemDisplays[i].addAnimation("doublejump", [1]);
				itemDisplays[i].addAnimation("stamina", [2]);
				itemDisplays[i].addAnimation("spikes", [3]);
				add(itemDisplays[i]);
			}
			add(new FlxText(0, 40, FlxG.width, "press B to bot"));
			add(countdown);
			
			FlxG.flash(0xffffffff, 0.7);
		}
		
		protected function updateFallingBlocks() : void
		{
			// Update falling blocks
			// Remove blocks out of view
			var i:int;
			for (i = fallBlocks.length - 1; i >= 0; i--)
			{
				var block:FlxSprite = fallBlocks.members[i];
				if (block == null || block.y > FlxG.camera.scroll.y + FlxG.camera.height + 32)
				{
					fallBlocks.remove(block);
				}
			}
			// Add more falling blocks as needed
			fallAccum += fallRate * FlxG.elapsed + 0.5 * fallAccel * FlxG.elapsed * FlxG.elapsed + 1.0 / 6.0 * fallJerk * FlxG.elapsed * FlxG.elapsed * FlxG.elapsed;
			fallRate += fallAccel * FlxG.elapsed + 0.5 * fallJerk * FlxG.elapsed * FlxG.elapsed;
			fallAccel += fallJerk * FlxG.elapsed;
			if (fallAccum >= 1)
			{
				var xmax:int = int((1.0 - timeLeft / timeStart) * (level.timeMachine.x / 32 - 2) + 1);
				var imax:int = xmax * tiles.length / level.tileMap.widthInTiles;
				while (tiles[imax] % level.tileMap.widthInTiles > xmax)
					imax--;
				while (tiles[imax] % level.tileMap.widthInTiles < xmax)
					imax++;
				while (fallAccum >= 1)
				{
					fallAccum--;
					var idx:uint = tiles.splice(FlxG.random() * imax, 1);
					var tile_idx:uint = level.tileMap.getTileByIndex(idx);
					level.tileMap.setTileByIndex(idx, 0);
					
					var tile:FlxSprite = new FlxSprite(idx % level.tileMap.widthInTiles * 32, idx / level.tileMap.widthInTiles * 32);
					tile.loadGraphic(level.Image, true, true, 32, 32);
					tile.addAnimation("idle", [tile_idx]);
					tile.play("idle");
					tile.mass = 5.0;
					tile.acceleration.y = GRAVITY;
					tile.maxVelocity.y = GRAVITY;
					tile.velocity.x = 25.0 * (FlxG.random()-0.5);
					tile.velocity.y = -25.0 * FlxG.random();
					tile.angularVelocity = 180.0 * (FlxG.random() - 0.5);
					fallBlocks.add(tile);
				}
			}
		}
		
		protected function fallingBlockCollide(Object1:FlxObject,Object2:FlxObject):void
		{
			var char:Character;
			var block:FlxSprite;
			if (Object1 is Character)
			{
				char = Object1 as Character;
				block = Object2 as FlxSprite;
			}
			else
			{
				char = Object2 as Character;
				block = Object1 as FlxSprite;
			}
			
			//var nvx:Number = char.velocity.x - block.velocity.x;
			var nvy:Number = char.velocity.y - block.velocity.y;
			block.solid = false;
			if (nvy > 0)
				return;
			char.hit(17);
		}
		
		override public function update():void
		{

			timeLeft -= FlxG.elapsed;
			if (timeLeft < 0)
			{
				timeLeft = 0;
			}
			if (oldPlayersIndex < oldPlayers.length - 1 && oldPlayers[oldPlayersIndex].startTime > timeLeft)
			{
				var past_self:Player = oldPlayers[oldPlayersIndex];
				//trace("add bots " + timeLeft + " " + past_self.startTime + " " + past_self.startX + " " + past_self.startY + " " + past_self.m_waypoints.length);
				bots.add(new Bot(past_self));
				oldPlayersIndex++;
			}
			
			super.update();
			
			cameraScrollVelocity.x = cameraPreviousScroll.x - FlxG.camera.scroll.x;
			cameraScrollVelocity.y = cameraPreviousScroll.y - FlxG.camera.scroll.y;
			
			cameraPreviousScroll.x = FlxG.camera.scroll.x;
			cameraPreviousScroll.y = FlxG.camera.scroll.y;
			
			var i:int;
			var s:FlxSprite;
			while (level.misc.remove(null));
			
			FlxG.collide(level.tileMap, characters);
			FlxG.collide(level.tileMap, spikes);
			FlxG.collide(level.doors, characters);
			FlxG.collide(level.countDowns, characters);
			FlxG.collide(level.conveyors, characters, Conveyor.overlap);
			FlxG.collide(level.spikepits, characters, SpikePit.overlap);
			FlxG.overlap(level.powerups, characters, PowerupEntity.overlapCharacter);
			FlxG.overlap(level.doorSwitches, characters,DoorSwitch.overlap);
			FlxG.overlap(boomerangs, characters, Boomerang.overlapCharacter);
			FlxG.overlap(boomerangs, spikes, SpikeTrap.overlapBoomerang);
			FlxG.overlap(spikes, characters, SpikeTrap.overlapCharacter);
			FlxG.overlap(level.eyes, player, Eye.overlapPlayer);
			FlxG.collide(fallBlocks, characters, fallingBlockCollide);
			FlxG.collide(level.tileMap, level.eyes);
			updateFallingBlocks();
			
			updateStateEvents();

			if (!player.alive)
			{
				endGame();
			}
			if (player.y > LEVELBOTTOM)
			{
				gameOver();
			}
			
			debugShit();
			isFirstIteration = false;
			var powerupList:Array = player.getPowerupList();
			if (powerupList != null)
			{
				for (i = 0; i < itemDisplays.length; i++)
				{
					itemDisplays[i].scale.x = itemDisplays[i].scale.y = 0.7;
					itemDisplays[i].alpha = 0.7;
					if (i < powerupList.length)
					{
						itemDisplays[i].exists = true;
						itemDisplays[i].play(powerupList[i].animationName);
						if (powerupList[i] == player.getCurrentPowerup())
						{
							itemDisplays[i].scale.x = itemDisplays[i].scale.y = 1.0;
							itemDisplays[i].alpha = 1.0;
						}
					}
					else
					{
						itemDisplays[i].exists = false;
					}
				}
			}
			else
			{
				for (i = 0; i < itemDisplays.length; i++)
				{
					itemDisplays[i].exists = false;
				}
			}
			eyeCounter.value = player.numEyes;
		}
		
		public function debugShit():void
		{			
			if (FlxG.keys.justPressed("B"))
			{
				//BRUCE
				bots.add(new Bot(player));
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
					remove(starfield.sprite);
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
			remove(starfield.sprite);
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
			
			if (bestIndex < startIndex)
			{
				// Remove players at greater indices
				var idx1:int = 0;
				var idx2:int = 0;
				while (idx1 < bestIndex && ((oldPlayers[idx1].startX != level.checkPoints[idx2].x) ||
						(oldPlayers[idx1].startY != level.checkPoints[idx2].y)))
				{
					idx2++;
				}
				oldPlayers.splice(idx2, startIndex - bestIndex, player);
			}
			else if (bestIndex > startIndex)
			{
				oldPlayers.unshift(player);
			}
			else
			{
				oldPlayers[bestIndex] = player;
			}
			FlxG.switchState(new TransState(bestIndex,level.checkPoints[startIndex].time,oldPlayers,player));
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
			
			FlxG.switchState(new GameOverState(startIndex,level.checkPoints[startIndex].time,oldPlayers,player));
		}
		
	}
}
