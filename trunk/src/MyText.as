package  
{
	import org.flixel.*;
	public class MyText extends FlxText
	{
		[Embed(source="/other/font.ttf", fontFamily="FONT", embedAsCFF="false")] public	var	Font:String;
		public function MyText(X:Number, Y:Number, Width:uint, Text:String=null, EmbeddedFont:Boolean=true) 
		{
			super(X, Y, Width, Text, EmbeddedFont);
			setFormat("FONT");
		}
		
	}

}