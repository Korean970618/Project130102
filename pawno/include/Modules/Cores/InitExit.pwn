/*
 *
 *
 *		PureunBa(서성범)
 *
 *          InitExit Core
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/02
 *		Update:		2013/01/02
 *
 *
 */



//-----< Variables



//-----< Defines



//-----< Callbacks
forward GameModeInitHandler_InitExit();
forward GameModeExitHandler_InitExit();
//-----< OnGameModeInit >-------------------------------------------------------
public GameModeInitHandler_InitExit()
{
    new str[64];
    
    AntiDeAMX();
    
	format(str,sizeof(str),"%s %s",SCRIPT_NAME,SCRIPT_VERSION);
	SetGameModeText(str);
	SendRconCommand("hostname "SERVER_HOSTNAME"");
	SetWorldTime(12);
	SetWeather(1);
	SetNameTagDrawDistance(30.0);
	ShowNameTags(true);
	ShowPlayerMarkers(true);
	LimitPlayerMarkerRadius(0.0);
	AllowInteriorWeapons(false);
	EnableStuntBonusForAll(false);
	DisableInteriorEnterExits();
	
	for(new i; i<20; i++)
	    SendClientMessageToAll(COLOR_WHITE," ");
	SendClientMessageToAll(COLOR_WHITE,"게임모드를 로딩중입니다.");
	return 1;
}
//-----< OnGameModeExit >-------------------------------------------------------
public GameModeExitHandler_InitExit()
{
    for(new i; i<GetMaxPlayers(); i++)
	{
		if(IsPlayerNPC(i))
			Kick(i);
		ShowPlayerDialog(i,0,DIALOG_STYLE_MSGBOX,"clear","clear","clear","clear");
        for(new j; j<MAX_PLAYER_ATTACHED_OBJECTS; j++)
			RemovePlayerAttachedObject(i,j);
	}
	for(new i; i<20; i++)
		SendClientMessageToAll(COLOR_WHITE," ");
	printf("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
	printf("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
	printf("[mode] Mode has been unloaded.");
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
