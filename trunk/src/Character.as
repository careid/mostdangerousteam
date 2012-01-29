package
{
	import flash.utils.Dictionary;
	import org.flixel.*;

	public class Character extends FlxSprite
	{
		[Embed(source = "./graphics/Cloud003.png")] public var Cloud:Class;
		[Embed(source = "./graphics/pop.png")] public var ImgPop:Class;
		[Embed(source = "./graphics/blood.png")] public var bloodDrop:Class;
		
		[Embed(source = "./sounds/playerJump.mp3")] public var JumpSnd:Class;
		[Embed(source = "sounds/playerJump.mp3")] public var DeathSnd:Class;
		[Embed(source = "sounds/dashOn.mp3")] public var DashSnd:Class;
		
		protected var pop: FlxSprite;
		
		// for bots
		public var canFuckUp:Boolean;
		
		public const OVER_SQRT2:Number = 0.707107;
		
		protected var m_dashing:Boolean;
		protected var m_speed:Number;
		protected var m_run_speed:Number;
		protected var m_dash_speed:Number;
		protected var m_accel_constant:Number;
		
		public var max_health:Number;
		
		public var jumps:int;
		protected var m_remaining_jumps:int;
		protected var m_jump_power:Number;
		protected var m_wall_friction:Number;
		
		public var stamina:Number;
		public var maxstamina:Number;
		protected var staminaregen:Number;
		
		protected var m_powerupList : Array;
		protected var m_currentPowerup : Powerup;
		protected var m_dustEmitter : FlxEmitter;
		protected var m_sliding : Boolean;
		
		public var goLeft:Boolean;
		public var goRight:Boolean;
		public var jump:Boolean;
		public var dash:Boolean;
		public var usePowerup:Boolean;
		
		public var playSounds:Boolean;
		
		public var playingDeathAnimation:Boolean;
		
		public function Character(X:int=0,Y:int=0,playSounds:Boolean=false)
		{
			m_powerupList = new Array();
			m_currentPowerup = null;
			m_dustEmitter = new FlxEmitter();
			m_dustEmitter.particleClass = AdditiveFadingParticle;
			m_dustEmitter.makeParticles(Cloud, 1000);
			m_dustEmitter.particleDrag.x = 300;
			m_dustEmitter.particleDrag.y = 300;
			m_dustEmitter.maxParticleSpeed.x = 100;
			m_dustEmitter.maxParticleSpeed.y = 100;
			m_sliding = false;
			this.playSounds = playSounds;
			FlxG.state.add(m_dustEmitter);
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
				}
				else if (old_character.getCurrentPowerup() is BoomerangPowerup)
				{
					m_currentPowerup = new BoomerangPowerup();
				}
				else if (old_character.getCurrentPowerup() is ChargingPowerup)
				{
					m_currentPowerup = new ChargingPowerup((old_character.getCurrentPowerup() as ChargingPowerup).maxCharge, (old_character.getCurrentPowerup() as ChargingPowerup).chargeRate);
				}
				else if (old_character.getCurrentPowerup() is StaminaRechargePowerup)
				{
					m_currentPowerup = new StaminaRechargePowerup();
				}
				else if (old_character.getCurrentPowerup() is AutoUsePowerup)
				{
					m_currentPowerup = new AutoUsePowerup();
				}
				else if (old_character.getCurrentPowerup() is AmmoPowerup)
				{
					m_currentPowerup = new AmmoPowerup((old_character.getCurrentPowerup() as AmmoPowerup).ammo);
				}
				else if (old_character.getCurrentPowerup() is Powerup)
				{
					m_currentPowerup = new Powerup();
				}
				addPowerup(m_currentPowerup);
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
					else if (powerup is ChargingPowerup)
					{
						newPowerup = new ChargingPowerup((powerup as ChargingPowerup).maxCharge, (powerup as ChargingPowerup).chargeRate);
					}
					else if (powerup is StaminaRechargePowerup)
					{
						newPowerup = new StaminaRechargePowerup();
					}
					else if (powerup is AutoUsePowerup)
					{
						newPowerup = new AutoUsePowerup();
					}
					else if (powerup is AmmoPowerup)
					{
						newPowerup = new AmmoPowerup((powerup as AmmoPowerup).ammo);
					}
					else if (powerup is Powerup)
					{
						newPowerup = new Powerup();
					}
					
					addPowerup(newPowerup);
				}
			}
		}
		
		public function setup(run_speed:int=60,dash_speed:int=120,staminaregen:Number=0.1,maxstamina:Number=100,health:Number=10):void
		{
			m_dashing = false;
			m_run_speed = run_speed;
			m_dash_speed = dash_speed;
			m_speed = m_run_speed;
			drag.x = 240;
			m_accel_constant = 4.0;
			maxVelocity.x = m_run_speed;
			
			acceleration.y = PlayState.GRAVITY;
			m_wall_friction = 10;
			
			jumps = 3;
			m_remaining_jumps = jumps;
			m_jump_power = 200;
			maxVelocity.y = m_jump_power;
			
			this.staminaregen = staminaregen;
			this.maxstamina = maxstamina;
			stamina = maxstamina;
			
			max_health = health;
			this.health = health;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 4], 12);
			addAnimation("jump", [5, 6],12);
			addAnimation("fall", [7, 8], 12);
			addAnimation("dash", [9, 10, 11, 12],18);
			addAnimation("wallslide", [13], 12);
			addAnimation("pop", [14, 15, 16, 17, 18, 19, 20, 21], 10, false);
			addAnimation("squash", [22, 23, 24, 25, 26, 27], 10, false);
		}
		
		override public function update():void
		{
			if (y > (FlxG.state as PlayState).LEVELBOTTOM)
			{
				kill();
				return;
			}
			var isTouchingFloor:Boolean = isTouching(FLOOR);
			var isTouchingLeft:Boolean = isTouching(LEFT);
			var isTouchingRight:Boolean = isTouching(RIGHT);
			
			// DASHING
			if (m_dashing)
			{
				stamina--;

				if (stamina <= 0 || dash == false)
				{
					m_dashing = false;
					m_dustEmitter.on = false;
				}
			}
			else
			{
				stamina = Math.min(maxstamina, stamina + staminaregen);
				if (dash && stamina > 0.25 * maxstamina)
				{
					if (playSounds)
					{
						//play dash sound
					}
					m_dashing = true;
					m_speed = m_dash_speed;
					maxVelocity.x = m_dash_speed;
					m_dustEmitter.start(false, 1.5, 0.1);
					m_dustEmitter.on = true;
				}
				else
				{
					m_dashing = false;
					m_speed = m_run_speed;
					maxVelocity.x = m_run_speed;
					m_dustEmitter.on = false;
				}
			}
			
			// JUMPING
			if (justTouched(FLOOR))
			{
				m_remaining_jumps = jumps;
			}
			if(jump)
			{
				if (isTouchingFloor && m_remaining_jumps > 0)
				{
					if (playSounds)
					{
						FlxG.play(JumpSnd);
					}
					m_remaining_jumps--;
					m_dashing = false;
					velocity.y = -m_jump_power;
					m_dustEmitter.on = false;
				}
				else if (isTouchingLeft)
				{
					if (playSounds)
					{
						FlxG.play(JumpSnd);
					}
					m_dashing = false;
					velocity.y = OVER_SQRT2 * -m_jump_power;
					velocity.x = OVER_SQRT2 * m_jump_power;
					m_dustEmitter.on = false;
				}
				else if (isTouchingRight)
				{
					if (playSounds)
					{
						FlxG.play(JumpSnd);
					}
					m_dashing = false;
					velocity.y = OVER_SQRT2 * -m_jump_power;
					velocity.x = OVER_SQRT2 * -m_jump_power;
					m_dustEmitter.on = false;
				}
				else if (m_remaining_jumps > 0)
				{
					if (playSounds)
					{
						FlxG.play(JumpSnd);
					}
					m_remaining_jumps--;
					m_dashing = false;
					velocity.y = -m_jump_power;
					m_dustEmitter.on = false;
				}
			}
			
			// FRICTION
			if (velocity.y > 0 && (isTouchingLeft || isTouchingRight))
			{
				acceleration.y = PlayState.GRAVITY - velocity.y * m_wall_friction;
				m_dustEmitter.on = true;
				
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
			
			// ACCELEARTION
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
					play("idle");
				}
				else if (maxVelocity.x == m_dash_speed)
				{
					play("dash");
				}
				else
				{
					play("run");
				}
			}
			
			// POWERUPS
			if (usePowerup && m_currentPowerup != null)
			{
				trace("Activating");
				activateCurrentPowerup();
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
			m_dustEmitter.setXSpeed(velocity.x - 50, -velocity.x + 50);
			m_dustEmitter.setYSpeed(velocity.y - 50, -velocity.y + 50);
			
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
				m_currentPowerup.activate(target);
			}
			else if (m_currentPowerup != null && m_currentPowerup.shouldBeDiscarded)
			{
				m_powerupList.splice(m_powerupList.indexOf(m_currentPowerup),1);
				m_currentPowerup = null;
			}
		}
		
		public function hit(damage:int=10):void
		{
			health -= damage;
			if (health <= 0)
			{
				die();
			}
			else
			{
				flicker(0.5);
			}
		}
		
		public function squash():void
		{
			if (playSounds)
			{
				FlxG.play(DeathSnd);
			}
			play("squash");
			playingDeathAnimation = true;
			
			this.solid = false;
			this.acceleration.x = 0;
			this.acceleration.y = 0;
		}
		
		public function die():void
		{
			if (playSounds)
			{
				FlxG.play(DeathSnd);
			}
			play("pop");
			playingDeathAnimation = true;
			pop = new FlxSprite(x, y, ImgPop);
			pop.facing = facing;
			pop.offset.x = 24;
			pop.loadGraphic(ImgPop, true, true);
			pop.addAnimation("pop", [0, 1, 2, 3, 4, 5, 6, 7], 10, false);
			pop.play("pop");
			(FlxG.state as PlayState).level.misc.add(pop);
			visible = false;
			
			// particles
			var bloodEmitter:FlxEmitter = new FlxEmitter(x+width/2,y+height/2);
			bloodEmitter.makeParticles(bloodDrop, 80);
			bloodEmitter.gravity = 400;
			bloodEmitter.particleDrag.x = 0;
			bloodEmitter.particleDrag.y = 0;
			bloodEmitter.minParticleSpeed.x = -100;
			bloodEmitter.maxParticleSpeed.x = 100;
			bloodEmitter.minParticleSpeed.y = -200;
			bloodEmitter.maxParticleSpeed.y = 10;
			bloodEmitter.start(true, 0.5, 0.1, 80);
			FlxG.state.add(bloodEmitter);
			
			
			this.solid = false;
			this.acceleration.x = 0;
			this.acceleration.y = 0;
		
		}
	}
}