package
{
	import org.flixel.*;

	public class GameOverState extends FlxState
	{
		protected var displayText:FlxText;
		
		protected var runLevel:int = 0;
		protected var staminaLevel:int = 0;
		protected var healthLevel:int = 0;
		
		protected var index:int;
		protected var players:Array;
		
		protected var displayImage:FlxSprite;
		
		[Embed(source = "graphics/gameover.png")] protected var Image:Class;
		[Embed(source = "./sounds/music/taps.mp3")] protected var Music:Class;
		[Embed(source = "sounds/explosion.mp3")] public var ExplosionSnd:Class;
		
		public function GameOverState(index:int,timeLeft:Number,players:Array,exp:int=0)
		{
			this.index = index;
			this.players = players;
			var player:Player = players[players.length-1];
			runLevel = player.m_run_level;
			staminaLevel = player.m_stamina_level;
			healthLevel = player.m_health_level;
			super();
		}
		
		override public function create():void
		{
			displayImage = new FlxSprite(0, -30);
			displayImage.scrollFactor.x = displayImage.scrollFactor.y = 0;
			displayImage.loadGraphic(Image, true, false, 320, 300);
			displayImage.addAnimation("go", [0,0,0,0,1,2,3,4,5,5,5,6,7,8,9,10,10,10,11,12,13,14,15], 12,false);
			displayImage.play("go");
			add(displayImage);
			
			displayText = new FlxText(0, 80, FlxG.width, "GAME OVER\n\n\npress r to restart");
			displayText.color = 0xff000000;
			displayText.alignment = "center";
			add(displayText);
			
			FlxG.play(Music, 1.5, true);
			FlxG.play(ExplosionSnd);
			
			super.create();
		}
		
		override public function update():void 
		{
			if (FlxG.keys.justPressed("R"))
			{
				startLevel();
			}
			super.update();
		}
		
		protected function startLevel():void
		{
			FlxG.switchState(new PlayState(index,players,runLevel,staminaLevel,healthLevel,false));
		}
	}
}
