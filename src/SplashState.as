package  
{
	import org.flixel.*;
	
	public class SplashState extends FlxState
	{
		protected var DangerLogo:FlxSprite;
		protected var GGJLogo:FlxSprite;
		protected var phase:int = 0;
		
		[Embed(source = "graphics/ggjlogo.png")] protected var GGJ:Class;
		[Embed(source = "graphics/dangerlogo.png")] protected var Danger:Class;
		
		override public function create():void 
		{
			DangerLogo = new FlxSprite(0, 0,Danger);
			GGJLogo = new FlxSprite(0, 0,GGJ);
			add(GGJLogo);
			add(DangerLogo);
			GGJLogo.exists = true;
			DangerLogo.exists = false;
			FlxG.flash(0xff000000, 2, changePhase);
			super.create();
		}
		
		public override function update():void
		{
			if (FlxG.keys.justPressed("SPACE"))
			{
				FlxG.switchState(new IntroState());
			}
		}
		
		private function changePhase():void
		{
			if (phase == 0)
			{
				phase += 1;
				FlxG.flash(0xff000000, 2, changePhase);
				GGJLogo.exists = false;
				DangerLogo.exists = true
			}
			else if (phase == 1)
			{
				phase += 1;
				FlxG.fade(0xff000000, 1.5, changePhase);
			}
			else
			{
				FlxG.switchState(new IntroState());
			}
		}
		
	}

}