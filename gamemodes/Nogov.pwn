/*
 *
 *
 *		PureunBa(¼­¼º¹ü)
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
 *		Release:	2013/01/12
 *		Update:		2013/01/12
 *
 *
 */
/*

  < Modules >
	
  < Functions >
	AddHandler(module[],...)

*/



//-----< Pre-Defines
#define SCRIPT_NAME             "Nogov"
#define SCRIPT_VERSION          "0.0.1"
#define SERVER_HOSTNAME			"[NOGOV] pureunba.tistory.com"


//-----< Includes
#include <a_samp>
#include <Nogov>
//-----< Modules >--------------------------------------------------------------
#include "Modules/Cores/InitExit.pwn"



//-----< Defines
//-----< Handlers >-------------------------------------------------------------
#define GameModeInitHandler         		1
#define GameModeExitHandler         		2
#define PlayerRequestClassHandler   		3
#define PlayerConnectHandler            	4
#define PlayerDisconnectHandler         	5
#define PlayerSpawnHandler              	6
#define PlayerDeathHandler              	7
#define VehicleSpawnHandler             	8
#define VehicleDeathHandler             	9
#define PlayerTextHandler               	10
#define PlayerCommandTextHandler			11
#define PlayerEnterVehicleHandler			12
#define PlayerExitVehicleHandler			13
#define PlayerStateChangeHandler        	14
#define PlayerEnterCheckpointHandler        15
#define PlayerLeaveCheckpointHandler        16
#define PlayerEnterRaceCheckpointHandler    17
#define PlayerLeaveRaceCheckpointHandler    18
#define RconCommandHandler                  19
#define PlayerRequestSpawnHandler       	20
#define ObjectMovedHandler                  21
#define PlayerObjectMovedHandler            22
#define PlayerPickUpPickupHandler           23
#define VehicleModHandler                   24
#define VehiclePaintjobHandler              25
#define VehicleResprayHandler               26
#define PlayerSelectedMenuRowHandler        27
#define PlayerExitedMenuHandler             28
#define PlayerInteriorChangeHandler         29
#define PlayerKeyStateChangeHandler         30
#define RconLoginAttempHandler              31
#define PlayerUpdateHandler                 32
#define PlayerStreamInHandler               33
#define PlayerStreamOutHandler              34
#define VehicleStreamInHandler              35
#define VehicleStreamOutHandler             36
#define DialogResponseHandler               37
#define PlayerClickPlayerHandler            38

#define MAX_CALLBACKS						38
#define CALL_HANDLER(%0,%1)					for(new i=0; i<=CallbacksIndex; i++) if(CallbacksList[i][CBIndex][%0]) { new callstr[64]; format(callstr,64,"%s_%s",%1,CallbacksList[i][CBName]);



//-----< Variables
enum eCallBacks
{
	CBName[16],
	CBIndex[MAX_CALLBACKS+1]
}
new
	CallbacksList[50][eCallBacks],
	CallbacksIndex = -1
;



