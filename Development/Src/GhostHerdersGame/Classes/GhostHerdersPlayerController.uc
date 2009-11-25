class GhostHerdersPlayerController extends UTPlayerController;
	
// The player wants to fire.
exec function StartFire( optional byte FireModeNum )
{
	local GhostCharacter C;
	local GhostHerdersHUD ghHUD;
	local float CamDist;
	local vector TraceStart, TraceEnd, HitLocation, HitNormal;
	local TraceHitInfo HitInfo;

	if ( WorldInfo.Pauser == PlayerReplicationInfo )
	{
		SetPause( false );
		return;
	}

	if ( Pawn != None && !bCinematicMode )
	{
		foreach WorldInfo.DynamicActors(class'GhostCharacter', C)
		{
			ghHUD = GhostHerdersHUD(myHUD);
			// Trace starts at Camera/HUD, mouse cursor
			TraceStart = ghHUD.WorldOrigin;
			// Trace ends at Board
			TraceEnd = ghHUD.WorldOrigin + ghHUD.WorldDirection*50000;
			if (GhostCharacter(Trace(HitLocation, HitNormal, TraceEnd, TraceStart)) != None)
			{
			  `log("hi");
			}
		}
	}
}



event Possess(Pawn inPawn, bool bVehicleTransition)
{
	Super.Possess(inPawn, bVehicleTransition);
	SetBehindView(true);	
}

defaultproperties
{
	Name="Default__GhostHerdersPlayerController"

	// Disable mouse look
	bIgnoreLookInput=1
}


