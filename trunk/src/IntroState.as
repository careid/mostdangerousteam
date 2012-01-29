package
{
	import org.flixel.*;

	public class IntroState extends FlxState
	{
		protected var foreground:FlxSprite;
		protected var background:FlxSprite;
		
		[Embed(source = "graphics/introforeground.png")] protected var ImgFore:Class;
		[Embed(source = "graphics/introbackground2.png")] protected var ImgBack:Class;
		
		override public function create():void
		{
			background = new FlxSprite(385*2+40,51*2);
			background.loadGraphic(ImgBack, true, false, 385, 51);
			background.addAnimation("go", [0, 1], 1);
			background.play("go");
			background.scale.x = background.scale.y = 5;
			add(background);
			background.velocity.x = -30;
			
			foreground = new FlxSprite(552*2,51*2);
			foreground.loadGraphic(ImgFore, true, false, 552, 51);
			foreground.scale.x = foreground.scale.y = 5;
			foreground.addAnimation("go", [0, 1], 1);
			foreground.play("go");
			add(foreground);
			foreground.velocity.x = -40;
			
			var text:FlxText = new FlxText(100, 200, 8000,
			"Robert works in space. He fixes important machinery.                     It is difficult work, but Robert loves a challenge.            He was working on a particularly tricky machine when something went wrong.....         To save the station, he must reach the locked control room.     'It's dangerous, but it's the only way' he says, 'after all...");
			text.size = 20;
			text.shadow = 0xff000000;
			text.velocity.x = -90;
			add(text);
			
			text = new FlxText(0, 0, FlxG.width, "press [space] to skip");
			text.scrollFactor.x = text.scrollFactor.y = 0;
			text.color = 0xff000000;
			add(text);
		}
		
		override public function update():void 
		{
			if (foreground.x < -foreground.width +FlxG.width)
			{
				foreground.velocity.x = 0;
			}
			if (FlxG.keys.justPressed("SPACE"))
			{
				FlxG.switchState(new DummyLauncher());
			}
			super.update();
		}
	}
}
