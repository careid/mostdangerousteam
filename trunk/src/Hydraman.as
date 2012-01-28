package
{
	import org.flixel.*;
	
	public class Hydraman extends Character
	{
		[Embed(source = "graphics/main.png")] protected var ImgHydraman:Class;
		
		public var m_run_level:int = 0;
		public var m_stamina_level:int = 0;
		public var m_health_level:int = 0;
		
		public function Hydraman(X:int,Y:int,soundOn:Boolean = false)
		{
			super(X, Y,soundOn);
			loadGraphic(ImgHydraman, true, true,26,26);
			super.setup(m_run_level*10+60,120+m_run_level*10,0.1+m_stamina_level*0.1,100+m_stamina_level*10,10+m_health_level*10);
			offset.y -= 1;
			offset.x = 6;
			width = 15;
		}		
	}
}