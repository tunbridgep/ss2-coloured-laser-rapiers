// Script for hackable rapiers
class sargeLaserRapier extends sargeLaserRapierBase
{
    function OnHackSuccess()
    {
        SetNewColour(true);

        //Re-equip because the viewmodel doesn't update if we don't
        ReEquip();
    }

    function OnFrobInvEnd()
    {
        UpdateTableValues();
        ShockGame.OverlayChangeObj(kOverlayHackComp,kOverlayModeOn,self);
        //ShockGame.OverlayChangeObj(kOverlayLook,kOverlayModeOn,self); //Broken
        //ShockGame.OverlayChange(kOverlayLook,kOverlayModeOn);
        ShockGame.OverlayChangeObj(kOverlayHRMPlug,kOverlayModeOn,self);
    }
}
