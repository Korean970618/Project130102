/*
 *
 *
 *		PureunBa(서성범)
 *
 *			Nogov Main Script
 *			v0.0.1
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/02
 *		Update:		2013/01/10
 *
 *
 */
/*

  < Dialog List >
	0: Nogov Main Script
	25: UserData Core
	50: Admin Command

  < Functions >
	AddHandler(module[], ...)

*/



//-----< Pre-Defines
#define SCRIPT_NAME             "Nogov"
#define SCRIPT_VERSION          "0.0.1"
#define SERVER_HOSTNAME			"[NOGOV] pureunba.tistory.com"


//-----< Includes
#include <a_samp>
#include <Nogov>
#include <mysql>
//-----< Modules >--------------------------------------------------------------
#include "Modules/Cores/InitExit.pwn"
#include "Modules/Cores/UserData.pwn"
#include "Modules/Cores/MySQL.pwn"
#include "Modules/Commands/Admin.pwn"



//-----< Defines
//-----< Handlers >-------------------------------------------------------------
#define gInitHandler         			1
#define gExitHandler         			2
#define pRequestClassHandler   			3
#define pConnectHandler            		4
#define pDisconnectHandler         		5
#define pSpawnHandler              		6
#define pDeathHandler              		7
#define vSpawnHandler             		8
#define vDeathHandler             		9
#define pTextHandler               		10
#define pCommandTextHandler				11
#define pEnterVehicleHandler			12
#define pExitVehicleHandler				13
#define pStateChangeHandler        		14
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
#define pClickPlayerHandler				38
#define tTickHandler					39
#define pTimerTickHandler				40

