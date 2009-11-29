class GhostHerdersPawn extends GamePawn;

var int GridRow, GridColumn;
// TODO: In the future could use Controller "Owner" var defined in Actor.
var int GHOwner;
var bool IsCoinAffinityHeads;
var bool IsCarryingTriangle;

function int GetAP(bool IsCoinHeads)
{
	if ((IsCoinHeads && IsCoinAffinityHeads) || (!IsCoinHeads && !IsCoinAffinityHeads))
	{
		return 4;
	}
	else
	{
		return 2;
	}
}

// Move along grid, square by square.
function MoveGrid(int Row, int Column)
{
}
	
simulated function bool CalcCamera(float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV)
{
	local vector start, end, hl, hn;
        local vector cameraDisplacement;
	local actor a;

	start = Location;
	
	if (Controller != none)
	{
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
	
	out_CamRot = Rotator(vect(0,0,0) - out_CamLoc);
	out_FOV = 1.5f;
	return true;
}

defaultproperties
{
	Name="Default__GhostHerdersPawn"
}
