//Controls the colour of laser rapiers through messages
class sargeLaserRapierAssassin extends sargeColourBase
{
	function OnBeginScript()
	{
		if (!GetData("Colour"))
		{
			local colour = RollForColour(true);
			SetData("Colour",colour);
		}
	}
	
	function OnStartAttackMelee()
	{
		local colour = GetData("Colour");
		
		//print ("StartAttack");
		foreach (link in Link.GetAll(linkkind("CreatureAttachment"), self, 0))
		{
			local sl = sLink(link);			
			SendMessage(sl.dest, "SetColour", colour, true);			
		}
		foreach (link in Link.GetAll(linkkind("~CreatureAttachment"), self, 0))
		{			
			SendMessage(sl.dest, "SetColour", colour, true);
		}
	}
	
	function OnContainer()
	{
		local colour = GetData("Colour");
	
		//print ("OnContainer");
		foreach (link in Link.GetAll(linkkind("Contains"), self, 0))
		{
			local sl = sLink(link);
			SendMessage(sl.dest, "SetColour", colour, true);
		}
	}
}