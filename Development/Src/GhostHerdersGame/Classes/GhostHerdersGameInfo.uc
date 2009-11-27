class GhostHerdersGameInfo extends UTDeathmatch;

struct TilePath
{
	// Number of steps (Manhattan distance)
	var int NumSteps;
	// Path to get there excluding starting space.
	// Each path element is the array index into GridNumSteps.
	var array<int> Path;
};

// Number of steps to each location in 12 row, 10 column grid
var TilePath GridShortestPaths[120];
const GRID_NUM_ROWS=12;
const GRID_NUM_COLUMNS=10;
// XXX: Map should really have bottom-left corner at (0, 0)
const MAP_CORRECTION_VECTOR=vect(352, 288, 0);
	

var array<int> GhostCharacterPositions;
var array<int> TrianglePositions;

static function GridFromLocation(Vector GridLocation, out int GridRow, out int GridColumn)
{
	local Vector CorrectedLocation;
	CorrectedLocation = GridLocation + MAP_CORRECTION_VECTOR;

	// Yes, X is up-and-down = row
	GridRow = (GRID_NUM_ROWS * 64 - CorrectedLocation.X) / 64;
	GridColumn = CorrectedLocation.Y / 64;
}

/** Recursive function to find number of steps to surrounding tiles */
function FindNumSteps(GhostHerdersPawn GHPawn, int Origin, TilePath pathToHere, int StepsLeft)
{
	local int Dest;
	local TilePath nextPath;

	// If this tile wasn't explored yet, or if pathToHere is shorter, save it
	if (GridShortestPaths[Origin].NumSteps == -1 || PathToHere.NumSteps < GridShortestPaths[Origin].NumSteps)
	{
		GridShortestPaths[Origin] = PathToHere;
	}
	// Stop recursion if this is our last step
	if (StepsLeft == 0)
	{
		return;
	}

	// Try to move to surrounding cells

	// Try changing column
	if (Origin % GRID_NUM_COLUMNS != 0)
	{
		Dest = Origin - 1;
		// Good destination if it doesn't contain something that collides with GHPawn
		if (GhostCharacterPositions.Find(Dest) == -1 && (!GHPawn.IsCarryingTriangle() || TrianglePositions.Find(Dest) == -1))
		{
			nextPath = pathToHere;
			nextPath.Path.Add(Dest);
			FindNumSteps(GHPawn, Dest, nextPath, StepsLeft - 1);
		}
	}
	if ((Origin + 1) % GRID_NUM_COLUMNS != 0)
	{
		Dest = Origin + 1;
		if (GhostCharacterPositions.Find(Dest) == -1 && (!GHPawn.IsCarryingTriangle() || TrianglePositions.Find(Dest) == -1))
		{
			nextPath = pathToHere;
			nextPath.Path.Add(Dest);
			FindNumSteps(GHPawn, Dest, nextPath, StepsLeft - 1);
		}
	}
	// Try changing row
	if (Origin >= GRID_NUM_COLUMNS)
	{
		Dest = Origin + GRID_NUM_COLUMNS;
		if (GhostCharacterPositions.Find(Dest) == -1 && (!GHPawn.IsCarryingTriangle() || TrianglePositions.Find(Dest) == -1))
		{
			nextPath = pathToHere;
			nextPath.Path.Add(Dest);
			FindNumSteps(GHPawn, Dest, nextPath, StepsLeft - 1);
		}
	}
	if (Origin <= GRID_NUM_ROWS * GRID_NUM_COLUMNS - 1 - GRID_NUM_COLUMNS)
	{
		Dest = Origin - GRID_NUM_COLUMNS;
		if (GhostCharacterPositions.Find(Dest) == -1 && (!GHPawn.IsCarryingTriangle() || TrianglePositions.Find(Dest) == -1))
		{
			nextPath = pathToHere;
			nextPath.Path.Add(Dest);
			FindNumSteps(GHPawn, Dest, nextPath, StepsLeft - 1);
		}
	}
}

defaultproperties
{
	Acronym="GH"	

	MapPrefixes.Empty
	MapPrefixes(0)="GH"

	DefaultMapPrefixes.Empty
	DefaultMapPrefixes(0)=(Prefix="GH",GameType="GhostHerdersGame.GhostHerdersGameInfo")

	HUDType=class'GhostHerdersHUD'
	PlayerControllerClass=class'GhostHerdersPlayerController'
	DefaultPawnClass=class'GhostHerdersPawn'

	Name="Default__GhostHerdersGameInfo"
}
