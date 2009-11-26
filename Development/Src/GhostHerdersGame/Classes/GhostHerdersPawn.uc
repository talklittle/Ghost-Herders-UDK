class GhostHerdersPawn extends UTPawn;

var int GridRow, GridColumn;

function bool IsCarryingTriangle()
{
	// TODO
	return false;
}
	
simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
	if ( Physics == PHYS_Ladder )
	{
		NewRotation = OnLadder.Walldir;
	}
	else if ( (Physics == PHYS_Walking) || (Physics == PHYS_Falling) )
	{
		NewRotation.Pitch = 0;
	}
	//NewRotation.Roll = Rotation.Roll;
	NewRotation.Roll = 0;
	SetRotation(NewRotation);
}

simulated function bool CalcCamera(float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV)
{
	local vector start, end, hl, hn;
        local vector cameraDisplacement;
	local actor a;

	// TODO: Fix camera going through ground

	start = Location;
	
	if (Controller != none)
	{
		//end = Location - Vector(Controller.Rotation) * 512.f;
		// use cameraDisplacement for fixed camera
                cameraDisplacement.X = 0;
                cameraDisplacement.Y = 0;
                cameraDisplacement.Z = 48000;
		end = cameraDisplacement;
	}
	else
	{
		end = Location - Vector(Rotation) * 192.f;
	}
	
	a = Trace(hl, hn, end, start, false);
	
	if (a != none)
	{
		out_CamLoc = hl;
	}
	else
	{
		out_CamLoc = end;
	}
	
	//out_CamRot = Rotator(Location - (out_CamLoc - vect(0,0,192)));
	out_CamRot = Rotator(vect(0,0,0) - out_CamLoc);
	out_FOV = 1.5f;
	return true;
}

defaultproperties
{
	Begin Object Name=WPawnSkeletalMeshComponent
		bOwnerNoSee=false
	End Object
	Name="Default__GhostHerdersPawn"
}
