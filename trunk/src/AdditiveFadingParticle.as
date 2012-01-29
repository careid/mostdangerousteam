package  
{
	import org.flixel.FlxParticle;
	import org.flixel.FlxG;
	public class AdditiveFadingParticle extends FlxParticle
	{
		
		public function AdditiveFadingParticle() 
		{
			super();
			blend  = "add";
			antialiasing = true;
			var randomScale:Number = FlxG.random();
			scale.x *= randomScale;
			scale.y *= randomScale;
			alpha *= randomScale;
		}
		
		override public function update():void 
		{
			super.update();
			alpha *= 0.96;
			scale.x *= 0.96;
			scale.y *= 0.96;
		}
		
	}

}