package
{
	import org.flixel.*;

	public class Character extends FlxSprite
	{
		public const OVER_SQRT2:Number = 0.707107;
		
		protected var m_dashing:Boolean;
		protected var m_speed:Number;
		protected var m_run_speed:Number;
		protected var m_dash_speed:Number;
		protected var m_accel_constant:Number;
		
		public var jumps:int;
		protected var m_remaining_jumps:int;
		protected var m_jump_power:Number;
		protected var m_gravity:Number;
		protected var m_wall_friction:Number;
		
		public var stamina:Number;
		public var maxstamina:Number;
		protected var staminaregen:Number;
		
		protected var m_powerupList : Array;
		protected var m_currentPowerup : Powerup;
		
		public var goLeft:Boolean;
		public var goRight:Boolean;
		public var jump:Boolean;
		public var dash:Boolean;
		public var usePowerup:Boolean;
		
		public function Character(X:int=0,Y:int=0)
		{
			m_powerupList = new Array();
			m_currentPowerup = null;
			super(X,Y);
		}
		
		public function copyPowerups(old_character:Character)
		{
			m_powerupList = new Array();
			for each (var powerup:Powerup in old_character.getPowerupList())
				m_powerupList.push(powerup);
			m_currentPowerup = old_character.getCurrentPowerup();
		}
		
		public function setup(run_speed:int=60,dash_speed:int=120,staminaregen:Number=0.1,maxstamina:Number=100):void
		{
			m_dashing = false;
			m_run_speed = run_speed;
			m_dash_speed = dash_speed;
			m_speed = m_run_speed;
			drag.x = 240;
			m_accel_constant = 4.0;
			maxVelocity.x = m_run_speed;
			
			m_gravity = 400;
			acceleration.y = m_gravity;
			m_wall_friction = 10;
			
			jumps = 3;
			m_remaining_jumps = jumps;
			m_jump_power = 200;
			maxVelocity.y = m_jump_power;
			
			this.staminaregen = staminaregen;
			this.maxstamina = maxstamina;
			stamina = maxstamina;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 4], 12);
			addAnimation("jump", [5, 6],12);
			addAnimation("fall", [7, 8], 12);
			addAnimation("dash", [9, 10, 11, 12],18);
			addAnimation("wallslide", [13],12);
		}
		
		override public function update():void
		{			
			var touchLeft:Boolean = isTouching(LEFT);
			var touchRight:Boolean = isTouching(RIGHT);
			
			// DASHING
			if (m_dashing)
			{
				stamina--;
				if (stamina <= 0 || dash == false)
				{
					m_dashing = false;
					m_speed = m_run_speed;
					maxVelocity.x = m_run_speed;
				}
			}
			else if (isTouching(FLOOR))
			{
				stamina = Math.min(maxstamina, stamina + staminaregen);
				if (dash && stamina == maxstamina)
				{
					m_dashing = true;
					m_speed = m_dash_speed;
					maxVelocity.x = m_dash_speed;
				}
				else
				{
					m_dashing = false;
					maxVelocity.x = m_run_speed;
				}
			}
			
			// JUMPING
			if (justTouched(FLOOR))
			{
				m_remaining_jumps = jumps;
			}
			if(jump)
			{
				if (isTouching(FLOOR) && m_remaining_jumps > 0)
				{
					m_remaining_jumps--;
					m_dashing = false;
					velocity.y = -m_jump_power;
				}
				else if (touchLeft)
				{
					m_dashing = false;
					velocity.y = OVER_SQRT2 * -m_jump_power;
					velocity.x = OVER_SQRT2 * m_jump_power;
				}
				else if (touchRight)
				{
					m_dashing = false;
					velocity.y = OVER_SQRT2 * -m_jump_power;
					velocity.x = OVER_SQRT2 * -m_jump_power;
				}
				else if (m_remaining_jumps > 0)
				{
					m_remaining_jumps--;
					m_dashing = false;
					velocity.y = -m_jump_power;
				}
			}
			
			// FRICTION
			if (velocity.y > 0 && (touchLeft || touchRight))
			{
				acceleration.y = m_gravity - velocity.y * m_wall_friction;
			}
			else
			{
				acceleration.y = m_gravity;
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
			
			// ANIMATION
			if(velocity.y < 0)
			{
				play("jump");
			}
			else if (velocity.y > 0)
			{
				if (touchLeft || touchRight)
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
			
			// POWERUPS
			if (usePowerup && m_currentPowerup != null)
			{
				m_currentPowerup.activate();
			}
			
			if (m_currentPowerup != null)
			{
				m_currentPowerup.update();
			}
			
			super.update();
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
			if (!powerup.shouldBeDiscarded)
			{
				m_powerupList.push(powerup);
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
		public function activateCurrentPowerup() : void
		{
			if (m_currentPowerup != null && !m_currentPowerup.shouldBeDiscarded)
			{
				m_currentPowerup.activate();
			}
			else if (m_currentPowerup != null && m_currentPowerup.shouldBeDiscarded)
			{
				m_powerupList.slice(m_powerupList.indexOf(m_currentPowerup));
				m_currentPowerup = null;
			}
		}
	}
}