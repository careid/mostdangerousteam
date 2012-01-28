package  
{
	import mx.core.FlexSprite;
	import org.flixel.*;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
		
	/////
	/// Class wrapping FlxTileMap, with other stuff in it of importance.
	/////
	public class Level
	{
		[Embed(source = "./graphics/tiles.png")] public var Image:Class;
		public var tileMap:FlxTilemap = null;
		public var startPoints:Array = null;
		public var doors:FlxGroup = null;
		public var powerups:FlxGroup = null;
		public var timeMachine:TimeMachine = null;
		
		public function Level() 
		{
			
		}
		
		//////
		/// Loads a tile map from a CSV file. Removes the map if it exists.
		/// adds the new map afterward.
		/// \param mapString, the raw data of the map.
		/// \param state, the FlxState to add the map to.
		/////
		public function loadFromCSV(mapString:String) : void
		{
			tileMap = new FlxTilemap();
			tileMap.loadMap(mapString, Image, 32,32);
		}
		
		//////
		/// Loads powerups from a XML file.
		/// \param xmlData, the raw data of the xml file.
		/// \param state, the FlxState to add the map to.
		/////
		public function loadFromXML(xmlData:ByteArray) : void
		{
			startPoints = new Array();
			doors = new FlxGroup();
			powerups = new FlxGroup();
			
			var xml_str:String = xmlData.readUTFBytes(xmlData.length);
			var xml:XML = XML(xml_str);
			var children:XMLList = xml.children();
			for (var i:int = 0; i < children.length(); i++)
			{
				var child = children[i];
				var obj:Object;
				if (child.name() == "StartPoint")
				{
					obj = new FlxPoint();
					startPoints.push(obj);
				}
				else if (child.name() == "TimeMachine")
				{
					timeMachine = new TimeMachine();
					obj = timeMachine;
				}
				else if (child.name() == "Door")
				{
					obj = new Door();
					doors.add(obj as Door);
				}
				else if (child.name() == "StaminaRechargePowerup")
				{
					obj = new PowerupEntity();
					obj.powerup = new StaminaRechargePowerup();
					(obj as PowerupEntity).play("stamina");
					powerups.add(obj as PowerupEntity);
				}
				else if (child.name() == "BoomerangPowerup")
				{
					obj = new PowerupEntity();
					obj.powerup = new BoomerangPowerup();
					(obj as PowerupEntity).play("boomerang");
					powerups.add(obj as PowerupEntity);
				}
				else if (child.name() == "SpikePowerup")
				{
					obj = new PowerupEntity();
					obj.powerup = new SpikePowerup();
					(obj as PowerupEntity).play("spikes");
					powerups.add(obj as PowerupEntity);
				}
				else
				{
					trace("Key " + child.name() + " unknown");
				}
				
				var attributes:XMLList = child.attributes();
				for (var j:int = 0; j < attributes.length(); j++)
				{
					var attr = attributes[j];
					if (attr.name() == "x")
					{
						obj.x = int(attr);
					}
					else if (attr.name() == "y")
					{
						obj.y = int(attr);
					}
					else
						trace("Attribute " + child.name() + "." + attr.name() + " unknown.");
				}
			}
		}
	}

}