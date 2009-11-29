class GhostHerdersGameInfo extends GameInfo
	config(Game);

struct TilePath
{
	// Number of steps (Manhattan distance)
	var int NumSteps;
	// Path to get there excluding starting space.
	// Each path element is the array index into GridNumSteps.
	var array<int> Path;
};

var GhostCharacter Chester;

// Number of steps to each location in 12 row, 10 column grid
var TilePath GridShortestPaths[120];
const GRID_NUM_ROWS=12;
const GRID_NUM_COLUMNS=10;
// TODO: Map should really have bottom-left corner at (0, 0)
const MAP_CORRECTION_VECTOR=vect(352, 288, 0);
// TODO: Could use split screen PlayerControllers instead
var int CurrentPlayer;  // 1,2
var bool IsCoinHeads;
	
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

function SwitchPlayers()
{
	local int i;

	// Flip "coin" if necessary
	If (CurrentPlayer == 1)
	{
		CurrentPlayer = 2;
	}
	else
	{
		CurrentPlayer = 1;
		// Flip coin after both players have gone
		IsCoinheads = !IsCoinHeads;
	}

	DisableInput();
	
	// Chester moves
	Chester.MoveGrid();

	// After Chester is done moving, the player can move
	EnableInput();
}

function DisableInput()
{
	local PlayerController PC;
	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		PC.GoToState('Waiting');
	}
}

function EnableInput()
{
	local PlayerController PC;
	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		PC.GoToState('');
	}
}


function SelectPawn(GhostHerdersPawn GHPawn)
{
	local int i;

	if (GHPawn.GHOwner != CurrentPlayer)
	{
		return;
	}

	// Clear GridShortestPaths to hold valid moves
	for (i = 0; i < GRID_NUM_ROWS * GRID_NUM_COLUMNS; i++)
	{
		GridShortestPaths[i].NumSteps = -1;
		GridShortestPaths[i].Path.Length = 0;
	}
}

function SelectDestination(GhostHerdersPawn GHPawn, Vector Destination)
{
	local int DestRow, DestColumn, GridIndex;
	GridFromLocation(Destination, DestRow, DestColumn);
	GridIndex = DestRow * GRID_NUM_COLUMNS + DestColumn;

	// Destination is valid if number of steps is tractable by Pawn
	if (GridShortestPaths[GridIndex].NumSteps <= GHPawn.GetAP(IsCoinHeads))
	{
		DisableInput();
		GHPawn.MoveGrid(DestRow, DestColumn);
		EnableInput();
	}
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
		if (GhostCharacterPositions.Find(Dest) == -1 && (!GHPawn.IsCarryingTriangle || TrianglePositions.Find(Dest) == -1))
		{
			nextPath = pathToHere;
			nextPath.Path.Add(Dest);
			FindNumSteps(GHPawn, Dest, nextPath, StepsLeft - 1);
		}
	}
	if ((Origin + 1) % GRID_NUM_COLUMNS != 0)
	{
		Dest = Origin + 1;
		if (GhostCharacterPositions.Find(Dest) == -1 && (!GHPawn.IsCarryingTriangle || TrianglePositions.Find(Dest) == -1))
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
		if (GhostCharacterPositions.Find(Dest) == -1 && (!GHPawn.IsCarryingTriangle || TrianglePositions.Find(Dest) == -1))
		{
			nextPath = pathToHere;
			nextPath.Path.Add(Dest);
			FindNumSteps(GHPawn, Dest, nextPath, StepsLeft - 1);
		}
	}
	if (Origin <= GRID_NUM_ROWS * GRID_NUM_COLUMNS - 1 - GRID_NUM_COLUMNS)
	{
		Dest = Origin - GRID_NUM_COLUMNS;
		if (GhostCharacterPositions.Find(Dest) == -1 && (!GHPawn.IsCarryingTriangle || TrianglePositions.Find(Dest) == -1))
		{
			nextPath = pathToHere;
			nextPath.Path.Add(Dest);
			FindNumSteps(GHPawn, Dest, nextPath, StepsLeft - 1);
		}
	}
}

exec function ShowMenu()
{
	local PlayerController PC;
	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		PC.ConsoleCommand( "quit" );
	}
}


defaultproperties
{
	HUDType=class'GhostHerdersHUD'
	bDelayedStart=false
	bRestartLevel=False

	PlayerControllerClass=class'GhostHerdersPlayerController'
	DefaultPawnClass=class'GhostHerdersPawn'

	Name="Default__GhostHerdersGameInfo"
}
