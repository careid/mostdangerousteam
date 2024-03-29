package
{
	import flash.utils.Dictionary;
	import org.flixel.*;

	public class Character extends FlxSprite
	{
		[Embed(source = "./graphics/Cloud003.png")] public var Cloud:Class;
		[Embed(source = "./graphics/pop.png")] public var ImgPop:Class;
		[Embed(source = "./graphics/zap.png")] public var ImgZap:Class;
		[Embed(source = "./graphics/blood.png")] public var bloodDrop:Class;
		[Embed(source = "./graphics/spark.png")] public var spark:Class;
		
		[Embed(source = "./sounds/playerJump.mp3")] public var JumpSnd:Class;
		[Embed(source = "sounds/playerDeath.mp3")] public var DeathSnd:Class;
		[Embed(source = "sounds/footstep.mp3")] public var DashSnd:Class;
		[Embed(source = "./sounds/hydramanSad.mp3")] public var StaminaSnd:Class;
		[Embed(source = "./sounds/jetPackOn.mp3")] public var RocketSnd:Class;
		
		protected var pop: FlxSprite;
		
		// for bots
		public var canFuckUp:Boolean;
		
		public const OVER_SQRT2:Number = 0.707107;
		
		protected var m_isDashing:Boolean;
		protected var m_speed:Number;
		protected var m_walk_speed:Number;
		protected var m_walk_stamina:Number;
		protected var m_run_speed:Number;
		protected var m_dash_speed:Number;
		protected var m_accel_constant:Number;
		
		public var max_health:Number;
		
		protected var m_jump_cost:Number;
		protected var m_jump_power:Number;
		protected var m_wall_friction:Number;
		
		public var stamina:Number;
		public var maxstamina:Number;
		protected var staminaregen:Number;
		
		public var m_recharge : Number;
		protected var m_powerupList : Array;
		protected var m_currentPowerup : Powerup;
		public var m_dustEmitter : FlxEmitter;
		protected var m_sliding : Boolean;
		
		public var goLeft:Boolean;
		public var goRight:Boolean;
		public var doJump:Boolean;
		public var doDash:Boolean;
		public var usePowerup:Boolean;
		public var changePowerup:Boolean;
		
		public var playSounds:Boolean;
		
		public var playingDeathAnimation:Boolean;
		
		public function Character(X:int=0,Y:int=0,playSounds:Boolean=false)
		{
			m_powerupList = new Array();
			m_currentPowerup = null;

			m_sliding = false;
			this.playSounds = playSounds;

			playingDeathAnimation = false;
			super(X,Y);
		}
		
		public function copyPowerups(old_character:Character):void
		{
			m_powerupList = new Array();
			if (old_character.getCurrentPowerup() != null)
			{
				if (old_character.getCurrentPowerup() is SpikePowerup)
				{
					m_currentPowerup = new SpikePowerup();
					(m_currentPowerup as SpikePowerup).ammo = (old_character.getCurrentPowerup() as SpikePowerup).ammo;
					addPowerup(m_currentPowerup);
				}
				else if (old_character.getCurrentPowerup() is BoomerangPowerup)
				{
					m_currentPowerup = new BoomerangPowerup();
					(m_currentPowerup as BoomerangPowerup).ammo = (old_character.getCurrentPowerup() as BoomerangPowerup).ammo;
					addPowerup(m_currentPowerup);
				}
				else if (old_character.getCurrentPowerup() is ShieldPowerup)
				{
					m_currentPowerup = new ShieldPowerup();
					(m_currentPowerup as ShieldPowerup).ammo = (old_character.getCurrentPowerup() as ShieldPowerup).ammo;
					addPowerup(m_currentPowerup);
				}
				else if (old_character.getCurrentPowerup() is TaserPowerup)
				{
					m_currentPowerup = new TaserPowerup();
					(m_currentPowerup as TaserPowerup).ammo = (old_character.getCurrentPowerup() as TaserPowerup).ammo;
					addPowerup(m_currentPowerup);
				}
				else
				{
					trace("Unknown powerup: %s", old_character.getCurrentPowerup().animationName);
					m_currentPowerup = null;
				}
			}
			
			for each (var powerup:Powerup in old_character.getPowerupList())
			{
				if (powerup != old_character.getCurrentPowerup() )
				{
					var newPowerup : Powerup;
					
					if (powerup is SpikePowerup)
					{
						newPowerup = new SpikePowerup();
						(newPowerup as SpikePowerup).ammo = (powerup as SpikePowerup).ammo;
					}
					else if (powerup is BoomerangPowerup)
					{
						newPowerup = new BoomerangPowerup();
					}
					else if (powerup is ShieldPowerup)
					{
						newPowerup = new ShieldPowerup();
					}
					else if (powerup is TaserPowerup)
					{
						newPowerup = new TaserPowerup();
					}
					else // do nothing with unknown powerups
					{
						trace("Unknown powerup: %s", powerup.animationName);
						continue;
					}
					
					addPowerup(newPowerup);
				}
			}
		}
		
		public function setup(run_speed:int=100,dash_speed:int=200,staminaregen:Number=1.0,maxstamina:Number=50,health:Number=10):void
		{
			m_isDashing = false;
			m_walk_stamina = 25;
			m_walk_speed = 0.3 * run_speed;
			m_run_speed = run_speed;
			m_dash_speed = dash_speed;
			m_speed = m_run_speed;
			drag.x = 240;
			m_accel_constant = 4.0;
			maxVelocity.x = m_run_speed;
			
			m_recharge = 0;
			
			acceleration.y = PlayState.GRAVITY;
			m_wall_friction = 10;
			
			m_jump_power = 150;
			m_jump_cost = 13;
			maxVelocity.y = m_jump_power;
			
			this.staminaregen = staminaregen;
			this.maxstamina = maxstamina;
			stamina = maxstamina;
			
			max_health = health;
			this.health = health;
		
			m_dustEmitter = new FlxEmitter();
			m_dustEmitter.particleClass = AdditiveFadingParticle;
			m_dustEmitter.makeParticles(Cloud, 1000);
			m_dustEmitter.particleDrag.x = 100;
			m_dustEmitter.particleDrag.y = 100;
			m_dustEmitter.maxParticleSpeed.x = 10;
			m_dustEmitter.maxParticleSpeed.y = 10;
			m_dustEmitter.minParticleSpeed.x = -10;
			m_dustEmitter.minParticleSpeed.y = -10;
			FlxG.state.add(m_dustEmitter);			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 4], 12);
			addAnimation("jump", [5, 6],12);
			addAnimation("fall", [7, 8], 12);
			addAnimation("dash", [9, 10, 11, 12],18);
			addAnimation("wallslide", [13], 12);
			addAnimation("pop", [14, 15, 16, 17, 18, 19, 20, 21], 10, false);
			addAnimation("squash", [22, 23, 24, 25, 26, 27], 10, false);
			addAnimation("tired idle", [28, 29, 30], 6, true);
			addAnimation("tired run", [31, 32, 33, 34], 6, true);
		}
		
		override public function update():void
		{
			var playState:PlayState = FlxG.state as PlayState;
			if (y > playState.LEVELBOTTOM)
			{
				playState.characters.remove(this);
				kill();
			}
			
			var isTouchingFloor:Boolean = isTouching(FLOOR);
			var isTouchingLeft:Boolean = isTouching(LEFT);
			var isTouchingRight:Boolean = isTouching(RIGHT);
			
			// VELOCITY
			if (m_isDashing)
			{
				if (isTouchingFloor)
				{
					FlxG.play(DashSnd);
				}
				stamina = Math.max(0, stamina - 1);
				
				if (doDash == false || stamina <= 0)
				{
					if (stamina <= 0)
						FlxG.play(StaminaSnd);
					m_isDashing = false;
					m_dustEmitter.on = false;
				}
			}
			else
			{
				if (isTouchingFloor)
				{
					if (velocity.x == 0)
						stamina = Math.min(maxstamina, stamina + staminaregen);
					else
						stamina = Math.min(maxstamina, stamina + 0.75 * staminaregen);
				}
				else if (isTouchingLeft || isTouchingRight)
				{
					stamina = Math.min(maxstamina, stamina + 0.5 * staminaregen);
				}
				else if (velocity.y >= 0)
				{
					stamina = Math.min(maxstamina, stamina + 0.25 * staminaregen);
				}
				if (stamina < m_walk_stamina)
				{
					if (maxVelocity.x > m_walk_speed)
					{
						m_isDashing = false;
						m_dustEmitter.on = false;
						m_speed = m_walk_speed;
						if (isTouchingFloor)
							maxVelocity.x = m_walk_speed;
					}
				}
				else if (doDash)
				{
					m_isDashing = true;
			        if (Math.abs(velocity.x) > 0.1)
					{
						m_dustEmitter.on = true;
					}
					m_dustEmitter.start(false, 1.5, 0.1);
					m_speed = m_dash_speed;
					maxVelocity.x = m_dash_speed;
				}
				else if (maxVelocity.x != m_run_speed)
				{
					m_isDashing = false;
					m_dustEmitter.on = false;
					m_speed = m_run_speed;
					maxVelocity.x = m_run_speed;
				}
			}
			
			// JUMPING
			if(doJump && (stamina > m_jump_cost || isTouchingFloor))
			{
				m_dustEmitter.on = false;
				if (isTouchingFloor)
				{
					velocity.y = -m_jump_power;
					if (playSounds)
						FlxG.play(JumpSnd);
				}
				else if (isTouchingLeft)
				{
					velocity.y = -1.5 * m_jump_power;
					velocity.x = 1.0 * m_jump_power;
					stamina -= m_jump_cost;
				}
				else if (isTouchingRight)
				{
					velocity.y = -1.5 * m_jump_power;
					velocity.x = -1.0 * m_jump_power;
					stamina -= m_jump_cost;
					if (playSounds)
						FlxG.play(RocketSnd);
				}
				/*
				else
				{
					velocity.y = -m_jump_power;
					if (playSounds)
						FlxG.play(JumpSnd);
				}
				*/
			}
			
			// FRICTION
			if (velocity.y > 0 && ((isTouchingLeft && goLeft) || (isTouchingRight && goRight)))
			{
				acceleration.y = PlayState.GRAVITY - velocity.y * m_wall_friction;
				
				if (Math.abs(velocity.x) > 0.1)
				{
					m_dustEmitter.on = true;
				}
		
				
				if (!m_sliding)
				{
					m_dustEmitter.start(false, 1.5, 0.1);
					m_sliding = true;
				}
			}
			else
			{
				acceleration.y = PlayState.GRAVITY;
				m_sliding = false;
			}
			
			// ACCELERATION
			if(goLeft)
			{
				facing = LEFT;
				acceleration.x = -m_accel_constant * m_speed;
			}
			else if(goRight)
			{
				facing = RIGHT;				
				acceleration.x = m_accel_constant * m_speed;
			}
			else
			{
				acceleration.x = 0;
			}
			
			if (!playingDeathAnimation)
			{
				// ANIMATION
				if(velocity.y < 0)
				{
					play("jump");
				}
				else if (velocity.y > 0)
				{
					if (isTouchingLeft || isTouchingRight)
						play("wallslide");
					else
						play("fall");
				}
				else if(velocity.x == 0)
				{
					if (stamina < m_walk_stamina)
						play("tired idle");
					else
						play("idle");
				}
				else if (maxVelocity.x == m_dash_speed)
				{
					play("dash");
				}
				else
				{
					if (maxVelocity.x < m_run_speed)
						play("tired run");
					else
						play("run");
				}
			}
			
			// POWERUPS
			if (changePowerup)
				cyclePowerups();
			m_recharge = Math.max(0, m_recharge - FlxG.elapsed);
			if (usePowerup && m_currentPowerup != null && m_recharge == 0)
			{
				trace("Activating");
				activateCurrentPowerup();
				m_recharge = 0.5;
			}
			
			if (m_currentPowerup != null)
			{
				if (m_currentPowerup.shouldBeDiscarded)
				{
					trace("should remove " + m_currentPowerup);
					var index:int = m_powerupList.indexOf(m_currentPowerup);
					m_powerupList.splice(index, 1);
					if (m_powerupList.length == 0)
					{
						m_currentPowerup = null;
					}
					else
					{
						m_currentPowerup = m_powerupList[index % m_powerupList.length];
					}
				}
				else
				{
					m_currentPowerup.update();
				}
			}
			m_dustEmitter.x = x + 5;
			m_dustEmitter.y = y + 20;
			m_dustEmitter.setXSpeed(-velocity.x/3 + 5, velocity.x/3 - 5);
			m_dustEmitter.setYSpeed(-velocity.y/3 + 5, velocity.y/3 - 5);
			
			if (playingDeathAnimation)
			{
				m_dustEmitter.on = false;
				velocity.x = 0;
				velocity.y = 0;
				if (finished)
				{
					this.kill();
				}
			}
			super.update();
		}
		
		/////
		/// Goes to the next available powerup 
		/////
		public function cyclePowerups() : void
		{
			if (m_currentPowerup == null)
			{
				if (m_powerupList.length > 0)
				{
					m_currentPowerup = m_powerupList[0];
				}
			}
			else
			{
				var desiredIndex:int = m_powerupList.indexOf(m_currentPowerup) + 1
				if (desiredIndex < m_powerupList.length)
				{
					m_currentPowerup = m_powerupList[desiredIndex];
				}
				else
				{
					m_currentPowerup = m_powerupList[0];
				}
			}
		}
		
		public function selectBoomerang() : void
		{
			if (m_currentPowerup != null)
			{
				if (m_currentPowerup.animationName != "boomerang")
				{
					trace("Select boomerang");
					cyclePowerups();
				}
				else
					trace("boomerang already selected");
			}
		}
		
		public function selectSpikes():void
		{
			if (m_currentPowerup != null)
			{
				if (m_currentPowerup.animationName != "spikes")
				{
					trace("Select spikes");
					cyclePowerups();
				}
				else
					trace("spikes already selected");
			}
		}
		
		/////
		/// Returns the current powerup.
		/////
		public function getCurrentPowerup() : Powerup
		{
			return m_currentPowerup;
		}
		
		public function getPowerupList() : Array
		{
			return m_powerupList;
		}
		
		/////
		/// Adds the given powerup to the powerup list.
		/////
		public function addPowerup(powerup : Powerup) : void
		{
			// Only add powerups of unique types.
			for each(var p : Powerup in m_powerupList)
			{
				if (p.animationName == powerup.animationName)
				{
					if (p is AmmoPowerup)
					{
						(p as AmmoPowerup).ammo += (powerup as AmmoPowerup).ammo;
					}
					return;
				}
			}
			
			if (!powerup.shouldBeDiscarded)
			{
				m_powerupList.push(powerup);
				powerup.character = this;
				powerup.onAdd();
				if (m_currentPowerup == null)
				{
					m_currentPowerup = powerup;
				}
			}
		}
		
		/////
		/// Gets a pointer to a powerup of a given type if it exists, or null otherwise.
		/////
		public function getPowerupOfType(type : Class) : Powerup
		{
			for (var i:Number = 0; i < m_powerupList.length; i++)
			{
				if (m_powerupList[i] is type)
				{
					return m_powerupList[i];
				}
			}
			
			return null;
		}
		
		/////
		/// Activates the current powerup, if it exists. If the powerup should be discarded,
		/// removes
		/////
		public function activateCurrentPowerup(target:Character = null) : void
		{
			if (m_currentPowerup != null && !m_currentPowerup.shouldBeDiscarded)
			{
				m_currentPowerup.activate(target)
				if ( m_currentPowerup.shouldBeDiscarded || !m_currentPowerup.continuousUse )
					usePowerup = false;
			}
			else if (m_currentPowerup != null && m_currentPowerup.shouldBeDiscarded)
			{
				m_powerupList.splice(m_powerupList.indexOf(m_currentPowerup),1);
				m_currentPowerup = null;
			}
		}
		
		public function hit(damage:int, death:Function):Boolean
		{
			if (flickering)
				return false;
				
			health -= damage;
			if (health <= 0)
			{
				death();
			}
			else
			{
				flicker(0.5);
			}
			trace(health);
			return true;
		}
		
		public function squash():void
		{
			FlxG.play(DeathSnd);
			play("squash");
			playingDeathAnimation = true;
			
			this.solid = false;
			this.acceleration.x = 0;
			this.acceleration.y = 0;
		}
		
		public function electrocute():void
		{
			FlxG.play(DeathSnd);
			pop = new FlxSprite(x, y, ImgZap);
			pop.facing = facing;
			pop.offset.x = 1;
			pop.loadGraphic(ImgZap, true, true);
			pop.addAnimation("zap", [0, 1], 18, true);
			pop.play("zap");
			(FlxG.state as PlayState).level.misc.add(pop);
			visible = false;
			
			// particles
			var sparkEmitter:FlxEmitter = new FlxEmitter();
			sparkEmitter.x = x;
			sparkEmitter.y = y;
			sparkEmitter.particleClass = AdditiveFadingParticle;
			sparkEmitter.makeParticles(spark, 20);
			sparkEmitter.gravity = 0;
			sparkEmitter.particleDrag.x = 100;
			sparkEmitter.particleDrag.y = 100;
			sparkEmitter.start(true, 0.5, 0.1, 20);
			FlxG.state.add(sparkEmitter);
			
			this.solid = false;
			this.acceleration.x = 0;
			this.acceleration.y = 0;
		}
		
		public function die():void
		{
			FlxG.play(DeathSnd);
			play("pop");
			playingDeathAnimation = true;
			pop = new FlxSprite(x, y, ImgPop);
			pop.facing = facing;
			pop.offset.x = 24;
			pop.loadGraphic(ImgPop, true, true);
			pop.addAnimation("pop", [0, 1, 2, 3, 4, 5, 6, 7], 10, false);
			pop.play("pop");
			velocity.x = 0;
			velocity.y = 0;
			(FlxG.state as PlayState).level.misc.add(pop);
			
			
			// particles
			if (visible)
			{
				var bloodEmitter:FlxEmitter = new FlxEmitter();
				bloodEmitter.x = x;
				bloodEmitter.y = y;
				
				bloodEmitter.makeParticles(bloodDrop, 80,16,false, 0.8);
				bloodEmitter.particleDrag.x = 300;
				bloodEmitter.particleDrag.y = 300;
				bloodEmitter.minParticleSpeed.x = -100;
				bloodEmitter.maxParticleSpeed.x = 100;
				bloodEmitter.minParticleSpeed.y = -100;
				bloodEmitter.maxParticleSpeed.y = 100;
				bloodEmitter.setXSpeed( -100, 100);
				bloodEmitter.setYSpeed( -100, 100);
				bloodEmitter.gravity = 800;
				bloodEmitter.start(true, 2.0);
				(FlxG.state as PlayState).bloodEmitters.add(bloodEmitter);
			}
			
			visible = false;
			
			this.solid = false;
			this.acceleration.x = 0;
			this.acceleration.y = 0;
			
		}
	}
}