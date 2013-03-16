/*
 *
 *
 *		  Nogov InitExit Core
 *		  	2013/01/02
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Modules >
	gInitHandler_InitExit()
	gExitHandler_InitExit()

  < Functions >

*/



//-----< Variables



//-----< Defines



//-----< Callbacks
forward gInitHandler_InitExit();
forward gExitHandler_InitExit();
//-----< gInitHandler_InitExit >------------------------------------------------
public gInitHandler_InitExit()
{
	new str[64];

	AntiDeAMX();

	format(str, sizeof(str), "%s %s", SCRIPT_NAME, SCRIPT_VERSION);
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
	
	for (new i; i < 20; i++)
		SendClientMessageToAll(COLOR_WHITE, " ");
	SendClientMessageToAll(COLOR_WHITE, "게임모드를 로딩중입니다.");
	return 1;
}
//-----< gExitHandler_InitExit >------------------------------------------------
public gExitHandler_InitExit()
{
	for (new i; i < GetMaxPlayers(); i++)
	{
		if (IsPlayerNPC(i))
			Kick(i);
		ShowPlayerDialog(i, 0, DIALOG_STYLE_MSGBOX, "Rebooting", "서버를 리붓중입니다.\n잠시만 기다려 주세요.", "확인", chNullString);
		for (new j; j<MAX_PLAYER_ATTACHED_OBJECTS; j++)
			RemovePlayerAttachedObject(i, j);
	}
	for (new i; i < 20; i++)
		SendClientMessageToAll(COLOR_WHITE, " ");
	printf("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
	printf("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
	printf("[mode] Mode has been unloaded.");
	Wait(3000);
	Crash();
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
