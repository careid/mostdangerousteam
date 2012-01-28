package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
	    [Embed(source = "../maps/map.csv", mimeType = "application/octet-stream")] public var Level1:Class;
		public var level:Level;
		public var player:FlxSprite;
		
		override public function create():void
		{
			//Set the background color to light gray (0xAARRGGBB)
			FlxG.bgColor = 0xffaaaaaa;
			
			//Create a new tilemap using our level data
			level = new Level();
			level.loadFromCSV(new Level1(), this);
			
			//Create player (a red box)
			player = new FlxSprite(FlxG.width/2 - 5);
			player.makeGraphic(10, 12, 0xffaa1111);
			player.maxVelocity.x = 80;
			player.maxVelocity.y = 200;
			player.acceleration.y = 200;
			player.drag.x = player.maxVelocity.x * 4;
			player.blend = "normal";
			player.antialiasing = true;
			add(player);
			
		}
		
		override public function update():void
		{
			//Player movement and controls
			player.acceleration.x = 0;
			if(FlxG.keys.LEFT)
				player.acceleration.x = -player.maxVelocity.x*4;
			if(FlxG.keys.RIGHT)
				player.acceleration.x = player.maxVelocity.x*4;
			if(FlxG.keys.justPressed("SPACE") && player.isTouching(FlxObject.FLOOR))
				player.velocity.y = -player.maxVelocity.y/2;
			
			//Updates all the objects appropriately
			super.update();
			
			//Finally, bump the player up against the level
			FlxG.collide(level.tileMap,player);
		}
		
	}
}
