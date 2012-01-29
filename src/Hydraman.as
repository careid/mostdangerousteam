package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	import org.flixel.plugin.photonstorm.FX.GlitchFX;
	import org.flixel.plugin.photonstorm.FlxColor;
	public class Hydraman extends Character
	{
		[Embed(source = "graphics/main.png")] protected var ImgHydraman:Class;
		
		protected static const LEFT_SHIFT:int    = 0;
		protected static const RIGHT_SHIFT:int   = 1;
		protected static const JUMP_SHIFT:int    = 2;
		protected static const POWERUP_SHIFT:int = 3;
		protected static const DASH_SHIFT:int    = 4;
		
		protected static const LEFT_MASK:int    = 1 << LEFT_SHIFT;
		protected static const RIGHT_MASK:int   = 1 << RIGHT_SHIFT;
		protected static const JUMP_MASK:int    = 1 << JUMP_SHIFT;
		protected static const POWERUP_MASK:int = 1 << POWERUP_SHIFT;
		protected static const DASH_MASK:int    = 1 << DASH_SHIFT;
		
		public var m_run_level:int = 0;
		public var m_stamina_level:int = 0;
		public var m_health_level:int = 0;
		public var m_timeLeft:Number;
		public static var m_initialTimeLeft:Number;
		private var glitch:GlitchFX;
		
		public var m_stateHistory:Array;
		public var m_waypoints:Array;
		public var startX:Number;
		public var startY:Number;
		
		public function Hydraman(X:int,Y:int,soundOn:Boolean = false, isEnemy:Boolean = true)
		{
			super(X, Y, soundOn);
			startX = X;
			startY = Y;
			loadGraphic(ImgHydraman, true, true, 26, 26);
			super.setup(100+m_run_level*5, 200+m_run_level*10, 0.5+m_stamina_level*0.1, 100+m_stamina_level*10, 10+m_health_level*4);
			offset.y -= 1;
			offset.x = 6;
			width = 15;
			m_timeLeft = m_initialTimeLeft;
			m_stateHistory = new Array();
			if (isEnemy)
			{
				glitch = FlxSpecialFX.glitch();
				glitch.createFromFlxSprite(this, 10,1, true);
				glitch.start();
				color = 0x334455;
				FlxG.state.add(glitch.sprite);
			}
		}
		
		protected function setState(state:int):void {
			goLeft = new Boolean(LEFT_MASK & state);
			goRight = new Boolean(RIGHT_MASK & state);
			doJump = new Boolean(JUMP_MASK & state);
			usePowerup = new Boolean(POWERUP_MASK & state);
			doDash = new Boolean(DASH_MASK & state);
		}
		
		protected function getState(isLeft:Boolean, isRight:Boolean, isJump:Boolean, isPowerup:Boolean, isDash:Boolean):int
		{
			var ret:int = 0;
			if (isLeft) ret |= LEFT_MASK;
			if (isRight) ret |= RIGHT_MASK;
			if (isJump) ret |= JUMP_MASK;
			if (isPowerup) ret |= POWERUP_MASK;
			if (isDash) ret |= DASH_MASK;
			return ret;
		}
		
		override public function update():void
		{
			super.update();
			m_timeLeft -= FlxG.elapsed;
			
			if (glitch != null)
			{
				glitch.sprite.color = FlxColor.getRandomColor(255, 50);
				glitch.sprite.x = x - 8;
				glitch.sprite.alpha = Math.max(0.0, Math.min(1.0, FlxG.random() + 0.5));
				glitch.sprite.y = y ;
				glitch.sprite.blend = "add";
			}
		}
		
		override public function destroy() : void
		{
			if (glitch != null)
			{
				glitch.stop();
				glitch.sprite.kill();
				FlxSpecialFX.remove(glitch);
				(FlxG.state as PlayState).remove(glitch.sprite);
				glitch = null;
			}
			
			super.destroy();
		}
		
		protected function spurt():void
		{
			var bloodEmitter:FlxEmitter = new FlxEmitter(x+width/2,y+height/2);
			bloodEmitter.makeParticles(bloodDrop, 100);
			bloodEmitter.gravity = 400;
			bloodEmitter.particleDrag.x = 0;
			bloodEmitter.particleDrag.y = 0;
			bloodEmitter.minParticleSpeed.x = -100;
			bloodEmitter.maxParticleSpeed.x = 100;
			bloodEmitter.minParticleSpeed.y = -200;
			bloodEmitter.maxParticleSpeed.y = 10;
			bloodEmitter.start(true, 0.5, 0.1, 100);
			FlxG.state.add(bloodEmitter);
		}
		
		override public function electrocute() : void
		{
			var eye : Eye = new Eye(x + 5, y + 12);
			if (facing != FlxObject.RIGHT)
			{
				eye.x = x + 2;
			}
			eye.acceleration.y = 400;
			if (facing == FlxObject.RIGHT)
				eye.velocity.x = maxVelocity.x;
			else
				eye.velocity.x = -maxVelocity.x;
			eye.velocity.y = -3*maxVelocity.y;
			(FlxG.state as PlayState).level.eyes.add(eye);
			
			if (glitch != null)
			{
				glitch.stop();
				glitch.sprite.kill();
				FlxSpecialFX.remove(glitch);
				(FlxG.state as PlayState).remove(glitch.sprite);
			}
			super.electrocute();
		}
		
		override public function kill() : void
		{
			spurt();

			if (pop != null)
				pop.kill();
			
			// Spawn an eye.
			var eye : Eye = new Eye(x + 5, y + 12);
			if (facing != FlxObject.RIGHT)
			{
				eye.x = x + 2;
			}
			eye.acceleration.y = 400;
			(FlxG.state as PlayState).level.eyes.add(eye);
			
			if (glitch != null)
			{
				glitch.stop();
				glitch.sprite.kill();
				FlxSpecialFX.remove(glitch);
				(FlxG.state as PlayState).remove(glitch.sprite);
			}
			super.kill();
		}
	}
}