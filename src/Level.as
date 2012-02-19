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
		public var checkPoints:Array = null;
		public var doors:FlxGroup = null;
		public var conveyors:FlxGroup = null;
		public var spikepits:FlxGroup = null;
		public var powerups:FlxGroup = null;
		public var eyes:FlxGroup = null;
		public var misc:FlxGroup = null;
		public var timeMachine:TimeMachine = null;
		public var doorSwitches:FlxGroup = null;
		public var countDowns:FlxGroup = null;
		public var storyBoxes:FlxGroup = null;
		
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
			countDowns = new FlxGroup();
			mapString = mapString.replace("[\w\r]", "");
			var mapArray:Array = mapString.substr(0,mapString.lastIndexOf("\n")).split("\n");
			
			for (var y:int = 0; y < mapArray.length; y++)
			{
				var str:String = mapArray[y];
				var row:Array = str.substr(0, str.lastIndexOf(",")).split(",");
				
				for (var x:int = 0; x < row.length; x++)
				{
					var countdown:CountDown;
					switch (int(row[x]))
					{
						case 1: // 1 - Background Clock
							countdown = new CountDown();
							countdown.x = x * 32 + 2;
							countdown.y = y * 32;
							countDowns.add(countdown);
							break;
						case 29: // 29 - Top Clock
							countdown = new CountDown();
							countdown.x = x * 32 + 2;
							countdown.y = y * 32 - 11;
							countDowns.add(countdown);
							break;
						case 32: // 32 - Bottom Clock
							countdown = new CountDown();
							countdown.x = x * 32 + 2;
							countdown.y = y * 32 + 12;
							countDowns.add(countdown);
							break;
					}
				}
			}
		
			tileMap = new FlxTilemap();
			tileMap.loadMap(mapString, Image, 32,32,FlxTilemap.OFF,0,1,25);
			
			/*
			var platforms:Array = new Array();
			var lines:Array = mapString.split("\n");
			for (var y:int = 0; y < lines.length; y++)
			{
				var tiles:Array = lines[y].split(",");
				var platform:Boolean = false;
				var left:int, right:int;
				for (var x:int = 0; x < tiles.length; x++)
				{
					var tile:Boolean = (int(tiles[x]) > 0);
					if (tile != platform)
					{
						if (tile)
							left = x;
						else
							platforms.push(new Platform(left, right, y));
					}
					platform = tile;
					right = x;
				}
			}
			*/
		}
		
		//////
		/// Loads powerups from a XML file.
		/// \param xmlData, the raw data of the xml file.
		/// \param state, the FlxState to add the map to.
		/////
		public function loadFromXML(xmlData:ByteArray) : void
		{
			var i:int
			checkPoints = new Array();
			doors = new FlxGroup();
			conveyors = new FlxGroup();
			spikepits = new FlxGroup();
			powerups = new FlxGroup();
			doorSwitches = new FlxGroup();
			storyBoxes = new FlxGroup();
			
			var xml_str:String = xmlData.readUTFBytes(xmlData.length);
			var xml:XML = XML(xml_str);
			var children:XMLList = xml.children();
			for (i = 0; i < children.length(); i++)
			{
				var child = children[i];
				var obj:Object;
				if (child.name() == "CheckPoint")
				{
					obj = new CheckPoint();
					checkPoints.push(obj);
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
				else if (child.name() == "SlowDoor")
				{
					obj = new SlowDoor();
					doors.add(obj as SlowDoor);
				}
				else if (child.name() == "CrazyDoor")
				{
					obj = new CrazyDoor();
					doors.add(obj as CrazyDoor);
				}
				else if (child.name() == "DoorSwitch")
				{
					obj = new DoorSwitch();
					doorSwitches.add(obj as DoorSwitch);
				}
				else if (child.name() == "Conveyor")
				{
					obj = new Conveyor();
					conveyors.add(obj as Conveyor);
				}
				else if (child.name() == "Spikepit")
				{
					obj = new SpikePit();
					spikepits.add(obj as SpikePit);
				}
				else if (child.name() == "StoryBox")
				{
					obj = new StoryBox();
					storyBoxes.add(obj as StoryBox);
				}
				else if (child.name() == "StaminaRechargePowerup")
				{
					obj = new PowerupEntity(0,0,new StaminaRechargePowerup());
					powerups.add(obj as PowerupEntity);
				}
				else if (child.name() == "BoomerangPowerup")
				{
					obj = new PowerupEntity(0,0,new BoomerangPowerup());
					powerups.add(obj as PowerupEntity);
				}
				else if (child.name() == "SpikePowerup")
				{
					obj = new PowerupEntity(0,0,new SpikePowerup());
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
						obj.x = Number(attr);
					}
					else if (attr.name() == "y")
					{
						obj.y = Number(attr);
					}
					else if (attr.name() == "width")
					{
						obj.width = Number(attr);
					}
					else if (attr.name() == "height")
					{
						obj.height = Number(attr);
					}
					else if (attr.name() == "threshold")
					{
						obj.threshold = Number(attr);
					}
					else if (attr.name() == "time")
					{
						obj.time = Number(attr);
					}
					else if (attr.name() == "id")
					{
						obj.id = Number(attr);
					}
					else if (attr.name() == "text")
					{
						obj.text = String(attr);
					}
					else if (attr.name() == "level")
					{
						obj.level = Number(attr);
					}
					else
						trace("Attribute " + child.name() + "." + attr.name() + " unknown.");
				}
			}
			
			//post processing
			for (i = 0; i < doorSwitches.length; i++)
			{
				var ds:DoorSwitch = DoorSwitch(doorSwitches.members[i])
				ds.connectDoor(doors);
			}
			
			eyes = new FlxGroup();
			misc = new FlxGroup();
		}
	}

}