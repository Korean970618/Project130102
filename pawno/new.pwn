/*
 *
 *
 *		PureunBa(¼­¼º¹ü)
 *
 *			_ Script
 *			v1.0.0
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2000/00/00
 *		Update:		2000/00/00
 *
 *
 */
/*

  < Callbacks >
	
  < Functions >

*/

//-----< Includes
#include <a_samp>

//-----< Variables

//-----< Defines
#define SCRIPT_NAME             "_"
#define SCRIPT_VERSION          "1.0.0"

//-----< Callbacks
//-----< main >-----------------------------------------------------------------
main()
{
    AntiDeAMX();
	printf("\n---------------------------------\n");
	printf(" %s v%s\n",SCRIPT_NAME,SCRIPT_VERSION);
	printf(" \tCoded by PureunBa");
	printf(" \tblog.naver.com/tjtjdqja97\n");
	printf("---------------------------------\n");
	return 1;
}
//-----< OnGameModeInit >-------------------------------------------------------
public OnGameModeInit()
{
	SetGameModeText("Blank Script");
	AddPlayerClass(0,1958.3783,1343.1572,15.3746,269.1425,0,0,0,0,0,0);
	return 1;
}
//-----< OnGameModeExit >-------------------------------------------------------
public OnGameModeExit()
{
	return 1;
}
//-----< OnPlayerRequestClass >-------------------------------------------------
public OnPlayerRequestClass(playerid,classid)
{
	SetPlayerPos(playerid,1958.3783,1343.1572,15.3746);
	SetPlayerCameraPos(playerid,1958.3783,1343.1572,15.3746);
	SetPlayerCameraLookAt(playerid,1958.3783,1343.1572,15.3746);
	return 1;
}
//-----< OnPlayerConnect >------------------------------------------------------
public OnPlayerConnect(playerid)
{
	return 1;
}
//-----< OnPlayerDisconnect >---------------------------------------------------
public OnPlayerDisconnect(playerid,reason)
{
	return 1;
}
//-----< OnPlayerSpawn >--------------------------------------------------------
public OnPlayerSpawn(playerid)
{
	return 1;
}
//-----< OnPlayerDeath >--------------------------------------------------------
public OnPlayerDeath(playerid,killerid,reason)
{
	return 1;
}
//-----< OnVehicleSpawn >-------------------------------------------------------
public OnVehicleSpawn(vehicleid)
{
	return 1;
}
//-----< OnVehicleDeath >-------------------------------------------------------
public OnVehicleDeath(vehicleid,killerid)
{
	return 1;
}
//-----< OnPlayerText >---------------------------------------------------------
public OnPlayerText(playerid,text[])
{
	return 1;
}
//-----< OnPlayerCommandText >--------------------------------------------------
public OnPlayerCommandText(playerid,cmdtext[])
{
	return 0;
}
//-----< OnPlayerEnterVehicle >-------------------------------------------------
public OnPlayerEnterVehicle(playerid,vehicleid,ispassenger)
{
	return 1;
}
//-----< OnPlayerExitVehicle >--------------------------------------------------
public OnPlayerExitVehicle(playerid,vehicleid)
{
	return 1;
}
//-----< OnPlayerStateChange >--------------------------------------------------
public OnPlayerStateChange(playerid,newstate,oldstate)
{
	return 1;
}
//-----< OnPlayerEnterCheckpoint >----------------------------------------------
public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}
//-----< OnPlayerLeaveCheckpoint >----------------------------------------------
public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}
//-----< OnPlayerEnterRaceCheckpoint >------------------------------------------
public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}
//-----< OnPlayerLeaveRaceCheckpoint >------------------------------------------
public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}
//-----< OnRconCommand >--------------------------------------------------------
public OnRconCommand(cmd[])
{
	return 1;
}
//-----< OnPlayerRequestSpawn >-------------------------------------------------
public OnPlayerRequestSpawn(playerid)
{
	return 1;
}
//-----< OnObjectMoved >--------------------------------------------------------
public OnObjectMoved(objectid)
{
	return 1;
}
//-----< OnPlayerObjectMoved >--------------------------------------------------
public OnPlayerObjectMoved(playerid,objectid)
{
	return 1;
}
//-----< OnPlayerPickUpPickup >-------------------------------------------------
public OnPlayerPickUpPickup(playerid,pickupid)
{
	return 1;
}
//-----< OnVehicleMod >---------------------------------------------------------
public OnVehicleMod(playerid,vehicleid,componentid)
{
	return 1;
}
//-----< OnVehiclePaintjob >----------------------------------------------------
public OnVehiclePaintjob(playerid,vehicleid,paintjobid)
{
	return 1;
}
//-----< OnVehicleRespray >-----------------------------------------------------
public OnVehicleRespray(playerid,vehicleid,color1,color2)
{
	return 1;
}
//-----< OnPlayerSelectedMenuRow >----------------------------------------------
public OnPlayerSelectedMenuRow(playerid,row)
{
	return 1;
}
//-----< OnPlayerExitedMenu >---------------------------------------------------
public OnPlayerExitedMenu(playerid)
{
	return 1;
}
//-----< OnPlayerInteriorChange >-----------------------------------------------
public OnPlayerInteriorChange(playerid,newinteriorid,oldinteriorid)
{
	return 1;
}
//-----< OnPlayerKeyStateChange >-----------------------------------------------
public OnPlayerKeyStateChange(playerid,newkeys,oldkeys)
{
	return 1;
}
//-----< OnRconLoginAttempt >---------------------------------------------------
public OnRconLoginAttempt(ip[],password[],success)
{
	return 1;
}
//-----< OnPlayerUpdate >-------------------------------------------------------
public OnPlayerUpdate(playerid)
{
	return 1;
}
//-----< OnPlayerStreamIn >-----------------------------------------------------
public OnPlayerStreamIn(playerid,forplayerid)
{
	return 1;
}
//-----< OnPlayerStreamOut >----------------------------------------------------
public OnPlayerStreamOut(playerid,forplayerid)
{
	return 1;
}
//-----< OnVehicleStreamIn >----------------------------------------------------
public OnVehicleStreamIn(vehicleid,forplayerid)
{
	return 1;
}
//-----< OnVehicleStreamOut >---------------------------------------------------
public OnVehicleStreamOut(vehicleid,forplayerid)
{
	return 1;
}
//-----< OnDialogResponse >-----------------------------------------------------
public OnDialogResponse(playerid,dialogid,response,listitem,inputtext[])
{
	return 1;
}
//-----< OnPlayerClickPlayer >--------------------------------------------------
public OnPlayerClickPlayer(playerid,clickedplayerid,source)
{
	return 1;
}
//-----<  >---------------------------------------------------------------------

//-----< Functions
//-----<  >---------------------------------------------------------------------
