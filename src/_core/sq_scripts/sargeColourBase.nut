//===============================================
//Class to allow setting a colour
class sargeColourBase extends SqRootScript
{
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
		
		//colour,   chance,   assassin chance, [distance, hue, saturation],    [world model, hand model, assassin model, icon]
		//--------------------------------------------------------------------------------------------------------------------
		["blue",    1.0,      1.0,             [150,0.66,0.80],                ["rapier_w","rapier_h","rr","icn_es"]],
		["red",     1.0,      1.0,             [150,0.98,0.90],                ["rapier_w_rd","rapier_h_rd","rr_rd","icn_es_rd"]],
		["green",   1.0,      1.0,             [150,0.40,0.90],                ["rapier_w_gr","rapier_h_gr","rr_gn","icn_es_gr"]],
		["purple",  1.0,      1.0,             [150,0.80,0.60],                ["rapier_w_pu","rapier_h_pu","rr_pu","icn_es_pu"]],
		["orange",  1.0,      1.0,             [150,0.05,0.60],                ["rapier_w_or","rapier_h_or","rr_or","icn_es_or"]],
		["yellow",  1.0,      1.0,             [150,0.20,0.60],                ["rapier_w_ye","rapier_h_ye","rr_ye","icn_es_ye"]],
		["white",   0.5,      0.5,             [150,0.00,0.00],                ["rapier_w_wh","rapier_h_wh","rr_wh","icn_es_wh"]],
		["black",   0.5,      1.5,             false,                          ["rapier_w_bl","rapier_h_bl","rr_bl","icn_es_bl"]],
	];


	//	DO NOT EDIT ANYTHING BELOW THIS LINE
	//====================================================================

	static RAPIER_NAME = 0;
	static RAPIER_CHANCE = 1;
	static RAPIER_CHANCE_ASSASSIN = 2;
	static RAPIER_GLOW = 3;
	static RAPIER_MODEL = 4;
	
	static INTENSITY = 0;
	static HUE = 1;
	static SATURATION = 2;
	
	static WORLD = 0;
	static HAND = 1;
	static ASSASSIN = 2;
	static ICON = 3;

	//Gets a new colour
	function RollForColour(useAssassinChance = false)
	{
		local total_chance = GetTotalChance(useAssassinChance);
		local roll = Data.RandFlt0to1() * total_chance;
		
		local index = GetColourIndexBasedOnChanceRoll(roll,useAssassinChance);
		
		local name = colours[index][RAPIER_NAME];
		//print ("Selected rapier colour " + index + " (" + name +")");
		
		return index;
	}
	
	//Calculates a total chance value based on the combined chance mods of every rapier
	//Rolls should be done against this
	//So if the total chance values of all rapiers are 6.0, we would roll between 0.0 and 6.0
	function GetTotalChance(useAssassinChance)
	{	
		local total_chance = 0;
		//print ("Calculating total chance....");
		
		foreach(val in colours)
		{
			local value = val[useAssassinChance ? RAPIER_CHANCE_ASSASSIN : RAPIER_CHANCE];
			total_chance += value;
		}
			
		//print ("Total chance is " + total_chance);
		
		return total_chance;
	}
	
	//Returns an array index based on what we rolled for our chance value
	//This is done by walking the array, subtracting each rapiers chance value
	//from our roll value until we reach 0
	function GetColourIndexBasedOnChanceRoll(roll,useAssassinChance)
	{
		local remaining_roll_value = roll;
		
		//print ("initial roll value is " + roll);
		
		foreach(index, val in colours)
		{
			local value = val[useAssassinChance ? RAPIER_CHANCE_ASSASSIN : RAPIER_CHANCE];
		
			remaining_roll_value -= value;
						
			if (remaining_roll_value <= 0)
				return index;
			else
			{
				//print ("remaining roll value is " + remaining_roll_value + " (subtracted " + value + ") which is greater than 0, skipping " + val[RAPIER_NAME] + " rapier");
			}
		}
		
		//something screwed up - just return the default colour
		return 0;
	}
}