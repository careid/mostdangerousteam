package
{
	import org.flixel.*;

	public class Character extends FlxSprite
	{
		protected var _jumpPower:int;
		protected var _runAcceleration:int;
		public var goLeft:Boolean;
		public var goRight:Boolean;
		public var jump:Boolean;
		
		public function Character(X:int,Y:int)
		{
			super(X,Y);
		}
		
		public function setup():void
		{
			var runSpeed:uint = 80;
			drag.x = runSpeed * 8;
			_runAcceleration = runSpeed * 8;
			acceleration.y = 420;
			_jumpPower = 200;
			maxVelocity.x = runSpeed;
			maxVelocity.y = _jumpPower;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 0], 12);
			addAnimation("jump", [4]);
			addAnimation("idle_up", [5]);
			addAnimation("run_up", [6, 7, 8, 5], 12);
			addAnimation("jump_up", [9]);
			addAnimation("jump_down", [10]);
		}
		
		override public function update():void
		{
			if(justTouched(FLOOR) && (velocity.y > 50))
				//play landing sound
			
			//MOVEMENT
			acceleration.x = 0;
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
			if(jump && !velocity.y)
			{
				velocity.y = -_jumpPower;
				//play jump sound
			}
			
			//ANIMATION
			if(velocity.y != 0)
			{
				play("jump");
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
		
	}
}