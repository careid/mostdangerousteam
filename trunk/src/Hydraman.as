package
{
	import org.flixel.*;
	
	public class Hydraman extends Character
	{
		[Embed(source = "graphics/main.png")] protected var ImgHydraman:Class;
		
		public var m_level:int = 3;
		
		public function Hydraman(X:int,Y:int)
		{
			super(X, Y);
			loadGraphic(ImgHydraman, true, true,26,26);
			super.setup(m_level*10+60,120+m_level*10,0.1+m_level*0.1,100+m_level*10);
			offset.y -= 1;
			offset.x = 6;
			width = 15;
		}		
	}
}