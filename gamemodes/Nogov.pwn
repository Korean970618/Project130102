/*
 *
 *
 *			Nogov Main Script
 *		  	2013/01/02
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Dialog List >
	0: Nogov Main Script
	25: Player Module
	50: Admin Module
	75: PropertyData Module
	100: Item Module

  < MpList List >
	0: Nogov Main Script
	25: Admin Module

  < VirtualWorld List >
	0: Nogov Main Script
	25: Position Module

  < Attached Object Slots (0~9) >
	0: Item Core
	1: Item Core

  < Functions >
	AddHandler(module[], ...)

*/



//-----< Pre-Defines
#define SCRIPT_NAME				"Nogov"
#define SCRIPT_VERSION			"Alpha"
#define SERVER_HOSTNAME			"&Nogov"
#define SERVER_MAPNAME			"San Fierro"


//-----< Includes
#include <a_samp>
#include <mysql>
#include <streamer>
#include <audio>
#include <Nogov>
//-----< Modules >--------------------------------------------------------------
#include "Modules/MySQL.pwn"
#include "Modules/InitExit.pwn"
#include "Modules/Player.pwn"
#include "Modules/Property.pwn"
#include "Modules/Vehicle.pwn"
#include "Modules/Item.pwn"
#include "Modules/Fly.pwn"
#include "Modules/Position.pwn"
#include "Modules/MpList.pwn"
#include "Modules/GVar.pwn"
#include "Modules/Admin.pwn"
#include "Modules/Animation.pwn"
#include "Modules/Grant.pwn"
#include "Modules/Cheat.pwn"
#include "Modules/Remote.pwn"
#include "Modules/BadWord.pwn"
#include "Modules/Chat.pwn"
#include "Modules/Faction.pwn"



//-----< Defines
//-----< Handlers >-------------------------------------------------------------
#define gInitHandler		 			1
#define gExitHandler		 			2
#define pRequestClassHandler   			3
#define pConnectHandler					4
#define pDisconnectHandler		 		5
#define pSpawnHandler			  		6
#define pDeathHandler			  		7
#define vSpawnHandler			 		8
#define vDeathHandler			 		9
#define pTextHandler			   		10
#define pCommandTextHandler				11
#define pEnterVehicleHandler			12
#define pExitVehicleHandler				13
#define pStateChangeHandler				14
#define pEnterCheckpointHandler			15
#define pLeaveCheckpointHandler			16
#define pEnterRaceCheckpointHandler		17
#define pLeaveRaceCheckpointHandler		18
#define RconCommandHandler				19
#define pRequestSpawnHandler			20
#define oMovedHandler					21
#define pObjectMovedHandler				22
#define pPickUpPickupHandler			23
#define vModHandler						24
#define vPaintjobHandler				25
#define vResprayHandler					26
#define pSelectedMenuRowHandler			27
#define pExitedMenuHandler				28
#define pInteriorChangeHandler			29
#define pKeyStateChangeHandler			30
#define RconLoginAttempHandler			31
#define pUpdateHandler					32
#define pStreamInHandler				33
#define pStreamOutHandler				34
#define vStreamInHandler				35
#define vStreamOutHandler				36
#define dResponseHandler				37
#define pTakeDamageHandler			  	38
#define pGiveDamageHandler			  	39
#define pClickMapHandler				40
#define pClickTDHandler		   			41
#define pClickPlayerTDHandler	 		42
#define pClickPlayerHandler				43
#define pEditObjectHandler				44
#define pEditAttachedObjectHandler		45
#define tTickHandler					46
#define pTimerTickHandler				47
#define aConnectHandler					48
#define aDisconnectHandler				49
#define aTransferFileHandler			50
#define aPlayHandler					51
#define aStopHandler					52
#define aTrackChangeHandler				53
#define aRadioStationChangeHandler		54
#define aGetPositionHandler				55
#define dRequestHandler					56
#define pSelectObjectHandler			57
#define mplResponseHandler				58
#define doMovedHandler					59
#define pEditDynamicObjectHandler		60
#define pSelectDynamicObjectHandler		61
#define pPickUpDynamicPickupHandler		62
#define pEnterDynamicCPHandler			63
#define pLeaveDynamicCPHandler			64
#define pEnterDynamicRaceCPHandler		65
#define pLeaveDynamicRaceCPHandler		66
#define pEnterDynamicAreaHandler		67
#define pLeaveDynamicAreaHandler		68

