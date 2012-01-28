package
{
	import org.flixel.*;

	public class Character extends FlxSprite
	{
		public const OVER_SQRT2:Number = 0.707107;
		
		protected var _runAcceleration:int;
		
		protected var _jumpPower:int;
		protected var _gravity:Number;
		protected var _wallfriction:Number;
		
		protected var _stamina:int;
		protected var _maxstamina:int;
		protected var _staminaregen:int;
		
		protected var m_powerupList : Array;
		protected var m_currentPowerup : Powerup;
		
		public var goLeft:Boolean;
		public var goRight:Boolean;
		public var jump:Boolean;
		public var dashing:Boolean;
		
		public function Character(X:int,Y:int)
		{
			m_powerupList = new Array();
			m_currentPowerup = null;
			super(X,Y);
		}
		
		public function setup():void
		{
			var runSpeed:uint = 80;
			drag.x = runSpeed * 8;
			_runAcceleration = runSpeed * 4;
			maxVelocity.x = runSpeed;
			
			_gravity = 400;
			acceleration.y = _gravity;
			_wallfriction = 3;
			
			_jumpPower = 200;
			maxVelocity.y = _jumpPower;
			
			_staminaregen = 1;
			_maxstamina = 100;
			_stamina = _maxstamina;
			
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
			
			//MOVEMENT
			if(goLeft)
			{
				facing = LEFT;
				acceleration.x = -_runAcceleration;
			}
			else if(goRight)
			{
				facing = RIGHT;				
				acceleration.x = _runAcceleration;
			}
			else
			{
				acceleration.x = 0;
			}
			
			if (touchLeft || touchRight)
			{
				acceleration.y = _gravity - velocity.y * _wallfriction;
			}
			else
			{
				acceleration.y = _gravity;
			}
			
			// Must be touching a wall or floor to jump
			if(jump)
			{
				if (isTouching(FLOOR))
				{
					velocity.y = -_jumpPower;
				}
				else if (touchLeft)
				{
					velocity.y = OVER_SQRT2 * -_jumpPower;
					velocity.x = OVER_SQRT2 * _jumpPower;
				}
				else if (touchRight)
				{
					velocity.y = OVER_SQRT2 * -_jumpPower;
					velocity.x = OVER_SQRT2 * -_jumpPower;
				}
			}
			
			//ANIMATION
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