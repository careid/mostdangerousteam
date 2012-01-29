package  
{
	import org.flixel.*;

	public class Eye extends FlxSprite
	{
		[Embed(source = "./graphics/eye.png")] public var ImageClass:Class;
		
		public function Eye(X : Number, Y : Number) 
		{
			super(X, Y);
			loadGraphic(ImageClass, true);
			addAnimation("Blink", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 12, true);
			play("Blink");
		}
		
		public static function overlapPlayer(eye : Eye, player : Player) : void
		{
			var playState : PlayState = (PlayState)(FlxG.state);
			playState.level.eyes.remove(eye);
			eye.kill();
			player.numEyes++;
		}
		
	}

}