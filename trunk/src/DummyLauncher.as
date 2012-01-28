package
{
	import org.flixel.*;

	public class DummyLauncher extends FlxState
	{
		
		override public function create():void
		{
			FlxG.switchState(new PlayState(100));
		}
		
	}
}
