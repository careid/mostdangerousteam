package
{
import org.flixel.*;

public class TextBox extends FlxSprite
{
	public var text:String;
	public var drawnText:FlxText;
	public var typeTimer:Number;//timer that manages the speed of typing
	public var typeSpeed:Number;
	public var readTimer:Number;
	public var button:FlxSprite;
	public var space:FlxText;
	protected var spaceable:Boolean;
	public function TextBox(X:Number,Y:Number,spaceable:Boolean=false)
	{
		super(X, Y);
		makeGraphic(FlxG.width, FlxG.height, 0xffffffff);
		scrollFactor.x = scrollFactor.y = 0;
		text = "";
		drawnText = new FlxText(x + 20, y, width - 40, text);
		drawnText.color = 0xffffffff;
		drawnText.shadow = 0xff000000
		drawnText.size = 10;
		drawnText.scrollFactor.x = drawnText.scrollFactor.y = 0;
		typeSpeed = 40;
		typeTimer = 0;
		readTimer = 3.0;//take 3 seconds after everything has been typed to read it.
		alpha = 0.4;
		space = new FlxText(FlxG.width - 100, FlxG.height - 60, 100, "[space]");
		space.size = 20;
		space.exists = false;
		this.spaceable = spaceable;
	}
	
	public function refresh(words:String, buttonOn:Boolean = true):void {
		space.exists = false;
		text = words;
		typeTimer = 0;
		readTimer = 3.0;
		if (buttonOn) {
			//button = new FlxSprite(x + width - 40, y + height - 40, Button);
			//button.scrollFactor.x = button.scrollFactor.y = 0;
		}
		else {
			button = null;
		}
	}
	
	override public function update():void {
		if (text != "") {
			visible = true;
			typeTimer += FlxG.elapsed;
			var end:int = Math.floor(typeTimer * typeSpeed);
			drawnText.text = text.slice(0, Math.min(text.length, end));
			//if the text has been typed out
			if (end >= text.length) {
				readTimer -= FlxG.elapsed;
				if (spaceable)
				{
					space.exists = true;
				}
			}
			//if the text has been displayed in full for more than 2 seconds
			if (readTimer <= 0.0 && button==null) {
				text = "";
			}
		}
		else {
			visible = false;
			drawnText.text = "";
		}
		drawnText.x = x+10;
		drawnText.y = y;
		drawnText.update();
		space.update();
	}
	
	public function interact(mouse:FlxObject):void {
		FlxG.overlap(mouse, button, hover);
	}
	
	public function deactivate(force:Boolean=false):void {
		if (force) {
			text = "";
		}
		else{
			if (readTimer<3.0){
				text = "";
			}
		}
	}
	
	private function hover(a:FlxObject, b:FlxObject):void {
		if (FlxG.mouse.justReleased())
		{
			if (readTimer >= 3.0) {
				typeTimer = 10;
			}
			else{
				deactivate();
			}
		}
	}
	
	public function keyHit(key:String):void {
		if (key == "SPACE" && button!=null && spaceable)
		{
			if (readTimer >= 3.0) {
				typeTimer = 10;
			}
			else {
				deactivate();
			}
		}
	}
	
	override public function draw():void {
		super.draw();
		drawnText.draw();
		if (space.exists)
		{
			space.draw();
		}
		if (button != null) {
			//button.draw(); hiding button
		}
	}
}
}