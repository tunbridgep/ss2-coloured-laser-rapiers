// ================================================================================
// Script for forcing re-adding the SelfLit, SelfLit and AnimLight properties
class sargeLaserRapier extends SqRootScript
{

	//Adding and Removing rapier colours is described in detail in docs/choosing_specific_rapiers.txt and docs/making_new_rapiers.txt
	//READ THOSE FIRST unless you absolutely know what you're doing!!!
	
	//The chance system basically works relative to every other rapier. Chance values are effectively as if X of each rapier was placed into a bucket
	//and then drawn from it. So if a rapier has a chance value of 2.0, and there are 8 total rapier variants, and all the others have a chance value of 1.0,
	//then that particular rapier has a 2 in 9 chance of being selected, all the others have a 1 in 9 chance.
	
	static colours = [
		
		//colour,	chance,			[distance, hue, saturation],	[world model, hand model, icon]
		//-----------------------------------------------------------------------------------------------------
		["blue",    1.0,            [150,0.66,0.80],                false                                    ],
		["red",     1.0,            [150,0.98,0.90],                ["rapier_w_rd","rapier_h_rd","icn_es_rd"]],
		["green",   1.0,            [150,0.40,0.90],                ["rapier_w_gr","rapier_h_gr","icn_es_gr"]],
		["purple",  1.0,            [150,0.80,0.60],                ["rapier_w_pu","rapier_h_pu","icn_es_pu"]],
		["orange",  1.0,            [150,0.05,0.60],                ["rapier_w_or","rapier_h_or","icn_es_or"]],
		["yellow",  1.0,            [150,0.20,0.60],                ["rapier_w_ye","rapier_h_ye","icn_es_ye"]],
		["white",   0.5,            [150,0.00,0.00],                ["rapier_w_wh","rapier_h_wh","icn_es_wh"]],
		["black",   0.5,            false,                          ["rapier_w_bl","rapier_h_bl","icn_es_bl"]],
	];

	function OnBeginScript()
	{
		if (!GetData("Setup"))
		{
			print ("replacing sword properties");
			SetData("Setup",TRUE);
			RollNewRapierColour();
		}
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
	
	function SetupSwordModel(world,hand,icon)
	{
		SetProperty("ModelName",world);
		SetProperty("InvLimbModel",hand);
		SetProperty("ObjIcon",icon);
	}
	
	function SetupSwordLights(distance,hue,saturation)
	{
		SetProperty("SelfLit",distance);
		SetProperty("SelfLitRad",12);
		SetProperty("LightColor","hue",hue);
		SetProperty("LightColor","saturation",saturation);
		SetProperty("AnimLight","Mode",1); //pulse slowly between min and max
		SetProperty("AnimLight","min brightness",320);
		SetProperty("AnimLight","max brightness",400);
		SetProperty("AnimLight","millisecs to brighten",1400);
		SetProperty("AnimLight","millisecs to dim",1000);
		SetProperty("AnimLight","Dynamic Light",true);
	}

	function RollNewRapierColour()
	{
		local total_chance = GetTotalChance();
		local roll = Data.RandFlt0to1() * total_chance;
		
		local selected = GetRapierIndexBasedOnChanceRoll(roll);
		local name = colours[selected][0];
		
		print ("Rolled colour " + selected + " (" + name +")");
			
		if (colours[selected][2] != false && colours[selected][2].len() == 3)
		{
			local intensity = colours[selected][2][0];
			local hue = colours[selected][2][1];
			local saturation = colours[selected][2][2];
			SetupSwordLights(intensity,hue,saturation);
		}
		
		if (colours[selected][3] != false && colours[selected][3].len() == 3)
		{
			local world = colours[selected][3][0];
			local hand = colours[selected][3][1];
			local icon = colours[selected][3][2];
			SetupSwordModel(world,hand,icon);
		}
	}
}