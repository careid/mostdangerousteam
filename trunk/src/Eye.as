package  
{
	import org.flixel.FlxSprite;

	public class Eye extends FlxSprite
	{
		[Embed(source = "./graphics/main-icon.png")] public var ImageClass:Class;
		
		public function Eye(X : Number, Y : Number) 
		{
			super(X, Y, ImageClass);
		}
		
		public static function overlapPlayer(eye : Eye, player : Player) : void
		{
			eye.kill();
			player.numEyes++;
		}
		
	}

}