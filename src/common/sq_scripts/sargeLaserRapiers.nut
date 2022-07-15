// ================================================================================
// Script for forcing re-adding the SelfLit, SelfLit and AnimLight properties
class sargeLaserRapier extends SqRootScript
{

	//Adding and Removing rapier colours is described in detail in docs/choosing_specific_rapiers.txt and docs/making_new_rapiers.txt
	//READ THOSE FIRST unless you absolutely know what you're doing!!!
	
	static swords = [
		
		//colour,		[distance, hue, saturation],	[world model, hand model, icon]
		//---------------------------------------------------------------------------------------------------------------------------
		["blue",		[150,0.66,0.80],				false										],
		["red",			[150,0.98,0.90],				["rapier_w_rd","rapier_h_rd","icn_es_rd"]	],
		["green",		[150,0.40,0.90],				["rapier_w_gr","rapier_h_gr","icn_es_gr"]	],
		["purple",		[150,0.80,0.60],				["rapier_w_pu","rapier_h_pu","icn_es_pu"]	],
		["orange",		[150,0.05,0.60],				["rapier_w_or","rapier_h_or","icn_es_or"]	],
		["yellow",		[150,0.20,0.60],				["rapier_w_ye","rapier_h_ye","icn_es_ye"]	],
		["white",		[150,0.00,0.00],				["rapier_w_wh","rapier_h_wh","icn_es_wh"]	],
		["black",		false,							["rapier_w_bl","rapier_h_bl","icn_es_bl"]	],
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
		local colour = Data.RandInt(0, swords.len() - 1);
		local name = swords[colour][0];
		
		print ("Rolled colour " + colour + " (" + name +")");
			
		if (swords[colour][1] != false && swords[colour][1].len() == 3)
		{
			local intensity = swords[colour][1][0];
			local hue = swords[colour][1][1];
			local saturation = swords[colour][1][2];
			SetupSwordLights(intensity,hue,saturation);
		}
		
		if (swords[colour][2] != false && swords[colour][2].len() == 3)
		{
			local world = swords[colour][2][0];
			local hand = swords[colour][2][1];
			local icon = swords[colour][2][2];
			SetupSwordModel(world,hand,icon);
		}
	}
}