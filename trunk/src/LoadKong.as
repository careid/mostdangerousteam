package  
{
	import org.flixel.plugin.photonstorm.API.FlxKongregate;
	import org.flixel.*;
	
	public class LoadKong extends FlxState
	{
		
		public function LoadKong() 
		{
			FlxKongregate.init(apiHasLoaded);
			super();
		}
		
		private function apiHasLoaded():void
		{
			FlxKongregate.connect();
			FlxG.switchState(new SplashState());
		}
	}

}