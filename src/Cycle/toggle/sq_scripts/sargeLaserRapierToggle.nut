// Script for cycle rapiers
class sargeLaserRapier extends sargeLaserRapierBase
{
    function OnFrobInvEnd()
    {
        UpdateTableValues();
    	local oldColor = Property.Get(self,"DoorCloseSound").tointeger();
        local colour = GetNextColour(oldColor);
        ApplyRapierModifications(colour);
        ShockGame.AddText("Reinitialising Optical Diffraction Matrix","Player");
        ReEquip();
    }
}
