// ================================================================================
// Script for randomly rolling and applying rapier colours (via model changes).
class sargeLaserRapier extends sargeColourBase
{
	//This sets the radius of the glow for rapiers.
	static glowRadius = 12;
	
	colour = null;
		
	isAssassin = null;
		
	function OnCreate()
	{
		print ("replacing sword properties");
		
		isAssassin = IsAssassinRapier();
		
		colour = RollForColour();
		
		ApplyRapierModifications();
	}

	//If we are the special "assassin rapier" archetype, we are an assassin rapier
	function IsAssassinRapier()
	{
		local archetype = ShockGame.GetArchetypeName(self);

		return archetype == "Rapier Attach" //Scary Monsters support
			|| archetype == "arapier";  	//Secmod support
	}
	
	//Gets a colour for an assassin
	function RollForAssassin()
	{
		if (assassinForceColor < 0 || assassinForceColor >= colours.len())
			return RollForColour();
		else return assassinForceColor;		
	}

	function SetupAssassinModel()
	{
		if (colours[colour][RAPIER_MODEL] != false)
		{
			local assassinModel = colours[colour][RAPIER_MODEL][ASSASSIN];
			SetProperty("ModelName",assassinModel);
			print ("Setting assassin rapier model to " + assassinModel + " based on colour " + colour);
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

	function ApplyRapierModifications()
	{
		//fallback
		//if (colour == null)
		//	colour = 0;
	
		if (colours[colour][RAPIER_GLOW] != false && colours[colour][RAPIER_GLOW].len() == 3)
		{
			local intensity = colours[colour][RAPIER_GLOW][INTENSITY];
			local hue = colours[colour][RAPIER_GLOW][HUE];
			local saturation = colours[colour][RAPIER_GLOW][SATURATION];
			SetupSwordLights(intensity,hue,saturation);
		}
		else
		{
			RemoveSwordLight();
		}
		
		if (colours[colour][RAPIER_MODEL] != false && colours[colour][RAPIER_MODEL].len() == 4)
		{
			local world = colours[colour][RAPIER_MODEL][WORLD];
			local hand = colours[colour][RAPIER_MODEL][HAND];
			local icon = colours[colour][RAPIER_MODEL][ICON];
			SetupSwordModel(world,hand,icon);
		}
	}
	
	function OnSetColour()
	{
		//print ("Message works!");
		colour = message().data;
		
		print ("received colour: " + message().data);
		
		ApplyRapierModifications();
		
		local isAssassin = message().data2;
		if (isAssassin)
			SetupAssassinModel();
	}
}