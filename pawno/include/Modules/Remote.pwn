/*
 *
 *
 *			Nogov Remote Module
 *		  	2013/04/27
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	pConnectHandler_Remote(playerid)
	pSpawnHandler_Remote(playerid)
	pDisconnectHandler_Remote(playerid, reason)
	pUpdateHandler_Remote(playerid)
	pTextHandler_Remote(playerid, text[])
	pCommandTextHandler_Remote(playerid, cmdtext[])
	pKeyStateChangeHandler_Remote(playerid, newkeys, oldkeys)
	
  < Functions >
	StartRemote(playerid, destid)
	StopRemote(playerid)

*/



//-----< Defines



//-----< Variables
enum eRemoteInfo
{
	rController,
	rState,
	rTextAccess,
	rCommandAccess,
	rKeyAccess
}
new RemoteInfo[MAX_PLAYERS][eRemoteInfo];
enum eControlInfo
{
	cDest,
	cSpawning,
	cInterior,
	cVirtualWorld,
	Float:cPos[4]
}
new ControlInfo[MAX_PLAYERS][eControlInfo];



//-----< Callbacks
forward pConnectHandler_Remote(playerid);
forward pSpawnHandler_Remote(playerid);
forward pDisconnectHandler_Remote(playerid, reason);
forward pUpdateHandler_Remote(playerid);
forward pTextHandler_Remote(playerid, text[]);
forward pCommandTextHandler_Remote(playerid, cmdtext[]);
forward pKeyStateChangeHandler_Remote(playerid, newkeys, oldkeys);
//-----< pConnectHandler >------------------------------------------------------
public pConnectHandler_Remote(playerid)
{
	RemoteInfo[playerid][rController]		= INVALID_PLAYER_ID;
	RemoteInfo[playerid][rState]			= PLAYER_STATE_NONE;
	RemoteInfo[playerid][rCommandAccess]	= false;
	RemoteInfo[playerid][rKeyAccess]		= false;
	
	ControlInfo[playerid][cDest]			= INVALID_PLAYER_ID;
	ControlInfo[playerid][cSpawning]		= false;
	ControlInfo[playerid][cInterior]		= 0;
	ControlInfo[playerid][cVirtualWorld]	= 0;
	for (new i = 0; i < 4; i++)
		ControlInfo[playerid][cPos][i]		= 0.0;
	return 1;
}
//-----< pSpawnHandler >--------------------------------------------------------
public pSpawnHandler_Remote(playerid)
{
	if (ControlInfo[playerid][cSpawning])
	{
		ControlInfo[playerid][cSpawning] = false;
		SetPlayerInterior(playerid, ControlInfo[playerid][cInterior]);
		SetPlayerVirtualWorld(playerid, ControlInfo[playerid][cVirtualWorld]);
		SetPlayerPos(playerid, ControlInfo[playerid][cPos][0], ControlInfo[playerid][cPos][1], ControlInfo[playerid][cPos][2]);
		SetPlayerFacingAngle(playerid, ControlInfo[playerid][cPos][3]);
		SetCameraBehindPlayer(playerid);
	}
	return 1;
}
//-----< pDisconnectHandler >---------------------------------------------------
public pDisconnectHandler_Remote(playerid, reason)
{
	new controller = RemoteInfo[playerid][rController];
	if (controller != INVALID_PLAYER_ID)
	{
		SendClientMessage(controller, COLOR_YELLOW, "원격 대상자가 접속을 종료했습니다.");
		StopRemote(controller);
		RemoteInfo[playerid][rController] = INVALID_PLAYER_ID;
	}
	return 1;
}
//-----< pUpdateHandler >-------------------------------------------------------
public pUpdateHandler_Remote(playerid)
{
	new controller = RemoteInfo[playerid][rController];
	if (IsPlayerConnected(controller))
	{
		new sta = GetPlayerState(playerid);
		if (RemoteInfo[playerid][rState] != sta)
		{
			RemoteInfo[playerid][rState] = sta;
			SetPlayerInterior(controller, GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(controller, GetPlayerVirtualWorld(playerid));
			switch (sta)
			{
				case PLAYER_STATE_DRIVER:
					PlayerSpectateVehicle(controller, GetPlayerVehicleID(playerid));
				case PLAYER_STATE_PASSENGER:
					PlayerSpectateVehicle(controller, GetPlayerVehicleID(playerid));
				case PLAYER_STATE_SPECTATING:
				{
					SendClientMessage(controller, COLOR_YELLOW, "원격 대상자가 다른 대상을 원격합니다.");
					StopRemote(controller);
					RemoteInfo[playerid][rController] = INVALID_PLAYER_ID;
				}
				default:
					PlayerSpectatePlayer(controller, playerid);
			}
		}
	}
	else if (RemoteInfo[playerid][rController] != INVALID_PLAYER_ID)
		RemoteInfo[playerid][rController] = INVALID_PLAYER_ID;
	return 1;
}
//-----< pTextHandler >---------------------------------------------------------
public pTextHandler_Remote(playerid, text[])
{
	if (IsPlayerConnected(RemoteInfo[playerid][rController])
	&& RemoteInfo[playerid][rTextAccess])
	{
		CallLocalFunction("OnPlayerText", "ds", playerid, FixBlankString(text));
		return 0;
	}
	return 1;
}
//-----< pCommandTextHandler >--------------------------------------------------
public pCommandTextHandler_Remote(playerid, cmdtext[])
{
	if (IsPlayerConnected(RemoteInfo[playerid][rController])
	&&  RemoteInfo[playerid][rCommandAccess])
	{
		CallLocalFunction("OnPlayerCommandText", "ds", playerid, FixBlankString(cmdtext));
		return 1;
	}
	return 0;
}
//-----< pKeyStateChangeHandler >-----------------------------------------------
public pKeyStateChangeHandler_Remote(playerid, newkeys, oldkeys)
{
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< StartRemote >----------------------------------------------------------
stock StartRemote(playerid, destid)
{
	ControlInfo[playerid][cInterior]		= GetPlayerInterior(playerid);
	ControlInfo[playerid][cVirtualWorld]	= GetPlayerVirtualWorld(playerid);
	GetPlayerPos(playerid, ControlInfo[playerid][cPos][0], ControlInfo[playerid][cPos][1], ControlInfo[playerid][cPos][2]);
	GetPlayerFacingAngle(playerid, ControlInfo[playerid][cPos][3]);
	
	RemoteInfo[destid][rController] = playerid;
	ControlInfo[playerid][cDest] = destid;
	TogglePlayerSpectating(controller, true);
	return 1;
}
//-----< StopRemote >-----------------------------------------------------------
stock StopRemote(playerid)
{
	TogglePlayerSpectating(playerid, false);
	ControlInfo[playerid][cSpawning] = true;
	ControlInfo[playerid][cDest] = INVALID_PLAYER_ID;
	SpawnPlayer_(playerid);
	return 1;
}
//-----<  >---------------------------------------------------------------------
