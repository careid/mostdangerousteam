package
{
	import org.flixel.*;

	public class GameOverState extends FlxState
	{
		protected var displayText:FlxText;
		
		override public function create():void
		{
			displayText = new FlxText(0, 0, FlxG.width, "GAME OVER NOOB\npress r to restart");
			add(displayText);
		}
		
		override public function update():void 
		{
			if (FlxG.keys.justPressed("R"))
			{
				FlxG.switchState(new DummyLauncher);
			}
			super.update();
		}
	}
}
