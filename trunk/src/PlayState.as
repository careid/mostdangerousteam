package
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.engine.BreakOpportunity;
	import mx.core.FlexSprite;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FX.StarfieldFX;
	
	public class PlayState extends FlxState
	{
		[Embed(source="../maps/level1.csv",mimeType="application/octet-stream")]
		public var Level1CSV:Class;
		[Embed(source="../maps/level1.xml",mimeType="application/octet-stream")]
		public var Level1XML:Class;
		[Embed(source="../maps/testThing.txt",mimeType="application/octet-stream")]
		public var TestThingCSV:Class;
		[Embed(source="../maps/testThing.xml",mimeType="application/octet-stream")]
		public var TestThingXML:Class;
		[Embed(source="./graphics/Ring002.png")]
		public var CircleParticle:Class;
		[Embed(source="./graphics/hud2.png")]
		public var HUD:Class;
		[Embed(source="./graphics/powerups.png")]
		public var PowerupImage:Class;
		[Embed(source="./sounds/music/bgm1.mp3")]
		public var bgm1:Class;
		[Embed(source="./sounds/music/bgm2.mp3")]
		public var bgm2:Class;
		[Embed(source="./sounds/music/bgm3.mp3")]
		public var bgm3:Class;
		[Embed(source="./sounds/music/bgm4.mp3")]
		public var bgm4:Class;
		[Embed(source="./sounds/gameStartFanfare.mp3")]
		protected var fanfare:Class;
		[Embed(source="sounds/explosion.mp3")]
		public var ExplosionSnd:Class;
		
		public static var GRAVITY:int = 200;
		
		protected var winner:Boolean;
		
		protected var tiles:Array;
		protected var objects:Array;
		protected var fallAccum:Number;
		protected var fallRate:Number;
		protected var fallAccel:Number;
		protected var fallJerk:Number;
		protected var fallBlocks:FlxGroup;
		protected var fallBGBlocks:FlxGroup;
		
		public const LEVELBOTTOM:int = 600;
		
		public var level:Level;
		public var player:Player;
		public var cam:FlxObject;
		public var camTarget:FlxObject;
		public var characters:FlxGroup;
		protected var healthBar:FlxBar;
		protected var staminaBar:FlxBar;
		protected var startIndex:int;
		protected var state:uint;
		protected var countdown:CountDown;
		
		protected var END:uint = 0;
		protected var START:uint = 1;
		protected var MID:uint = 2;
		protected var WIN:uint = 3;
		
		protected var checkPoints:Array;
		public var boomerangs:FlxGroup;
		public var spikes:FlxGroup;
		protected var doors:FlxGroup;
		
		protected var bots:FlxGroup;
		protected var groups:Array;
		
		protected var timeStart:Number = 0;
		protected var timeEnd:Number = 0;
		protected var timeLeft:Number = 0;
		protected var timeTravelCountdown:Number = 0;
		
		protected var oldPlayersIndex:int;
		protected var oldPlayers:Array;
		
		protected var starfield:StarfieldFX;
		protected var cameraScrollVelocity:FlxPoint;
		protected var cameraPreviousScroll:FlxPoint;
		
		protected var feedback:Feedback;
		
		protected var runLevel:int;
		protected var staminaLevel:int;
		protected var healthLevel:int;
		protected var isFirstIteration:Boolean = false;
		
		protected var eyeCounter:Counter;
		protected var ammoCounter:Counter;
		protected var itemDisplays:Array;
		
		protected var teleportEmitter:FlxEmitter;
		protected var timeMachineEmitter:FlxEmitter;
		
		protected var textBox:TextBox;
		
		protected var newLevel:Boolean;
		
		public var bloodEmitters:FlxGroup;
        public function PlayState(startIndex:int = 0, oldPlayers:Array = null, runLevel:int = 0, staminaLevel:int = 0, healthLevel:int = 0, newLevel:Boolean = true)
		{
			this.startIndex = startIndex;
			this.oldPlayers = oldPlayers;
			this.cameraPreviousScroll = new FlxPoint();
			this.cameraScrollVelocity = new FlxPoint();
			this.bloodEmitters = new FlxGroup();
			this.runLevel = runLevel;
			this.staminaLevel = staminaLevel;
			this.healthLevel = healthLevel;
			this.newLevel = newLevel;
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
			starfield.create(0, 0, FlxG.width, FlxG.height, 100);
			starfield.active = true;
			starfield.sprite.scrollFactor.x = 0.0;
			starfield.sprite.scrollFactor.y = 0.0;
			starfield.setStarSpeed(-0.25, 0);
			
			//video feedback generator
			feedback = new Feedback(15, 12, FlxG.camera.buffer);
			timeTravelCountdown = 1.0;
			feedback.visible = true;
			
			//play the appropriate music depending on the checkpoint the player just came out of
			var bgm:FlxSound = FlxG.play(bgm1);
			if (startIndex == 0 && oldPlayers == null)
			{
				FlxG.play(fanfare);
				bgm.fadeIn(50);
			}
			else if (startIndex == 1 || startIndex == 2)
			{
				bgm.stop();
				bgm = FlxG.play(bgm1, 1, true);
			}
			else if (startIndex == 3 || startIndex == 4 || startIndex == 5)
			{
				bgm.stop();
				bgm = FlxG.play(bgm2, 1, true);
			}
			else if (startIndex == 6 || startIndex == 7 || startIndex == 8)
			{
				bgm.stop();
				bgm = FlxG.play(bgm3, 1, true);
			}
			else if (startIndex == 9 || startIndex == 10 || startIndex == 11)
			{
				bgm.stop();
				bgm = FlxG.play(bgm4, 1, true);
			}
			
			// warp effect
			teleportEmitter = new FlxEmitter(0, 0, 2000);
			teleportEmitter.particleClass = AdditiveFadingParticle;
			teleportEmitter.makeParticles(CircleParticle, 20);
			teleportEmitter.maxParticleSpeed.x = 1;
			teleportEmitter.minParticleSpeed.x = -1;
			teleportEmitter.maxParticleSpeed.y = 1;
			teleportEmitter.minParticleSpeed.y = -1;
			teleportEmitter.minRotation = 30;
			teleportEmitter.maxRotation = 60;
			timeMachineEmitter = new FlxEmitter(0, 0, 2000);
			timeMachineEmitter.particleClass = AdditiveFadingParticle;
			timeMachineEmitter.makeParticles(CircleParticle, 200);
			timeMachineEmitter.maxParticleSpeed.x = 1;
			timeMachineEmitter.minParticleSpeed.x = -1;
			timeMachineEmitter.maxParticleSpeed.y = 1;
			timeMachineEmitter.minParticleSpeed.y = -1;
			timeMachineEmitter.minRotation = -60;
			timeMachineEmitter.maxRotation = 60;

			add(starfield.sprite);
			add(feedback);
			add(level.tileMap);
			add(level.timeMachine);
			add(level.doors);
			add(level.doorSwitches);
			add(level.conveyors);
			add(level.spikepits);
			add(level.powerups);
			add(level.eyes);
			add(level.misc);
			add(level.countDowns);
			add(level.storyBoxes);
			add(teleportEmitter);
			add(timeMachineEmitter);
			timeEnd = level.checkPoints[startIndex].time;
			timeLeft = timeEnd; //level.checkPoints[startIndex].time;
			
			Hydraman.m_initialTimeLeft = timeLeft;
			// clock for the timemachine
			var timemachine_clock:CountDown = new CountDown();
			timemachine_clock.x = level.timeMachine.x + 18;
			timemachine_clock.y = level.timeMachine.y;
			level.countDowns.add(timemachine_clock);
			for (i = 0; i < level.countDowns.length; i++)
			{
				var countdown:CountDown = level.countDowns.members[i] as CountDown;
				countdown.setup(countdown.x, countdown.y, timeLeft);
			}
			
			for (i = 0; i < level.storyBoxes.length; i++)
			{
				StoryBox(level.storyBoxes.members[i]).setup();
			}
			for (i = 0; i < level.doors.length; i++)
			{
				Door(level.doors.members[i]).setup();
			}
			
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
				player = new Player(3008, 228);
				trace("No checkpoints");
				oldPlayersIndex = -1;
			}
			else if (oldPlayers != null && oldPlayers.length > 0) // asshole
			{
				trace("TIME TRAVEL!!!");
				player = oldPlayers[oldPlayers.length - 1].timeTravel(level.checkPoints[startIndex].x, level.checkPoints[startIndex].y, runLevel, staminaLevel, healthLevel);
				oldPlayersIndex = oldPlayers.length - 2;
			}
			else
			{
				player = new Player(level.checkPoints[startIndex].x, level.checkPoints[startIndex].y, runLevel, staminaLevel, healthLevel);
				// This is to make sure different poinwer for old player. Do not remoe
				oldPlayers = [new Player(level.checkPoints[startIndex].x, level.checkPoints[startIndex].y, runLevel, staminaLevel, healthLevel)];
				oldPlayers[0].startTime = timeEnd;
				oldPlayersIndex = -1;
			}
			
			cam = new FlxObject(level.timeMachine.x, level.timeMachine.y, 1, 1);
			cam.velocity.x = 0;
			cam.velocity.y = 0;
			camTarget = player;
			add(cam);
			
			teleportEmitter.x = player.x;
			teleportEmitter.y = player.y;
			teleportEmitter.start(true, 1.5, 0.1, 0);
			teleportEmitter.on = true;
			
			cameraScrollVelocity = new FlxPoint(0, 0);
			cameraPreviousScroll = new FlxPoint(player.x, player.y);
			characters.add(player);
			
			player.startTime = timeEnd;
			
			// bots
			bots = new FlxGroup();
			characters.add(bots);
			
			//set camera
			FlxG.camera.setBounds(-10000, 0, 20000, 24000, true);
			FlxG.camera.follow(cam, FlxCamera.STYLE_PLATFORMER);
			
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
			ammoCounter = new Counter(2, 29);
			
			add(hud);
			add(healthBar);
			add(staminaBar);
			add(eyeCounter);
			add(ammoCounter);
			itemDisplays = new Array()
			for (i = 0; i < 5; i++)
			{
				itemDisplays.push(new FlxSprite(16 + i * 14, 28));
				itemDisplays[i].loadGraphic(PowerupImage, true, false, 16, 16);
				itemDisplays[i].scrollFactor.x = itemDisplays[i].scrollFactor.y = 0;
				itemDisplays[i].addAnimation("boomerang", [0]);
				itemDisplays[i].addAnimation("doublejump", [1]);
				itemDisplays[i].addAnimation("stamina", [2]);
				itemDisplays[i].addAnimation("spikes", [3]);
				add(itemDisplays[i]);
			}

			add(countdown);
			
			textBox = new TextBox(0, 150);
			add(textBox);
			
			FlxG.flash(0xffffffff, 0.7);
			FlxG.play(ExplosionSnd);
			add(bloodEmitters);
			timeMachineEmitter.x = level.timeMachine.x + level.timeMachine.width/2;
			timeMachineEmitter.y = level.timeMachine.y + level.timeMachine.height/2;
			timeMachineEmitter.start(false, 1.0, 0.1);
			
			
			tiles = new Array();
			FlxG.globalSeed = 519074;
			var data:Array = level.tileMap.getData();
			for (x = 0; x < level.tileMap.widthInTiles; x++)
			{
				for (y = 0; y < level.tileMap.heightInTiles; y++)
				{
					i = y * level.tileMap.widthInTiles + x;
					if (data[i] > 0)
					{
						tiles.push(i);
					}
				}
			}
			groups = new Array(level.doors, level.doorSwitches, level.conveyors, level.spikepits, level.misc, level.countDowns);
			for each (var g:FlxGroup in groups)
			{
				for each (var s in g.members)
				{
					if (s is FlxSprite)
					{
						tiles.push(s);
					}
				}
			}
			function compare(a, b): int {
				var x1:int
				var x2:int;
				if (a is int)
					x1 = (a as int) % level.tileMap.widthInTiles * 32;
				else
					x1 = a.x as int;
				if (b is int)
					x2 = (b as int) % level.tileMap.widthInTiles * 32;
				else
					x2 = b.x as int;
					
				if (x1 < x2)
					return -1;
				else if (x1 > x2)
					return 1;
				else
					return 0;
			};
			tiles.sort(compare);
			
			timeStart = level.checkPoints[level.checkPoints.length - 1].time;
			timeEnd = level.checkPoints[startIndex].time;
			// formula for increasing falling blocks from start of level
			// # fallen blocks = accel * time^2/2     accel = blocks * 2 / time ^ 2
			// Calc intermediate 
			fallAccum = 0;
			fallRate = 0;
			fallAccel = 0;
			fallJerk = 0.8 * tiles.length * 6.0 / Math.pow(timeStart, 3.0); // Have all blocks fall by end of level
			
			fallBlocks = new FlxGroup();
			fallBGBlocks = new FlxGroup();
			add(fallBlocks);
			add(fallBGBlocks);
			
			// Simulate the falling from the start time until the current time
			for (timeLeft = timeStart; timeLeft > timeEnd; timeLeft -= FlxG.elapsed)
			{
				updateFallingBlocks();
				fallBlocks.preUpdate();
				fallBlocks.update();
				fallBlocks.postUpdate();
			}
			timeLeft = timeEnd;
			
			super.update();
		}
		
		protected function updateFallingBlocks():void
		{
			// Update falling blocks
			// Remove blocks out of view
			var i:int;
			var block:FlxSprite;
			for (i = fallBlocks.length - 1; i >= 0; i--)
			{
				block = fallBlocks.members[i];
				if (block == null || block.y > FlxG.camera.bounds.y + FlxG.camera.bounds.height)
				{
					fallBlocks.remove(block);
				}
			}
			for (i = fallBGBlocks.length - 1; i >= 0; i--)
			{
				block = fallBGBlocks.members[i];
				if (block == null || block.y > FlxG.camera.bounds.y + FlxG.camera.bounds.height)
				{
					fallBGBlocks.remove(block);
				}
			}
			// Add more falling blocks as needed
			fallAccum += fallRate * FlxG.elapsed + 0.5 * fallAccel * FlxG.elapsed * FlxG.elapsed + 1.0 / 6.0 * fallJerk * FlxG.elapsed * FlxG.elapsed * FlxG.elapsed;
			fallRate += fallAccel * FlxG.elapsed + 0.5 * fallJerk * FlxG.elapsed * FlxG.elapsed;
			fallAccel += fallJerk * FlxG.elapsed;
			if (fallAccum >= 1)
			{
				var xmax:int = int(Math.pow(1.0 - timeLeft / timeStart, 2.0) * level.tileMap.width);
				var imax:int = 0;
				while (imax < tiles.length)
				{
					var o = tiles[imax];
					var x:int;
					if (o is int)
						x = o % level.tileMap.widthInTiles * 32;
					else
						x = o.x;
					if (x >= xmax)
						break;
					imax++;
				}
				while (fallAccum >= 1 && imax > 0)
				{
					fallAccum--;
					var o = tiles.splice(int(Math.abs(FlxG.random()) * imax), 1)[0];
					var s:FlxSprite;
					imax--;
					if (o is int)
					{
						var tile_idx:uint = level.tileMap.getTileByIndex(o);
						level.tileMap.setTileByIndex(o, 0);
						
						s = new FlxSprite((o % level.tileMap.widthInTiles) * 32, (o / level.tileMap.widthInTiles) * 32 - 22);
						s.loadGraphic(level.Image, true, true, 32, 32);
						s.addAnimation("idle", [tile_idx]);
						s.play("idle");
						s.mass = 5.0;
						if (tile_idx >= 25)
						{
							fallBlocks.add(s);
						}
						else
						{
							fallBGBlocks.add(s);
						}
					}
					else
					{
						s = o;
						fallBlocks.add(s);
						
						for each (var g:FlxGroup in groups)
						{
							g.remove(o);
						}
					}
					s.immovable = false;
					s.moves = true;
					s.velocity.x = 0;
					s.velocity.y = 10;
					s.angularVelocity = 0;
					s.maxVelocity.x = 50.0;
					s.maxVelocity.y = GRAVITY;
					s.maxAngular = 360.0;
					s.acceleration.x = 20.0 * (Math.abs(FlxG.random()) - 0.5);
					s.acceleration.y = 0.25 * GRAVITY;
					s.angularAcceleration = 90.0 * Math.abs(FlxG.random());
				}
			}
		}
		
		protected function fallingBlockCollide(Object1:FlxObject, Object2:FlxObject):void
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
			if (nvy > 0 || block.y > char.y)
				return;
			char.hit(4, char.squash);
		}
		
		override public function update():void
		{
			// move camera towards target
			var diffX:Number = camTarget.x - cam.x;
			var diffY:Number = camTarget.y - cam.y;
			cam.velocity.x += cam.velocity.x * -0.1 + diffX * 0.5;
			cam.velocity.y += cam.velocity.y * -0.1 + diffY * 0.5;
			
			timeLeft -= FlxG.elapsed;
			timeTravelCountdown = Math.max(0, timeTravelCountdown - FlxG.elapsed);
			if (timeLeft < 0)
			{
				timeLeft = 0;
			}
			if (oldPlayersIndex >= 0 && oldPlayers[oldPlayersIndex] && oldPlayers[oldPlayersIndex].startTime > timeLeft)
			{
				trace("OLD BOT NUMBER ", oldPlayersIndex);
				var past_self:Player = oldPlayers[oldPlayersIndex];
				//trace("add bots " + timeLeft + " " + past_self.startTime + " " + past_self.startX + " " + past_self.startY + " " + past_self.m_waypoints.length);
				var toAdd:Bot = new Bot(past_self);
				bots.add(toAdd);
				teleportEmitter.x = toAdd.x;
				teleportEmitter.y = toAdd.y;
				teleportEmitter.start(true, 1.5, 0.1, 0);
				teleportEmitter.on = true;
				oldPlayersIndex--;
			}
			
			if (timeTravelCountdown == 0)
			{
				if (feedback.visible)
				{
					FlxG.flash(0x0, 0.7);
					feedback.visible = false;
				}
				super.update();
			}
			else
			{
				if (teleportEmitter.on)
					teleportEmitter.update();
				cam.preUpdate();
				cam.update();
				cam.postUpdate();
			}
			
			cameraScrollVelocity.x = cameraPreviousScroll.x - FlxG.camera.scroll.x;
			cameraScrollVelocity.y = cameraPreviousScroll.y - FlxG.camera.scroll.y;
			
			cameraPreviousScroll.x = FlxG.camera.scroll.x;
			cameraPreviousScroll.y = FlxG.camera.scroll.y;
			
			feedback.update();
			
			var i:int;
			var s:FlxSprite;
			while (level.misc.remove(null))
			{
			}
			
			FlxG.collide(level.tileMap, characters);
			FlxG.collide(level.tileMap, spikes);
			FlxG.collide(level.tileMap, level.eyes);
			FlxG.collide(level.doors, characters, Door.crush);
			FlxG.collide(level.doors, level.eyes);
			FlxG.collide(level.conveyors, characters, Conveyor.overlap);
			FlxG.collide(level.spikepits, characters, SpikePit.overlap);
			FlxG.overlap(level.powerups, characters, PowerupEntity.overlapCharacter);
			FlxG.overlap(level.doorSwitches, characters, DoorSwitch.overlap);
			FlxG.overlap(level.eyes, player, Eye.overlapPlayer);
			FlxG.overlap(boomerangs, characters, Boomerang.overlapCharacter);
			FlxG.overlap(boomerangs, spikes, SpikeTrap.overlapBoomerang);
			FlxG.overlap(spikes, characters, SpikeTrap.overlapCharacter);
			FlxG.overlap(level.storyBoxes, player, overlapStoryBox);
			FlxG.collide(fallBlocks, characters, fallingBlockCollide);
			for each(var emit:FlxEmitter in bloodEmitters.members)
			{
				for each(var part:FlxParticle in emit.members)
				{
					FlxG.collide(level.tileMap, part);
				}
			}
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
			var p:AmmoPowerup = (player.getCurrentPowerup() as AmmoPowerup);
			if (p != null)
				ammoCounter.value = p.ammo;
			else
				ammoCounter.value = 0;
		}
		
		public function debugShit():void
		{
		/*if (FlxG.keys.justPressed("B"))
		   {
		   //BRUCE
		   var bt:Bot = new Bot(player);
		   bots.add(bt);
		   FlxG.flash(0x0, 0.5);
		   FlxG.camera.follow(bt);
		   trace(player.x, player.y);
		 }*/
		}
		
		public function transitionState(newState:uint):void
		{
			state = newState;
			switch (state)
			{
				case START: 
					break;
				case MID: 
					break;
				case END: 
					FlxSpecialFX.remove(starfield);
					remove(starfield.sprite);
					FlxG.play(ExplosionSnd);
					if (winner)
						FlxG.fade(0xffffff, 2.5, restartLevel);
					else
						FlxG.fade(0xffffff, 2.5, gameOver);
					break;
				case WIN:
					FlxSpecialFX.remove(starfield);
					remove(starfield.sprite);
					FlxG.fade(0xffffff, 1.5, beatGame);
					break;
				default:
					break;
			}
		}
		
		private function updateStateEvents():void
		{
			switch (state)
			{
				case START: 
					break;
				case MID: 
					if (timeLeft <= 0)
					{
						endGame();
					}
					FlxG.overlap(player, level.timeMachine, reachGoal);
					FlxG.overlap(bots, level.timeMachine, loseToBot);
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
				oldPlayers.pop();
				var time:Number = level.checkPoints[bestIndex].time;
				while (oldPlayers.length > 0 && oldPlayers[oldPlayers.length - 1].startTime >= time)
				{
					oldPlayers.pop();
				}
				player.startTime = timeEnd;
				oldPlayers.push(player);
			}
			else if (bestIndex > startIndex)
			{
				// We do this because the previous image should have the stats we had at the start of the run,
				// but move like we did to complete the run
				var previous:Player = oldPlayers[oldPlayers.length - 1];
				previous.startTime = player.startTime;
				previous.startX = player.startX;
				previous.startY = player.startY;
				previous.m_waypoints = player.m_waypoints;
				previous.m_stateHistory = player.m_stateHistory;
				oldPlayers.push(player);
			}
			else
			{
				oldPlayers[oldPlayers.length - 1] = player;
			}
			FlxG.switchState(new TransState(bestIndex, level.checkPoints[bestIndex].time, oldPlayers, player, (bestIndex != startIndex)));
		}
		
		private function overlapStoryBox(a:FlxObject, b:FlxObject):void
		{
			var sb:StoryBox = StoryBox(a);
			if (newLevel)
			{
				if (sb.level == startIndex)
				{
					sb.exists = false;
					textBox.refresh(sb.text);
				}
			}
		}
		
		private function loseToBot(a:FlxObject, b:FlxObject):void
		{
			winner = false;
			//FlxG.camera.follow(a);
			camTarget = a;
			FlxG.flash(0x0, 0.5);
			if (!feedback.visible)
			{
				a.update();
				feedback.visible = true;
				timeTravelCountdown = 2.5;
			}
			transitionState(END);
		
			//gameOver();
		}
		
		private function reachGoal(a:FlxObject, b:FlxObject):void
		{
			winner = true;
			if (!feedback.visible)
			{
				a.update();
				feedback.visible = true;
				timeTravelCountdown = 1.5;
			}
			transitionState(END);
		}
		
		private function endGame():void
		{
			FlxG.fade(0xff000000, 1, gameOver);
		}
		
		private function gameOver():void
		{
			FlxSpecialFX.remove(starfield);
			
			FlxG.switchState(new GameOverState(startIndex, level.checkPoints[startIndex].time, oldPlayers));
		}
	
		private function beatGame():void
		{
			FlxSpecialFX.remove(starfield);
			
			FlxG.switchState(new WinState());
		}
		
	}
}
