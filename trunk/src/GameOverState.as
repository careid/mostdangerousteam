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
		
		public function GameOverState(index:int,timeLeft:Number,players:Array,player:Player,exp:int=0)
		{
			this.index = index;
			this.players = players;
			runLevel = player.m_run_level;
			staminaLevel = player.m_stamina_level;
			healthLevel = player.m_health_level;
			super();
		}
		
		override public function create():void
		{
			displayText = new FlxText(0, 0, FlxG.width, "GAME OVER NOOB\npress r to restart");
			add(displayText);
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
			FlxG.switchState(new PlayState(index,players,runLevel,staminaLevel,healthLevel));
		}
	}
}
