class GhostHerdersGameInfo extends UTDeathmatch;

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