#define MAX_CALLBACKS					68
#define CALL_HANDLER(%0,%1)				for(new i = 0; i <= CallbacksIndex; i++) if(CallbacksList[i][CBIndex][%0]) { new callstr[64]; format(callstr, 64, "%s_%s", %1, CallbacksList[i][CBName]);



//-----< Variables
enum eCallBacks
{
	CBName[16],
	CBIndex[MAX_CALLBACKS+1]
}
new
	CallbacksList[50][eCallBacks],
	CallbacksIndex = -1,
	Timer_OneSecTimer
;



//-----< Callbacks
forward OnTimerTick();
forward OnMpListResponse(playerid, mplistid, selecteditem);
//-----< main >-----------------------------------------------------------------
main()
{
	AntiDeAMX();
	
	new str[256];
	format(str, sizeof(str), "hostname %s", SERVER_HOSTNAME);
	SendRconCommand(str);
	format(str, sizeof(str), "mapname %s", SERVER_MAPNAME);
	SendRconCommand(str);
	format(str, sizeof(str), "%s %s", SCRIPT_NAME, SCRIPT_VERSION);
	SetGameModeText(str);
	
	printf("\n---------------------------------\n");
	printf(" %s %s\n", SCRIPT_NAME, SCRIPT_VERSION);
	printf(" \tCoded by sBum");
	printf(" \tpureunba.tistory.com\n");
	printf("---------------------------------\n");
	return 1;
}
//-----< OnGameModeInit >-------------------------------------------------------
public OnGameModeInit()
{
	AddHandler("MySQL",				gInitHandler);
	AddHandler("InitExit",			gInitHandler, gExitHandler);
	AddHandler("Player",			gInitHandler, pConnectHandler, pDisconnectHandler, aConnectHandler, pRequestClassHandler, pRequestSpawnHandler, aConnectHandler, pUpdateHandler, pDeathHandler, pKeyStateChangeHandler, pSpawnHandler, pCommandTextHandler, dRequestHandler, dResponseHandler, pTimerTickHandler, pTakeDamageHandler);
	AddHandler("Property",			gInitHandler, pConnectHandler, dResponseHandler, pKeyStateChangeHandler);
	AddHandler("Vehicle",			gInitHandler);
	AddHandler("Item",			  	gInitHandler, pSpawnHandler, pConnectHandler, pUpdateHandler, pKeyStateChangeHandler, pCommandTextHandler, dResponseHandler, pEditDynamicObjectHandler, pEditAttachedObjectHandler, pTimerTickHandler);
	AddHandler("Fly",				gInitHandler, pConnectHandler, pUpdateHandler);
	AddHandler("Position",			gInitHandler, pConnectHandler, pUpdateHandler, pTimerTickHandler);
	AddHandler("MpList",			pConnectHandler, pClickTDHandler, pClickPlayerTDHandler);
	AddHandler("GVar",				gInitHandler);
	AddHandler("Cheat",				pKeyStateChangeHandler, pSpawnHandler);
	AddHandler("Admin",				pCommandTextHandler, dResponseHandler, mplResponseHandler);
	AddHandler("Animation",			pCommandTextHandler);
	AddHandler("Remote",			pConnectHandler, pSpawnHandler, pDisconnectHandler, pUpdateHandler, pTextHandler, pCommandTextHandler, pKeyStateChangeHandler);
	AddHandler("BadWord",			gInitHandler);
	AddHandler("Chat",				pTextHandler, pCommandTextHandler);
	AddHandler("Faction",			gInitHandler);
	
	SetTimer("OnTimerTick", TimeFix(100), true);
	Timer_OneSecTimer = GetTickCount();

	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][gInitHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "gInitHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "");
		}
	return 1;
}
//-----< OnGameModeExit >-------------------------------------------------------
public OnGameModeExit()
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][gExitHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "gExitHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "");
		}
	return 1;
}
//-----< OnPlayerRequestClass >-------------------------------------------------
public OnPlayerRequestClass(playerid, classid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pRequestClassHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pRequestClassHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, classid);
		}
	return 1;
}
//-----< OnPlayerConnect >------------------------------------------------------
public OnPlayerConnect(playerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pConnectHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pConnectHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", playerid);
		}
	return 1;
}
//-----< OnPlayerDisconnect >---------------------------------------------------
public OnPlayerDisconnect(playerid, reason)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pDisconnectHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pDisconnectHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, reason);
		}
	return 1;
}
//-----< OnPlayerSpawn >--------------------------------------------------------
public OnPlayerSpawn(playerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pSpawnHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pSpawnHandler", CallbacksList[i][CBName]);
			if(!CallLocalFunction(funcstr, "d", playerid)) return 0;
		}
	return 1;
}
//-----< OnPlayerDeath >--------------------------------------------------------
public OnPlayerDeath(playerid, killerid, reason)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pDeathHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pDeathHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddd", playerid, killerid, reason);
		}
	return 1;
}
//-----< OnVehicleSpawn >-------------------------------------------------------
public OnVehicleSpawn(vehicleid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][vSpawnHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "vSpawnHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", vehicleid);
		}
	return 1;
}
//-----< OnVehicleDeath >-------------------------------------------------------
public OnVehicleDeath(vehicleid, killerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][vDeathHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "vDeathHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", vehicleid, killerid);
		}
	return 1;
}
//-----< OnPlayerText >---------------------------------------------------------
public OnPlayerText(playerid, text[])
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pTextHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pTextHandler", CallbacksList[i][CBName]);
			if(!CallLocalFunction(funcstr, "ds", playerid, FixBlankString(text))) return 0;
		}
	return 1;
}
//-----< OnPlayerCommandText >--------------------------------------------------
public OnPlayerCommandText(playerid, cmdtext[])
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pCommandTextHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pCommandTextHandler", CallbacksList[i][CBName]);
			if(CallLocalFunction(funcstr, "ds", playerid, FixBlankString(cmdtext))) return 1;
		}
	SendClientMessage(playerid, COLOR_WHITE, "[SERVER] �������� �ʴ� ��ɾ��Դϴ�.");
	return 1;
}
//-----< OnPlayerEnterVehicle >-------------------------------------------------
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pEnterVehicleHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pEnterVehicleHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddd", playerid, vehicleid, ispassenger);
		}
	return 1;
}
//-----< OnPlayerExitVehicle >--------------------------------------------------
public OnPlayerExitVehicle(playerid, vehicleid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pExitVehicleHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pExitVehicleHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, vehicleid);
		}
	return 1;
}
//-----< OnPlayerStateChange >--------------------------------------------------
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pStateChangeHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pStateChangeHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddd", playerid, newstate, oldstate);
		}
	return 1;
}
//-----< OnPlayerEnterCheckpoint >----------------------------------------------
public OnPlayerEnterCheckpoint(playerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pEnterCheckpointHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pEnterCheckpointHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", playerid);
		}
	return 1;
}
//-----< OnPlayerLeaveCheckpoint >----------------------------------------------
public OnPlayerLeaveCheckpoint(playerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pLeaveCheckpointHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pLeaveCheckpointHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", playerid);
		}
	return 1;
}
//-----< OnPlayerEnterRaceCheckpoint >------------------------------------------
public OnPlayerEnterRaceCheckpoint(playerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pEnterRaceCheckpointHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pEnterRaceCheckpointHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", playerid);
		}
	return 1;
}
//-----< OnPlayerLeaveRaceCheckpoint >------------------------------------------
public OnPlayerLeaveRaceCheckpoint(playerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pLeaveRaceCheckpointHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pLeaveRaceCheckpointHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", playerid);
		}
	return 1;
}
//-----< OnRconCommand >--------------------------------------------------------
public OnRconCommand(cmd[])
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][RconCommandHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "RconCommandHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "s", FixBlankString(cmd));
		}
	return 1;
}
//-----< OnPlayerRequestSpawn >-------------------------------------------------
public OnPlayerRequestSpawn(playerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pRequestClassHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pRequestSpawnHandler", CallbacksList[i][CBName]);
			if(!CallLocalFunction(funcstr, "d", playerid)) return 0;
		}
	return 1;
}
//-----< OnObjectMoved >--------------------------------------------------------
public OnObjectMoved(objectid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][oMovedHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "oMovedHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", objectid);
		}
	return 1;
}
//-----< OnPlayerObjectMoved >--------------------------------------------------
public OnPlayerObjectMoved(playerid, objectid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pObjectMovedHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pObjectMovedHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, objectid);
		}
	return 1;
}
//-----< OnPlayerPickUpPickup >-------------------------------------------------
public OnPlayerPickUpPickup(playerid, pickupid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pPickUpPickupHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pPickUpPickupHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, pickupid);
		}
	return 1;
}
//-----< OnVehicleMod >---------------------------------------------------------
public OnVehicleMod(playerid, vehicleid, componentid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][vModHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "vModHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddd", playerid, vehicleid, componentid);
		}
	return 1;
}
//-----< OnVehiclePaintjob >----------------------------------------------------
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][vPaintjobHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "vPaintjobHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddd", playerid, vehicleid, paintjobid);
		}
	return 1;
}
//-----< OnVehicleRespray >-----------------------------------------------------
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][vResprayHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "vResprayHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dddd", playerid, vehicleid, color1, color2);
		}
	return 1;
}
//-----< OnPlayerSelectedMenuRow >----------------------------------------------
public OnPlayerSelectedMenuRow(playerid, row)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pSelectedMenuRowHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pSelectedMenuRowHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, row);
		}
	return 1;
}
//-----< OnPlayerExitedMenu >---------------------------------------------------
public OnPlayerExitedMenu(playerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pExitedMenuHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pExitedMenuHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", playerid);
		}
	return 1;
}
//-----< OnPlayerInteriorChange >-----------------------------------------------
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pInteriorChangeHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pInteriorChangeHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddd", playerid, newinteriorid, oldinteriorid);
		}
	return 1;
}
//-----< OnPlayerKeyStateChange >-----------------------------------------------
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pKeyStateChangeHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pKeyStateChangeHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddd", playerid, newkeys, oldkeys);
		}
	return 1;
}
//-----< OnRconLoginAttempt >---------------------------------------------------
public OnRconLoginAttempt(ip[], password[], success)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][RconLoginAttempHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "RconLoginAttempHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ssd", FixBlankString(ip), FixBlankString(password), success);
		}
	return 1;
}
//-----< OnPlayerUpdate >-------------------------------------------------------
public OnPlayerUpdate(playerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pUpdateHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pUpdateHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", playerid);
		}
	return 1;
}
//-----< OnPlayerStreamIn >-----------------------------------------------------
public OnPlayerStreamIn(playerid, forplayerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pStreamInHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pStreamInHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, forplayerid);
		}
	return 1;
}
//-----< OnPlayerStreamOut >----------------------------------------------------
public OnPlayerStreamOut(playerid, forplayerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pStreamOutHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pStreamOutHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, forplayerid);
		}
	return 1;
}
//-----< OnVehicleStreamIn >----------------------------------------------------
public OnVehicleStreamIn(vehicleid, forplayerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][vStreamInHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "vStreamInHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", vehicleid, forplayerid);
		}
	return 1;
}
//-----< OnVehicleStreamOut >---------------------------------------------------
public OnVehicleStreamOut(vehicleid, forplayerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][vStreamOutHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "vStreamOutHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", vehicleid, forplayerid);
		}
	return 1;
}
//-----< OnDialogResponse >-----------------------------------------------------
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][dResponseHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "dResponseHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dddds", playerid, dialogid, response, listitem, FixBlankString(inputtext));
		}
	return 1;
}
//-----< OnPlayerTakeDamage >---------------------------------------------------
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pTakeDamageHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pTakeDamageHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddfd", playerid, issuerid, amount, weaponid);
		}
	return 1;
}
//-----< OnPlayerGiveDamage >---------------------------------------------------
public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pGiveDamageHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pGiveDamageHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddfd", playerid, damagedid, amount, weaponid);
		}
	return 1;
}
//-----< OnPlayerClickMap >-----------------------------------------------------
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pClickMapHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pClickMapHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dfff", playerid, fX, fY, fZ);
		}
	return 1;
}
//-----< OnPlayerClickTextDraw >------------------------------------------------
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pClickTDHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pClickTDHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, clickedid);
		}
	return 1;
}
//-----< OnPlayerClickPlayerTextDraw >------------------------------------------
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pClickPlayerTDHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pClickPlayerTDHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, playertextid);
		}
	return 1;
}
//-----< OnPlayerClickPlayer >--------------------------------------------------
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pClickPlayerHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pClickPlayerHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddd", playerid, clickedplayerid, source);
		}
	return 1;
}
//-----< OnPlayerEditObject >---------------------------------------------------
public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pEditObjectHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pEditObjectHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddddffffff", playerid, playerobject, objectid, response, fX, fY, fZ, fRotX, fRotY, fRotZ);
		}
	return 1;
}
//-----< OnPlayerEditAttachedObject >-------------------------------------------
public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pEditAttachedObjectHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pEditAttachedObjectHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dddddfffffffff", playerid, response, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
		}
	return 1;
}
//-----< OnTimerTick >----------------------------------------------------------
public OnTimerTick()
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][tTickHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "tTickHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", 100);
		}
	for(new i = 0, t = GetMaxPlayers(); i < t; i++)
		for(new j = 0; j <= CallbacksIndex; j++)
			if(CallbacksList[j][CBIndex][pTimerTickHandler])
			{
				format(funcstr, sizeof(funcstr), "%s_%s", "pTimerTickHandler", CallbacksList[j][CBName]);
				CallLocalFunction(funcstr, "dd", 100, i);
			}
	if((GetTickCount() - Timer_OneSecTimer) / 1000)
	{
		for(new i = 0; i <= CallbacksIndex; i++)
			if(CallbacksList[i][CBIndex][tTickHandler])
			{
				format(funcstr, sizeof(funcstr), "%s_%s", "tTickHandler", CallbacksList[i][CBName]);
				CallLocalFunction(funcstr, "d", 1000);
			}
		for(new i = 0, t = GetMaxPlayers(); i < t; i++)
			for(new j = 0; j <= CallbacksIndex; j++)
				if(CallbacksList[j][CBIndex][pTimerTickHandler])
				{
					format(funcstr, sizeof(funcstr), "%s_%s", "pTimerTickHandler", CallbacksList[j][CBName]);
					CallLocalFunction(funcstr, "dd", 1000, i);
				}
		Timer_OneSecTimer = GetTickCount();
	}
	return 1;
}
//-----< Audio_OnClientConnect >------------------------------------------------
public Audio_OnClientConnect(playerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][aConnectHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "aConnectHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", playerid);
		}
	return 1;
}
//-----< Audio_OnClientDisconnect >---------------------------------------------
public Audio_OnClientDisconnect(playerid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][aDisconnectHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "aDisconnectHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", playerid);
		}
	return 1;
}
//-----< Audio_OnTransferFile >-------------------------------------------------
public Audio_OnTransferFile(playerid, file[], current, total, result)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][aTransferFileHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "aTransferFileHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dsddd", playerid, file, current, total, result);
		}
	return 1;
}
//-----< Audio_OnPlay >---------------------------------------------------------
public Audio_OnPlay(playerid, handleid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][aPlayHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "aPlayHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, handleid);
		}
	return 1;
}
//-----< Audio_OnStop >---------------------------------------------------------
public Audio_OnStop(playerid, handleid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][aStopHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "aStopHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, handleid);
		}
	return 1;
}
//-----< Audio_OnTrackChange >--------------------------------------------------
public Audio_OnTrackChange(playerid, handleid, track[])
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][aTrackChangeHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "aTrackChangeHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dds", playerid, handleid, track);
		}
	return 1;
}
//-----< Audio_OnRadioStationChange >-------------------------------------------
public Audio_OnRadioStationChange(playerid, station)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][aRadioStationChangeHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "aRadioStationChangeHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, station);
		}
	return 1;
}
//-----< Audio_OnGetPosition >--------------------------------------------------
public Audio_OnGetPosition(playerid, handleid, seconds)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][aGetPositionHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "aGetPositionHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddd", playerid, handleid, seconds);
		}
	return 1;
}
//-----< OnDialogRequest >------------------------------------------------------
public OnDialogRequest(playerid, dialogid, olddialogid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][dRequestHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "dRequestHandler", CallbacksList[i][CBName]);
			if(!CallLocalFunction(funcstr, "ddd", playerid, dialogid, olddialogid)) return 0;
		}
	return 1;
}
//-----< OnPlayerSelectObject >-------------------------------------------------
public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pSelectObjectHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pSelectObjectHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddddfff", playerid, type, objectid, modelid, fX, fY, fZ);
		}
	return 1;
}
//-----< OnMpListResponse >-----------------------------------------------------
public OnMpListResponse(playerid, mplistid, selecteditem)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][mplResponseHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "mplResponseHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddd", playerid, mplistid, selecteditem);
		}
	return 1;
}
//-----< OnDynamicObjectMoved >-------------------------------------------------
public OnDynamicObjectMoved(objectid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][doMovedHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "doMovedHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", objectid);
		}
	return 1;
}
//-----< OnPlayerEditDynamicObject >--------------------------------------------
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pEditDynamicObjectHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pEditDynamicObjectHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dddffffff", playerid, objectid, response, x, y, z, rx, ry, rz);
		}
	return 1;
}
//-----< OnPlayerSelectDynamicObject >------------------------------------------
public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pSelectDynamicObjectHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pSelectDynamicObjectHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dddfff", playerid, objectid, modelid, x, y, z);
		}
	return 1;
}
//-----< OnPlayerPickUpDynamicPickup >------------------------------------------
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pPickUpDynamicPickupHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pPickUpDynamicPickupHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, pickupid);
		}
	return 1;
}
//-----< OnPlayerEnterDynamicCP >-----------------------------------------------
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pEnterDynamicCPHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pEnterDynamicCPHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, checkpointid);
		}
	return 1;
}
//-----<  >---------------------------------------------------------------------
public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pLeaveDynamicCPHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pLeaveDynamicCPHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, checkpointid);
		}
	return 1;
}
//-----< OnPlayerEnterDynamicRaceCP >-------------------------------------------
public OnPlayerEnterDynamicRaceCP(playerid, checkpointid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pEnterDynamicRaceCPHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pEnterDynamicRaceCPHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, checkpointid);
		}
	return 1;
}
//-----< OnPlayerLeaveDynamicRaceCP >-------------------------------------------
public OnPlayerLeaveDynamicRaceCP(playerid, checkpointid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pLeaveDynamicRaceCPHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pLeaveDynamicRaceCPHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, checkpointid);
		}
	return 1;
}
//-----< OnPlayerEnterDynamicArea >---------------------------------------------
public OnPlayerEnterDynamicArea(playerid, areaid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pEnterDynamicAreaHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pEnterDynamicAreaHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, areaid);
		}
	return 1;
}
//-----< OnPlayerLeaveDynamicArea >---------------------------------------------
public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	new funcstr[64];
	for(new i = 0; i <= CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][pLeaveDynamicAreaHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pLeaveDynamicAreaHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dd", playerid, areaid);
		}
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< AddHandler >-----------------------------------------------------------
stock AddHandler(name[], ...)
{
	new num = numargs();
	strcpy(CallbacksList[++CallbacksIndex][CBName], name);
	for(new i = 1; i < num; i++)
		if(getarg(i) >= 1 && getarg(i) <= MAX_CALLBACKS)
			CallbacksList[CallbacksIndex][CBIndex][getarg(i)] = 1;
}
//-----<  >---------------------------------------------------------------------
