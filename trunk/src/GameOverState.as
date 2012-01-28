package
{
	import org.flixel.*;

	public class GameOverState extends FlxState
	{
		protected var displayText:FlxText;
		
		override public function create():void
		{
			displayText = new FlxText(0, 0, FlxG.width, "GAME OVER NOOB");
			add(displayText);
		}
	}
}
