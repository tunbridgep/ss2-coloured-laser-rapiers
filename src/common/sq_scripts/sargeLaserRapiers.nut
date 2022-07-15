// ================================================================================
// Script for forcing re-adding the SelfLit, SelfLit and AnimLight properties
class sargeLaserRapier extends SqRootScript
{
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
		SetProperty("LightColor","hue",hue);
		SetProperty("LightColor","saturation",saturation);
		SetProperty("AnimLight","Mode",1); //pulse slowly between min and max
		SetProperty("AnimLight","min brightness",320);
		SetProperty("AnimLight","max brightness",400);
		SetProperty("AnimLight","millisecs to brighten",1400);
		SetProperty("AnimLight","millisecs to dim",1000);
		SetProperty("AnimLight","Dynamic Light",true);
	}

	//Rapier colour blocks are defined below
	//DO NOT edit anything above this section
	//Adding and Removing rapier colours is described in detail in docs/choosing_specific_rapiers.txt
	//READ THAT FIRST unless you absolutely know what you're doing.
	function RollNewRapierColour()
	{
		local colour = Data.RandInt(0, 7);
		
		print ("Rolled colour " + colour);
		
		if (colour == 0) //blue - default
		{
			SetupSwordLights(150,0.66,0.8);
		}
		else if (colour == 1) //red
		{
			SetupSwordLights(150,0.98,0.9);
			SetupSwordModel("rapier_w_rd","rapier_h_rd","icn_es_rd");
		}
		else if (colour == 2) //green
		{
			SetupSwordLights(150,0.40,0.9);
			SetupSwordModel("rapier_w_gr","rapier_h_gr","icn_es_gr");
		}
		else if (colour == 3) //purple
		{
			SetupSwordLights(150,0.80,0.6);
			SetupSwordModel("rapier_w_pu","rapier_h_pu","icn_es_pu");
		}
		else if (colour == 4) //orange
		{
			SetupSwordLights(150,0.05,0.6);
			SetupSwordModel("rapier_w_or","rapier_h_or","icn_es_or");
		}
		else if (colour == 5) //yellow
		{
			SetupSwordLights(150,0.20,0.6);
			SetupSwordModel("rapier_w_ye","rapier_h_ye","icn_es_ye");
		}
		else if (colour == 6) //white
		{
			SetupSwordLights(150,0.0,0.0);
			SetupSwordModel("rapier_w_wh","rapier_h_wh","icn_es_wh");
		}
		else //black
		{
			SetupSwordModel("rapier_w_bl","rapier_h_bl","icn_es_bl");
		}
	}
}