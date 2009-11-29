class GhostHerdersHUD extends GameHUD;

var int CursorX, CursorY;
var byte bShowCursor;
var vector WorldOrigin, WorldDirection;

// function from user JeremyStieglitz
// http://forums.epicgames.com/showthread.php?t=708724
function vector2D GetMouseCoordinates()
{
	local Vector2D mousePos;
	local UIInteraction UIController;
	local GameUISceneClient GameSceneClient;

	UIController  = PlayerOwner.GetUIController();

	if ( UIController != None)
	{
		GameSceneClient = UIController.SceneClient;
		if ( GameSceneClient != None )
		{
	             mousePos.X = GameSceneClient.MousePosition.X;
	             mousePos.Y = GameSceneClient.MousePosition.Y;
                }
         }

	return mousePos;
}

event PostRender()
{
	local Vector2D MouseCoordinates;
	MouseCoordinates = GetMouseCoordinates();
	CursorX = MouseCoordinates.X;
	CursorY = MouseCoordinates.Y;
	Canvas.DeProject(MouseCoordinates,WorldOrigin,WorldDirection);
	Super.PostRender();
}

function DrawHUD()
{
	local float CrosshairSize;

	if (bShowCursor > 0)
	{
		Canvas.SetDrawColor(255, 255, 255, 255);

		if(PlayerOwner != None && Pawn(PlayerOwner.ViewTarget) != None)
		{
			// Draw Temporary Crosshair
			CrosshairSize = 4;
			Canvas.SetPos(CursorX - CrosshairSize, CursorY);
			Canvas.DrawRect(2*CrosshairSize + 1, 1);

			Canvas.SetPos(CursorX, CursorY - CrosshairSize);
			Canvas.DrawRect(1, 2*CrosshairSize + 1);
		}
	}
}

defaultproperties
{
	bShowCursor = 1
	CursorX=0
	CursorY=0
	WorldOrigin=(X=0,Y=0,Z=0)
	WorldDirection=(X=0,Y=0,Z=0)
}
