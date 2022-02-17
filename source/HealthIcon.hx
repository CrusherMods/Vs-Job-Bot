package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;

using StringTools;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	var charList:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));

	public var charColorArray:Array<FlxColor> = [];
	private var char:String;
	private var iconOffset:Array<Float> = [0, 0];
	private var isPlayer:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		this.char = char;
		this.isPlayer = isPlayer;
		super();

		changeDaIcon(char);
		scrollFactor.set();
	}

	public function changeDaIcon(char:String) {
		var name:String = 'icons/' + char + '-icon';

		if (!CDevConfig.utils.fileIsExist('images/' + name + '.png', IMAGE))
			name = 'icons/face-icon'; //to prevent crashing while loading an not existed character icon
				
		var file:Dynamic = Paths.image(name, 'preload');
		loadGraphic(file, true, 150, 150);
		animation.add(char, [0, 1, 2], 0, false, isPlayer);
		animation.play(char);
		this.char = char;

		iconOffset[0] = (width - 150) / 2;
		iconOffset[1] = (width - 150) / 2;	

		antialiasing = FlxG.save.data.antialiasing;
		if (char.endsWith('-pixel'))
		{
			antialiasing = false;
		}

		getColorArray();			
	}
	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffset[0];
		offset.y = iconOffset[1];
	}

	function getColorArray()
	{
		// this is messed up bruh
		var REDC:Int = 0;
		var GREENC:Int = 0;
		var BLUEC:Int = 0;
		switch (char)
		{
			case 'bf':
				REDC = 49;
				GREENC = 176;
				BLUEC = 209;
			case 'spooky':
				REDC = 213;
				GREENC = 126;
				BLUEC = 0;
			case 'pico':
				REDC = 183;
				GREENC = 216;
				BLUEC = 85;
			case 'mom':
				REDC = 216;
				GREENC = 85;
				BLUEC = 142;
			case 'dad':
				REDC = 175;
				GREENC = 102;
				BLUEC = 206;
			case 'senpai':
				REDC = 255;
				GREENC = 170;
				BLUEC = 111;
			case 'spirit':
				REDC = 255;
				GREENC = 60;
				BLUEC = 110;
			case 'bf-pixel':
				REDC = 123;
				GREENC = 214;
				BLUEC = 246;
			case 'gf':
				REDC = 165;
				GREENC = 0;
				BLUEC = 77;
			case 'parents':
				REDC = 216;
				GREENC = 85;
				BLUEC = 142;
			case 'monster':
				REDC = 243;
				GREENC = 255;
				BLUEC = 110;
			default:
				REDC = 161;
				GREENC = 161;
				BLUEC = 161;
		}

		charColorArray = [REDC, GREENC, BLUEC];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
