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
		
		public function Character(X:int,Y:int)
		{
			m_powerupList = new Array();
			m_currentPowerup = null;
			super(X,Y);
		}
		
		public function setup():void
		{
			m_dashing = false;
			m_run_speed = 60;
			m_dash_speed = 120;
			m_speed = m_run_speed;
			drag.x = 240;
			m_accel_constant = 4.0;
			maxVelocity.x = m_run_speed;
			
			m_gravity = 400;
			acceleration.y = m_gravity;
			m_wall_friction = 3;
			
			m_jump_power = 200;
			maxVelocity.y = m_jump_power;
			
			staminaregen = 0.1;
			maxstamina = 100;
			stamina = maxstamina;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 4], 12);
			addAnimation("jump", [5, 6],12);
			addAnimation("fall", [7, 8],12);
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
			else
			{
				stamina = Math.min(maxstamina, stamina + staminaregen);
				if (dash && stamina == maxstamina)
				{
					m_dashing = true;
					m_speed = m_dash_speed;
					maxVelocity.x = m_dash_speed;
				}
			}
			
			// JUMPING
			if(jump)
			{
				if (isTouching(FLOOR))
				{
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
				play("fall");
			}
			else if(velocity.x == 0)
			{
				play("idle");
			}
			else
			{
				play("run");
			}
			
			if (m_currentPowerup != null)
			{
				m_currentPowerup.activate();
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
		
		/////
		/// Adds the given powerup to the powerup list.
		/////
		public function addPowerup(powerup : Powerup) : void
		{
			m_powerupList.push(powerup);
		}
		
		/////
		/// Activates the current powerup, if it exists.
		/////
		public function activateCurrentPowerup() : void
		{
			if (m_currentPowerup != null)
			{
				m_currentPowerup.activate();
			}
		}
	}
}