// ================================================================================
// Script for randomly rolling and applying rapier colours (via model changes).
class sargeLaserRapier extends sargeColourBase
{
	//This sets the radius of the glow for rapiers.
	static glowRadius = 12;

	function OnBeginScript()
	{
		//Colour is stored in Door Close Sound, since we can't use GetData/SetData
		local colourProp = Property.Get(self,"DoorCloseSound");
		if (!colourProp)
		{	
            SetNewColour(false);
		}
		else
		{
			//print ("found existing rapier properties: " + colourProp);
		}
	}

    function SetNewColour(keepOld)
    {
        local oldColor = -1;
        if (keepOld)
    		oldColor = Property.Get(self,"DoorCloseSound").tointeger();
        
        local colour = RollForColour(false,oldColor);
		print ("Rapier " + self + " changing colour to " + colours[colour][RAPIER_NAME]);
		Property.SetSimple(self,"DoorCloseSound",colour);
		ApplyRapierModifications(colour);
    }
	
	function SetupAssassinModel(colour)
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
		//print ("Setting Model...");
		SetProperty("ModelName",world);
		SetProperty("InvLimbModel",hand);
		SetProperty("ObjIcon",icon);
	}
	
	function SetupSwordLights(distance,hue,saturation)
	{
		//print ("Setting lights...");
		SetProperty("SelfLit",distance);
		SetProperty("SelfLitRad",glowRadius);
		SetProperty("LightColor","hue",hue);
		SetProperty("LightColor","saturation",saturation);
		SetProperty("AnimLight","Mode",1); //pulse slowly between min and max
		SetProperty("AnimLight","min brightness",MIN_BRIGHTNESS);
		SetProperty("AnimLight","max brightness",MAX_BRIGHTNESS);
		SetProperty("AnimLight","millisecs to brighten",TIME_TO_BRIGHT);
		SetProperty("AnimLight","millisecs to dim",TIME_TO_DIM);
		SetProperty("AnimLight","Dynamic Light",true);
	}
	
	//Sword lights need to be removed when re-rolling
	function RemoveSwordLight()
	{
		//print ("Removing lights...");
		Property.Remove(self, "SelfLit");
		Property.Remove(self, "SelfLitRad");
		Property.Remove(self, "AnimLight");
		Property.Remove(self, "LightColor");
	}

	function ApplyRapierModifications(colour)
	{
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
		local colour = message().data;
		
		//print ("received colour: " + message().data);
		
		ApplyRapierModifications(colour);
		
		local isAssassin = message().data2;
		if (isAssassin)
			SetupAssassinModel(colour);
	}
    
    function OnFrobInvEnd()
    {

        local naniteObj = ShockGame.Equipped(ePlayerEquip.kEquipFakeNanites);
        local naniteCount = Property.Get(naniteObj,"StackCount");
        local weapon = ShockGame.Equipped(ePlayerEquip.kEquipWeapon);
        local cost = 40;

        if (naniteCount >= cost)
        {
            SetNewColour(true);
            Property.SetSimple(naniteObj,"StackCount",naniteCount - cost);
            ShockGame.AddText("Spent " + cost + " Nanites to modify rapier","Player");
        
            //Need to re-equip otherwise the colour doesn't update
            if (weapon == self)
                ShockGame.Equip(ePlayerEquip.kEquipWeapon,self);
        }
        else
        {
            ShockGame.AddText("Insufficient Nanites to modify Rapier","Player");
        }
    }

}
