package
{
	import org.flixel.*;

	public class GameOverState extends FlxState
	{
		var DisplayText:FlxText;
		override public function create():void
		{
			FlxG.switchState(new PlayState(10));
		}
		
	}
}
