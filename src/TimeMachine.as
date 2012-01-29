package  
{
	
	import org.flixel.*;
	
	public class TimeMachine extends FlxSprite
	{
		[Embed(source = "./graphics/timeMachine.png")] public var Image:Class;
		
		public function TimeMachine(X:Number=0,Y:Number=0) 
		{
			super(X,Y);
			loadGraphic(Image);
		}
		
	}

}