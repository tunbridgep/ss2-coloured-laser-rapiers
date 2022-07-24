// ================================================================================
// Script for randomly rolling and applying rapier colours (via model changes).
class sargeLaserRapier extends sargeColourBase
{
	//This sets the radius of the glow for rapiers.
	static glowRadius = 12;
	
	colour = null;
	
	function OnBeginScript()
	{
		//Colour is stored in Door Close Sound, since we can't use GetData/SetData
		local colourProp = Property.Get(self,"DoorCloseSound");
		if (!colourProp)
		{	
			print ("replacing sword properties");
			colour = RollForColour();
			Property.SetSimple(self,"DoorCloseSound",colour);
		}
		else
		{
			print ("found existing sword properties: " + colourProp);
			colour = colourProp;
		}
		ApplyRapierModifications();
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
		print ("Setting Model...");
		SetProperty("ModelName",world);
		SetProperty("InvLimbModel",hand);
		SetProperty("ObjIcon",icon);
	}
	
	function SetupSwordLights(distance,hue,saturation)
	{
		print ("Setting lights...");
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
	
	//Sword lights need to be removed when re-rolling
	function RemoveSwordLight()
	{
		print ("Removing lights...");
		Property.Remove(self, "SelfLit");
		Property.Remove(self, "SelfLitRad");
		Property.Remove(self, "AnimLight");
		Property.Remove(self, "LightColor");
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