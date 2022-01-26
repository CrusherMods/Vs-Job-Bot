package;

import flixel.util.FlxTimer;
import openfl.Lib;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
#if desktop
import Discord.DiscordClient;
#end

class OptionsSubState extends MusicBeatSubstate
{
	var curSelected:Int = 0;
	var options:Array<String> = ['Gameplay', 'Appearance'];
	private var grpOption:FlxTypedGroup<Alphabet>;
	var menuBG:FlxSprite;
	private var allowToPress:Bool = false;

	public function new()
	{
		super();
		#if desktop
		if (Main.discordRPC)
			DiscordClient.changePresence("Setting the game options", null);
		#end

		grpOption = new FlxTypedGroup<Alphabet>();
		add(grpOption);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, (70 * i) + 30, options[i], true, false);
			optionText.screenCenter();
			optionText.isMenuItem = true;
			optionText.isOptionItem = true;
			optionText.targetY = i;
			// optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOption.add(optionText);
		}
		changeSelection();

		new FlxTimer().start(0.2, function(bruh:FlxTimer)
			{
				allowToPress = true;
			});

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function closeSubState()
	{
		super.closeSubState();
		changeSelection();
	}

	override function update(elapsed:Float)
	{
		if (controls.UP_P)
		{
			changeSelection(-1);
		}
		if (controls.DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			FlxG.save.flush();
			CDevConfig.reInitLerp();
			Conductor.updateSettings();
			FlxG.sound.play(Paths.sound('cancelMenu'));
			close();
		}

		if (controls.ACCEPT && allowToPress)
		{
			for (item in grpOption.members)
			{
				item.alpha = 0;
			}

			switch (options[curSelected])
			{
				case 'Gameplay':
					openSubState(new GameplaySettings(true));
				//case 'Inputs':
				//	openSubState(new InputsSettings());
				// case 'Credits':
				//    openSubState(new CreditState());
				case 'Appearance':
					openSubState(new AppearanceSettings(true));
			}
		}

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		var bullShit:Int = 0;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		for (item in grpOption.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;
			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
