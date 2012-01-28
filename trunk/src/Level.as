package  
{
	import org.flixel.*;
		
	/////
	/// Class wrapping FlxTileMap, with other stuff in it of importance.
	/////
	public class Level
	{	
		public var tileMap:FlxTilemap = null;

		public function Level() 
		{
			
		}
		
		//////
		/// Loads a tile map from a CSV file. Removes the map if it exists.
		/// adds the new map afterward.
		/// \param mapString, the raw data of the map.
		/// \param state, the FlxState to add the map to.
		/////
		public function loadFromCSV(mapString:String, state:FlxState) : void
		{
			if (tileMap != null)
			{
				state.remove(tileMap);
			}
			
			tileMap = new FlxTilemap();
			tileMap.loadMap(mapString, FlxTilemap.ImgAuto, 0, 0, FlxTilemap.AUTO);
			state.add(tileMap);
		}
		
	}

}