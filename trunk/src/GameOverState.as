package
{
	import org.flixel.*;

	public class DummyLauncher extends FlxState
	{
		var DisplayText:FlxText;
		override public function create():void
		{
			FlxG.switchState(new PlayState(10));
		}
		
	}
}