#define MAX_CALLBACKS					40
#define CALL_HANDLER(%0,%1)				for (new i = 0; i <= CallbacksIndex; i++) if (CallbacksList[i][CBIndex][%0]) { new callstr[64]; format(callstr, 64, "%s_%s", %1, CallbacksList[i][CBName]);



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
//-----< main >-----------------------------------------------------------------
main()
{
    AntiDeAMX();
	printf("\n---------------------------------\n");
	printf(" %s v%s\n", SCRIPT_NAME, SCRIPT_VERSION);
	printf(" \tCoded by PureunBa");
	printf(" \tpureunba.tistory.com\n");
	printf("---------------------------------\n");
	return 1;
}
//-----< OnGameModeInit >-------------------------------------------------------
public OnGameModeInit()
{
	// Cores
    AddHandler("InitExit",			gInitHandler, gExitHandler);
    AddHandler("UserData",			gInitHandler, pConnectHandler, pRequestSpawnHandler, pDeathHandler, pSpawnHandler, pCommandTextHandler, dResponseHandler, pTimerTickHandler);
    AddHandler("MySQL",             gInitHandler);
    // Commands
	AddHandler("Admin",				pCommandTextHandler, dResponseHandler);
	
	SetTimer("OnTimerTick", TimeFix(20), true);
	Timer_OneSecTimer = GetTickCount();

	new funcstr[64];
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][gInitHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][gExitHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pRequestClassHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pConnectHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pDisconnectHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pSpawnHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pSpawnHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "d", playerid);
		}
	return 1;
}
//-----< OnPlayerDeath >--------------------------------------------------------
public OnPlayerDeath(playerid, killerid, reason)
{
    new funcstr[64];
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pDeathHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][vSpawnHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][vDeathHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pTextHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pTextHandler", CallbacksList[i][CBName]);
			if (!CallLocalFunction(funcstr, "ds", playerid, text)) return 0;
		}
	return 1;
}
//-----< OnPlayerCommandText >--------------------------------------------------
public OnPlayerCommandText(playerid, cmdtext[])
{
    new funcstr[64];
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pCommandTextHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pCommandTextHandler", CallbacksList[i][CBName]);
			if (CallLocalFunction(funcstr, "ds", playerid, cmdtext)) return 1;
		}
	SendClientMessage(playerid, COLOR_WHITE, "[SERVER] 존재하지 않는 명령어입니다.");
	return 1;
}
//-----< OnPlayerEnterVehicle >-------------------------------------------------
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    new funcstr[64];
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pEnterVehicleHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pExitVehicleHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pStateChangeHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pEnterCheckpointHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pLeaveCheckpointHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pEnterRaceCheckpointHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pLeaveRaceCheckpointHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][RconCommandHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "RconCommandHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "s", cmd);
		}
	return 1;
}
//-----< OnPlayerRequestSpawn >-------------------------------------------------
public OnPlayerRequestSpawn(playerid)
{
    new funcstr[64];
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pRequestClassHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pRequestClassHandler", CallbacksList[i][CBName]);
			if (!CallLocalFunction(funcstr, "d", playerid)) return 0;
		}
	return 1;
}
//-----< OnObjectMoved >--------------------------------------------------------
public OnObjectMoved(objectid)
{
    new funcstr[64];
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][oMovedHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pObjectMovedHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pPickUpPickupHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][vModHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][vPaintjobHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][vResprayHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pSelectedMenuRowHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pExitedMenuHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pInteriorChangeHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pKeyStateChangeHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pRequestClassHandlerHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddd", playerid, newkeys, oldkeys);
		}
	return 1;
}
//-----< OnRconLoginAttempt >---------------------------------------------------
public OnRconLoginAttempt(ip[], password[], success)
{
    new funcstr[64];
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][RconLoginAttempHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "RconLoginAttempHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ssd", ip, password, success);
		}
	return 1;
}
//-----< OnPlayerUpdate >-------------------------------------------------------
public OnPlayerUpdate(playerid)
{
    new funcstr[64];
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pUpdateHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pStreamInHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pStreamOutHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][vStreamInHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][vStreamOutHandler])
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
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][dResponseHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "dResponseHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "dddds", playerid, dialogid, response, listitem, inputtext);
		}
	return 1;
}
//-----< OnPlayerClickPlayer >--------------------------------------------------
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    new funcstr[64];
	for (new i = 0; i <= CallbacksIndex; i++)
		if (CallbacksList[i][CBIndex][pClickPlayerHandler])
		{
			format(funcstr, sizeof(funcstr), "%s_%s", "pClickPlayerHandler", CallbacksList[i][CBName]);
			CallLocalFunction(funcstr, "ddd", playerid, clickedplayerid, source);
		}
	return 1;
}
//-----< OnTimerTick >----------------------------------------------------------
public OnTimerTick()
{
	new funcstr[64];
	for (new i = 0; i <= CallbacksIndex; i++)
        if (CallbacksList[i][CBIndex][tTickHandler])
        {
        	format(funcstr, sizeof(funcstr), "%s_%s", "tTickHandler", CallbacksList[i][CBName]);
            CallLocalFunction(funcstr, "d", 20);
		}
	for (new i = 0, t = GetMaxPlayers(); i < t; i++)
	    for(new j = 0; j <= CallbacksIndex; j++)
	        if (CallbacksList[j][CBIndex][pTimerTickHandler])
	        {
	            format(funcstr, sizeof(funcstr), "%s_%s", "pTimerTickHandler", CallbacksList[j][CBName]);
	            CallLocalFunction(funcstr, "dd", 20, i);
			}
	if ((GetTickCount() - Timer_OneSecTimer) / 1000)
	{
	    for (new i = 0; i <= CallbacksIndex; i++)
	        if (CallbacksList[i][CBIndex][tTickHandler])
	        {
	        	format(funcstr, sizeof(funcstr), "%s_%s", "tTickHandler", CallbacksList[i][CBName]);
	            CallLocalFunction(funcstr, "d", 1000);
			}
		for (new i = 0, t = GetMaxPlayers(); i < t; i++)
		    for(new j = 0; j <= CallbacksIndex; j++)
		        if (CallbacksList[j][CBIndex][pTimerTickHandler])
		        {
		            format(funcstr, sizeof(funcstr), "%s_%s", "pTimerTickHandler", CallbacksList[j][CBName]);
					CallLocalFunction(funcstr, "dd", 1000, i);
				}
	    Timer_OneSecTimer = GetTickCount();
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
	for (new i = 1; i < num; i++)
		if (getarg(i) >= 1 && getarg(i) <= MAX_CALLBACKS)
			CallbacksList[CallbacksIndex][CBIndex][getarg(i)] = 1;
}
//-----<  >---------------------------------------------------------------------