//-----< Callbacks
//-----< main >-----------------------------------------------------------------
main()
{
    AntiDeAMX();
	printf("\n---------------------------------\n");
	printf(" %s v%s\n",SCRIPT_NAME,SCRIPT_VERSION);
	printf(" \tCoded by PureunBa");
	printf(" \tpureunba.tistory.com\n");
	printf("---------------------------------\n");
	return 1;
}
//-----< OnGameModeInit >-------------------------------------------------------
public OnGameModeInit()
{
    AddHandler("InitExit",		GameModeInitHandler,GameModeExitHandler);

	new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][GameModeInitHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","GameModeInitHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnGameModeExit >-------------------------------------------------------
public OnGameModeExit()
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][GameModeExitHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","GameModeExitHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerRequestClass >-------------------------------------------------
public OnPlayerRequestClass(playerid,classid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerConnect >------------------------------------------------------
public OnPlayerConnect(playerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerConnectHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerConnectHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerDisconnect >---------------------------------------------------
public OnPlayerDisconnect(playerid,reason)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerDisconnectHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerDisconnectHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerSpawn >--------------------------------------------------------
public OnPlayerSpawn(playerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerSpawnHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerSpawnHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerDeath >--------------------------------------------------------
public OnPlayerDeath(playerid,killerid,reason)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerDeathHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerDeathHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnVehicleSpawn >-------------------------------------------------------
public OnVehicleSpawn(vehicleid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][VehicleSpawnHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","VehicleSpawnHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnVehicleDeath >-------------------------------------------------------
public OnVehicleDeath(vehicleid,killerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][VehicleDeathHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","VehicleDeathHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerText >---------------------------------------------------------
public OnPlayerText(playerid,text[])
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerTextHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerTextHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerCommandText >--------------------------------------------------
public OnPlayerCommandText(playerid,cmdtext[])
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerCommandTextHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerCommandTextHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 0;
}
//-----< OnPlayerEnterVehicle >-------------------------------------------------
public OnPlayerEnterVehicle(playerid,vehicleid,ispassenger)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerEnterVehicleHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerEnterVehicleHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerExitVehicle >--------------------------------------------------
public OnPlayerExitVehicle(playerid,vehicleid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerExitVehicleHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerExitVehicleHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerStateChange >--------------------------------------------------
public OnPlayerStateChange(playerid,newstate,oldstate)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerStateChangeHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerStateChangeHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerEnterCheckpoint >----------------------------------------------
public OnPlayerEnterCheckpoint(playerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerEnterCheckpointHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerEnterCheckpointHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerLeaveCheckpoint >----------------------------------------------
public OnPlayerLeaveCheckpoint(playerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerLeaveCheckpointHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerLeaveCheckpointHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerEnterRaceCheckpoint >------------------------------------------
public OnPlayerEnterRaceCheckpoint(playerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerEnterRaceCheckpointHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerEnterRaceCheckpointHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerLeaveRaceCheckpoint >------------------------------------------
public OnPlayerLeaveRaceCheckpoint(playerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerLeaveRaceCheckpointHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerLeaveRaceCheckpointHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnRconCommand >--------------------------------------------------------
public OnRconCommand(cmd[])
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][RconCommandHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","RconCommandHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerRequestSpawn >-------------------------------------------------
public OnPlayerRequestSpawn(playerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnObjectMoved >--------------------------------------------------------
public OnObjectMoved(objectid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerObjectMoved >--------------------------------------------------
public OnPlayerObjectMoved(playerid,objectid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerPickUpPickup >-------------------------------------------------
public OnPlayerPickUpPickup(playerid,pickupid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnVehicleMod >---------------------------------------------------------
public OnVehicleMod(playerid,vehicleid,componentid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][VehicleModHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","VehicleModHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnVehiclePaintjob >----------------------------------------------------
public OnVehiclePaintjob(playerid,vehicleid,paintjobid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][VehiclePaintjobHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","VehiclePaintjobHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnVehicleRespray >-----------------------------------------------------
public OnVehicleRespray(playerid,vehicleid,color1,color2)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][VehicleResprayHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","VehicleResprayHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerSelectedMenuRow >----------------------------------------------
public OnPlayerSelectedMenuRow(playerid,row)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerSelectedMenuRowHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerSelectedMenuRowHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerExitedMenu >---------------------------------------------------
public OnPlayerExitedMenu(playerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerExitedMenuHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerExitedMenuHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerInteriorChange >-----------------------------------------------
public OnPlayerInteriorChange(playerid,newinteriorid,oldinteriorid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerKeyStateChange >-----------------------------------------------
public OnPlayerKeyStateChange(playerid,newkeys,oldkeys)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnRconLoginAttempt >---------------------------------------------------
public OnRconLoginAttempt(ip[],password[],success)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerUpdate >-------------------------------------------------------
public OnPlayerUpdate(playerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerStreamIn >-----------------------------------------------------
public OnPlayerStreamIn(playerid,forplayerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerStreamOut >----------------------------------------------------
public OnPlayerStreamOut(playerid,forplayerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnVehicleStreamIn >----------------------------------------------------
public OnVehicleStreamIn(vehicleid,forplayerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnVehicleStreamOut >---------------------------------------------------
public OnVehicleStreamOut(vehicleid,forplayerid)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerRequestClassHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerRequestClassHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnDialogResponse >-----------------------------------------------------
public OnDialogResponse(playerid,dialogid,response,listitem,inputtext[])
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][DialogResponseHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","DialogResponseHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----< OnPlayerClickPlayer >--------------------------------------------------
public OnPlayerClickPlayer(playerid,clickedplayerid,source)
{
    new funcstr[64];
	for(new i=0; i<=CallbacksIndex; i++)
		if(CallbacksList[i][CBIndex][PlayerClickPlayerHandler])
		{
			format(funcstr,sizeof(funcstr),"%s_%s","PlayerClickPlayerHandler",CallbacksList[i][CBName]);
			CallLocalFunction(funcstr,"");
		}
	return 1;
}
//-----<  >---------------------------------------------------------------------

//-----< Functions
//-----< AddHandler >-----------------------------------------------------------
stock AddHandler(name[],...)
{
	new num = numargs();
	strcpy(CallbacksList[++CallbacksIndex][CBName],name);
	for(new i=1; i<num; i++)
		if(getarg(i) >= 1 && getarg(i) <= MAX_CALLBACKS)
			CallbacksList[CallbacksIndex][CBIndex][getarg(i)] = 1;
}
//-----<  >---------------------------------------------------------------------
//-----<  >---------------------------------------------------------------------
