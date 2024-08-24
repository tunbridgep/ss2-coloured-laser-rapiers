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
	
	function UpdateAttachedRapiers(linktype)
	{
		local colour = GetData("Colour");
		
		foreach (link in Link.GetAll(linkkind(linktype), self, 0))
		{
			local sl = sLink(link);			
			SendMessage(sl.dest, "SetColour", colour, true);			
		}
	}
	
	function OnStartAttackMelee()
	{
		//print ("StartAttack");
		UpdateAttachedRapiers("CreatureAttachment");
	}
	
	function OnContainer()
	{
		//print ("OnContainer");
		UpdateAttachedRapiers("Contains");
	}
}
