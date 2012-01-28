package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
	    [Embed(source = "../maps/map.csv", mimeType = "application/octet-stream")] public var Level1:Class;
		public var level:Level;
		public var player:Player;
		
		override public function create():void
		{
			//Set the background color to light gray (0xAARRGGBB)
			FlxG.bgColor = 0xffaaaaaa;
			
			//Create a new tilemap using our level data
			level = new Level();
			level.loadFromCSV(new Level1(), this);
			
			//Create player (a red box)
			player = new Player(FlxG.width/2 - 5,0);
			add(player);
			
		}
		
		override public function update():void
		{	
			//Updates all the objects appropriately
			super.update();
			
			//Finally, bump the player up against the level
			FlxG.collide(level.tileMap,player);
		}
		
	}
}
