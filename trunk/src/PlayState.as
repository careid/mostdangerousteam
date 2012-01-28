package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
	    [Embed(source = "../maps/map.csv", mimeType = "application/octet-stream")] public var Level1:Class;
		public var level:Level;
		public var player:Player;
		public var state:uint;
		
		protected var END:uint = 0;
		protected var START:uint = 1;
		protected var MID:uint = 2;
		
		protected var timeLeft:Number = 0;
		
		public function PlayState(timeLeft:Number,player:Player=null)
		{
			this.player = player;
			this.timeLeft = timeLeft;
			super();
		}
		
		override public function create():void
		{
			//Set the background color to light gray (0xAARRGGBB)
			FlxG.bgColor = 0xffaaaaaa;
			
			//Create a new tilemap using our level data
			level = new Level();
			level.loadFromCSV(new Level1(), this);
			
			if (!player)
			{
				player = new Player(FlxG.width/2 - 5,0);
				add(player);
			}
			
			FlxG.camera.setBounds(-1000,0,2000,240,true);
			FlxG.camera.follow(player,FlxCamera.STYLE_PLATFORMER);
			
			state = START;
		}
		
		override public function update():void
		{	
			//Updates all the objects appropriately
			super.update();
			
			//Finally, bump the player up against the level
			FlxG.collide(level.tileMap, player);
			
			updateStateEvents();
			if (FlxG.keys.justPressed("A"))
			{
				transitionState(END);
			}
		}
		
		public function transitionState(newState:uint):void 
		{
			state = newState;
			switch(state)
			{
				case START:
					break;
				case MID:
					break;
				case END:
					FlxG.fade(0xffffff, 1, restartLevel);
					break;
				default:
					break;
			}
		}
		
		private function updateStateEvents():void 
		{
			//nothing to be done yet
		}
		
		private function restartLevel():void 
		{
			//restart the game
			FlxG.switchState(new PlayState(10));
		}
		
	}
}
