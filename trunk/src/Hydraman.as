package
{
	import org.flixel.*;
	
	public class Hydraman extends Character
	{
		[Embed(source = "graphics/main.png")] protected var ImgHydraman:Class;
		
		public function Hydraman(X:int,Y:int)
		{
			super(X, Y);
			loadGraphic(ImgHydraman, true, true,26,26);
			super.setup();
			offset.y -= 1;
			offset.x = 6;
			width = 15;
		}		
	}
}