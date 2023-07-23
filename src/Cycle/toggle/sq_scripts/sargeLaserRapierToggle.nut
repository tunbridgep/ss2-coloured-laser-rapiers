// Script for cycle rapiers
class sargeLaserRapier extends sargeLaserRapierBase
{
    function OnFrobInvEnd()
    {
    	local oldColor = Property.Get(self,"DoorCloseSound").tointeger();
        local colour = GetNextColour(oldColor);
        ApplyRapierModifications(colour);
        ShockGame.AddText("Reinitialising Visual Diffraction Matrix","Player");
        ReEquip();
    }
}
