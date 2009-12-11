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

				// FIXME: SetDesiredRotation on Pawn
				//C.SetDesiredRotation(Rotator(HitLocation - C.Location));
				C.Destination = HitLocation;
			}
			if (GhostCharacter(Trace(HitLocation, HitNormal, TraceEnd, TraceStart)) != None)
			{
				HitLocation += class'GhostHerdersGameInfo'.const.MAP_CORRECTION_VECTOR;
				`log("Corrected HitLocation"@HitLocation);
			}
		}
	}
}

function PlayerMove(float DeltaTime)
{
	local Vector NewAccel;
	local eDoubleClickDir DoubleClickMove;
	local GhostCharacter C;

	Super.PlayerMove(DeltaTime);

	C = GhostHerdersGameInfo(WorldInfo.Game).Chester;

	NewAccel = Normal(C.Destination - C.Location);

	DoubleClickMove = 0;

	if( Role < ROLE_Authority ) // then save this move and replicate it
	{
		//ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
		ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, rot(0,0,0));
	}
	else
	{
		ProcessMove(DeltaTime, NewAccel, DoubleClickMove, rot(0,0,0));
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


