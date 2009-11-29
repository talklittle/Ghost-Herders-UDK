class GhostHerdersPlayerController extends PlayerController;

// The player wants to fire.
exec function StartFire( optional byte FireModeNum )
{
	local GhostCharacter C;
	local GhostHerdersHUD ghHUD;
	local vector TraceStart, TraceEnd, HitLocation, HitNormal;
	local int GridRow, GridColumn;

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
			if (Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false) != None)
			{
				//HitLocation += class'GhostHerdersGameInfo'.const.MAP_CORRECTION_VECTOR;
				//`log("Level corrected HitLocation"@HitLocation);
				class'GhostHerdersGameInfo'.static.GridFromLocation(HitLocation, GridRow, GridColumn);
				`log("Level Grid Row, Column"@GridRow@GridColumn);
			}
			if (GhostCharacter(Trace(HitLocation, HitNormal, TraceEnd, TraceStart)) != None)
			{
				HitLocation += class'GhostHerdersGameInfo'.const.MAP_CORRECTION_VECTOR;
				`log("Corrected HitLocation"@HitLocation);
			}
		}
	}
}


state Waiting
{
	exec function StartFire( optional byte FireModeNum )
	{
	}
}




defaultproperties
{
	Name="Default__GhostHerdersPlayerController"

	// Disable mouse look
	bIgnoreLookInput=1
}


