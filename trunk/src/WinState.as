package  
{
	import org.flixel.*;
	
	public class WinState extends FlxState
	{
		[Embed(source = "graphics/ending.png")] protected var Win:Class;
		
		override public function create():void 
		{
			add(new FlxSprite(0,0,Win));
			super.create();
		}
		
	}

}