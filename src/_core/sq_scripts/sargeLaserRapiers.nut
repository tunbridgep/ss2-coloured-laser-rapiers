// ================================================================================
// Script for randomly rolling and applying rapier colours (via model changes).
class sargeLaserRapier extends SqRootScript
{
	//This sets the radius of the glow for rapiers.
	static glowRadius = 12;

	//Due to how Secmod and the Scary Monsters Assassin Rapier Addons work, cyborg assassins
	//will have a different rapier colour for each attack, since a new rapier is created and
	//destroyed for every melee attack, resulting in constant colour switching between attacks.
	//To prevent this, you can force assassins to always use a certain rapier colour, which will
	//reduce variety but add consistency.
	//Set this to an index of the below table (0-7) to force assassins to use that colour for their rapiers.
	//For instance, to use red rapiers, set the value to 1 (blue is at index 0, followed by red at index 1).
	//Set this to -1 to disable the feature, which will allow assassins to use any colour (the default setting).
	//Setting this to a value outside the valid table range will disable this feature and allow assassins to use any colour (the default behaviour).
	//The black rapiers (7) look particularly good on Assassins.
	static assassinForceColor = -1;

	//Adding and Removing rapier colours is described in detail in docs/choosing_specific_rapiers.txt and docs/making_new_rapiers.txt
	//READ THOSE FIRST unless you absolutely know what you're doing!!!
	
	//The chance system basically works relative to every other rapier. Chance values are effectively as if X of each rapier was placed into a bucket
	//and then drawn from it. So if a rapier has a chance value of 2.0, and there are 8 total rapier variants, and all the others have a chance value of 1.0,
	//then that particular rapier has a 2 in 9 chance of being selected, all the others have a 1 in 9 chance.
	
	//For hue and saturation values, please see
	//https://www.ttlg.com/forums/showthread.php?t=68416&p=798219&viewfull=1#post798219
	//"I had to figure this out to do my RGB FM. I'm going from memory so don't sue me if they're wrong.
	//Hue: Red = 0.98 Blue = 0.65 Green = 0.45 Yellow = 0.25 (I think)
	//Saturation: 0.0 = White 1.0 = Full Color Go in between for darker and lighter shades
	//(Actually, I tend to think of Saturation as a control of the color's richness... low values are washed out and high values are deeper and richer.)"
	
	
	static colours = [
		
		//colour,   chance,         [distance, hue, saturation],    [world model, hand model, assassin model, icon]
		//------------------------------------------------------------------------------------------------------------
		["blue",    1.0,            [150,0.66,0.80],                false                                            ],
		["red",     1.0,            [150,0.98,0.90],                ["rapier_w_rd","rapier_h_rd","rr_rd","icn_es_rd"]],
		["green",   1.0,            [150,0.40,0.90],                ["rapier_w_gr","rapier_h_gr","rr_gn","icn_es_gr"]],
		["purple",  1.0,            [150,0.80,0.60],                ["rapier_w_pu","rapier_h_pu","rr_pu","icn_es_pu"]],
		["orange",  1.0,            [150,0.05,0.60],                ["rapier_w_or","rapier_h_or","rr_or","icn_es_or"]],
		["yellow",  1.0,            [150,0.20,0.60],                ["rapier_w_ye","rapier_h_ye","rr_ye","icn_es_ye"]],
		["white",   0.5,            [150,0.00,0.00],                ["rapier_w_wh","rapier_h_wh","rr_wh","icn_es_wh"]],
		["black",   0.5,            false,                          ["rapier_w_bl","rapier_h_bl","rr_bl","icn_es_bl"]],
	];
	
	function OnCreate()
	{
		print ("OnCreate");
		print ("replacing sword properties");
		RollNewRapierColour();
	}
	
	//Calculates a total chance value based on the combined chance mods of every rapier
	//Rolls should be done against this
	//So if the total chance values of all rapiers are 6.0, we would roll between 0.0 and 6.0
	function GetTotalChance()
	{
		local total_chance = 0;
		print ("Calculating total chance....");
		
		foreach(val in colours)
			total_chance += val[1];
			
		print ("Total chance is " + total_chance);
		
		return total_chance;
	}
	
	//Returns an array index based on what we rolled for our chance value
	//This is done by walking the array, subtracting each rapiers chance value
	//from our roll value until we reach 0
	function GetRapierIndexBasedOnChanceRoll(roll)
	{
		local remaining_roll_value = roll;
		
		print ("initial roll value is " + roll);
		
		foreach(index, val in colours)
		{
			remaining_roll_value -= val[1];
						
			if (remaining_roll_value <= 0)
				return index;
			else
			{
				print ("remaining roll value is " + remaining_roll_value + " (subtracted " + val[1] + ") which is greater than 0, skipping " + val[0] + " rapier");
			}
		}
		
		//something screwed up - just return the default rapier
		return 0;
	}

	function IsAssassinRapier()
	{
		//Shitty hardcoded garbage
		print (ShockGame.GetArchetypeName(self));
		
		return ShockGame.GetArchetypeName(self) == "Rapier Attach" //Scary Monsters support
				|| ShockGame.GetArchetypeName(self) == "arapier";  //Secmod support
	}

	function SetupAssassinModel(assassinModel)
	{
		SetProperty("ModelName",assassinModel);	
		print ("Setting assassin rapier model to " + assassinModel);
	}
	
	function SetupSwordModel(world,hand,icon)
	{
		SetProperty("ModelName",world);
		SetProperty("InvLimbModel",hand);
		SetProperty("ObjIcon",icon);
	}
	
	function SetupSwordLights(distance,hue,saturation)
	{
		SetProperty("SelfLit",distance);
		SetProperty("SelfLitRad",glowRadius);
		SetProperty("LightColor","hue",hue);
		SetProperty("LightColor","saturation",saturation);
		SetProperty("AnimLight","Mode",1); //pulse slowly between min and max
		SetProperty("AnimLight","min brightness",320);
		SetProperty("AnimLight","max brightness",400);
		SetProperty("AnimLight","millisecs to brighten",1400);
		SetProperty("AnimLight","millisecs to dim",1000);
		SetProperty("AnimLight","Dynamic Light",true);
	}
	
	//Assassins automatically add a blue light to swords, which gets overridden normally,
	//but not on black rapiers. So we need to make sure it's removed.
	function RemoveSwordLight()
	{
		SetProperty("SelfLit",0);
		SetProperty("SelfLitRad",0);
	}

	function RollNewRapierColour()
	{
		local index;
		local assassin = IsAssassinRapier();
		if (assassin && assassinForceColor > -1 && assassinForceColor < colours.len())
		{
			index = assassinForceColor;
		}
		else
		{
			local total_chance = GetTotalChance();
			local roll = Data.RandFlt0to1() * total_chance;
			index = GetRapierIndexBasedOnChanceRoll(roll);
		}
		
		local name = colours[index][0];
		print ("Selected rapier colour " + index + " (" + name +")");
		
		if (colours[index][2] != false && colours[index][2].len() == 3)
		{
			local intensity = colours[index][2][0];
			local hue = colours[index][2][1];
			local saturation = colours[index][2][2];
			SetupSwordLights(intensity,hue,saturation);
		}
		else
		{
			RemoveSwordLight();
		}
		
		if (colours[index][3] != false && colours[index][3].len() == 4)
		{
			local world = colours[index][3][0];
			local hand = colours[index][3][1];
			local assassinModel = colours[index][3][2];	
			local icon = colours[index][3][3];
					
			if (assassin)
				SetupAssassinModel(assassinModel);
			else
				SetupSwordModel(world,hand,icon);
		}
	}
}