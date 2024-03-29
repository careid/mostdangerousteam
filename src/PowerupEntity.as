package
{
	import org.flixel.*;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxParticle;
	import org.flixel.FlxG;
	
	//////
	/// Class PowerupEntity is an entity in the world that, when touched, is collected by the player.
	/// The player then has a copy of this powerup.
	/////
	public class PowerupEntity extends FlxSprite
	{
		[Embed(source = "./graphics/powerups.png")] public var Image:Class;
		[Embed(source = "./graphics/littlelight.png")] public var Particle1:Class;
		[Embed(source = "./graphics/tinyblue.png")] public var Particle2:Class;
		[Embed(source = "./sounds/powerup.mp3")] public var PowerSnd:Class;
		
		public var powerup : Powerup;
		
		public function PowerupEntity(X : Number=0, Y : Number=0,  powerup : Powerup=null)
		{
			super(X, Y);
			this.powerup  = powerup;
			loadGraphic(Image, true, false, 16,16, false);
			addAnimation("boomerang",  [0]);
			addAnimation("doublejump", [1]);
			addAnimation("stamina",    [2]);
			addAnimation("spikes",     [3]);
			addAnimation("health",     [4]);
			addAnimation("shield",     [5]);
			addAnimation("taser",      [6]);
			if (powerup == null)
				visible = false;
			else
				play(powerup.animationName);
			visible = (powerup != null);
		}
	
		/////
		/// Set's the powerup's character field to the provided character. Returns the powerup.
		/// \param character, the character collecting the powerup.
		/////
		public function collect(character : Character) : Powerup
		{
			FlxG.play(PowerSnd);
			//FlxG.flash(0xffffffff, 0.3);
			powerup.character = character;
			if (powerup is AutoUsePowerup)
			{
				powerup.activate();
			}
			else
			{
				character.addPowerup(powerup);
			}
			powerup.onAdd();
			var emitter:FlxEmitter = new FlxEmitter(x, y);
			emitter.particleClass = AdditiveFadingParticle;
			emitter.makeParticles(Particle2);
			emitter.particleDrag.x = 300;
			emitter.particleDrag.y = 300;
			emitter.start(true, 1.5);
			emitter.setXSpeed( -100, 100);
			emitter.setYSpeed( -100, 100);
			emitter.x = x;
			emitter.y = y;
			emitter.on = true;
			FlxG.state.add(emitter);
			
			var playState : PlayState = (PlayState)(FlxG.state);
			playState.level.powerups.remove(this);
			this.kill();
			(FlxG.state as PlayState).level.powerups.add(new FakePowerupEntity(x, y, character));
			return powerup;
		}
		
		////
		/// Callback for operlapping with a character.
		/// \param powerupEntity powerup to be collected.
		/// \param theCharacter character to collect the powerup.
		////
		public static function overlapCharacter(powerupEntity : PowerupEntity, theCharacter: Character ) : void
		{
			powerupEntity.collect(theCharacter);
		}
		
	}
}