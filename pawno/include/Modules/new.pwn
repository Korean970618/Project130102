/*
 *
 *
 *		PureunBa(¼­¼º¹ü)
 *
 *			_ Module
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
/*

  < Callbacks >
	
  < Functions >

*/



//-----< Variables



//-----< Defines



//-----< Callbacks
//-----< OnGameModeInit >-------------------------------------------------------
public gInitHandler_()
{
	return 1;
}
//-----< OnGameModeExit >-------------------------------------------------------
public gExitHandler_()
{
	return 1;
}
//-----< OnPlayerRequestClass >-------------------------------------------------
public pRequestClassHandler_(playerid,classid)
{
	return 1;
}
//-----< OnPlayerConnect >------------------------------------------------------
public pConnectHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerDisconnect >---------------------------------------------------
public pDisconnectHandler_(playerid,reason)
{
	return 1;
}
//-----< OnPlayerSpawn >--------------------------------------------------------
public pSpawnHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerDeath >--------------------------------------------------------
public pDeathHandler_(playerid,killerid,reason)
{
	return 1;
}
//-----< OnVehicleSpawn >-------------------------------------------------------
public vSpawnHandler_(vehicleid)
{
	return 1;
}
//-----< OnVehicleDeath >-------------------------------------------------------
public vDeathHandler_(vehicleid,killerid)
{
	return 1;
}
//-----< OnPlayerText >---------------------------------------------------------
public pTextHandler_(playerid,text[])
{
	return 1;
}
//-----< OnPlayerCommandText >--------------------------------------------------
public pCommandTextHandler_(playerid,cmdtext[])
{
	return 0;
}
//-----< OnPlayerEnterVehicle >-------------------------------------------------
public pEnterVehicleHandler_(playerid,vehicleid,ispassenger)
{
	return 1;
}
//-----< OnPlayerExitVehicle >--------------------------------------------------
public pExitVehicleHandler_(playerid,vehicleid)
{
	return 1;
}
//-----< OnPlayerStateChange >--------------------------------------------------
public pStateChangeHandler_(playerid,newstate,oldstate)
{
	return 1;
}
//-----< OnPlayerEnterCheckpoint >----------------------------------------------
public pEnterCheckpointHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerLeaveCheckpoint >----------------------------------------------
public pLeaveCheckpointHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerEnterRaceCheckpoint >------------------------------------------
public pEnterRaceCheckpointHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerLeaveRaceCheckpoint >------------------------------------------
public pLeaveRaceCheckpointHandler_(playerid)
{
	return 1;
}
//-----< OnRconCommand >--------------------------------------------------------
public RconCommandHandler_(cmd[])
{
	return 1;
}
//-----< OnPlayerRequestSpawn >-------------------------------------------------
public pRequestSpawnHandler_(playerid)
{
	return 1;
}
//-----< OnObjectMoved >--------------------------------------------------------
public ObjectMovedHandler_(objectid)
{
	return 1;
}
//-----< OnPlayerObjectMoved >--------------------------------------------------
public pObjectMovedHandler_(playerid,objectid)
{
	return 1;
}
//-----< OnPlayerPickUpPickup >-------------------------------------------------
public pPickUpPickupHandler_(playerid,pickupid)
{
	return 1;
}
//-----< OnVehicleMod >---------------------------------------------------------
public vModHandler_(playerid,vehicleid,componentid)
{
	return 1;
}
//-----< OnVehiclePaintjob >----------------------------------------------------
public vPaintjobHandler_(playerid,vehicleid,paintjobid)
{
	return 1;
}
//-----< OnVehicleRespray >-----------------------------------------------------
public vResprayHandler_(playerid,vehicleid,color1,color2)
{
	return 1;
}
//-----< OnPlayerSelectedMenuRow >----------------------------------------------
public pSelectedMenuRowHandler_(playerid,row)
{
	return 1;
}
//-----< OnPlayerExitedMenu >---------------------------------------------------
public pExitedMenuHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerInteriorChange >-----------------------------------------------
public pInteriorChangeHandler_(playerid,newinteriorid,oldinteriorid)
{
	return 1;
}
//-----< OnPlayerKeyStateChange >-----------------------------------------------
public pKeyStateChangeHandler_(playerid,newkeys,oldkeys)
{
	return 1;
}
//-----< OnRconLoginAttempt >---------------------------------------------------
public RconLoginAttemptHandler_(ip[],password[],success)
{
	return 1;
}
//-----< OnPlayerUpdate >-------------------------------------------------------
public pUpdateHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerStreamIn >-----------------------------------------------------
public pStreamInHandler_(playerid,forplayerid)
{
	return 1;
}
//-----< OnPlayerStreamOut >----------------------------------------------------
public pStreamOutHandler_(playerid,forplayerid)
{
	return 1;
}
//-----< OnVehicleStreamIn >----------------------------------------------------
public vStreamInHandler_(vehicleid,forplayerid)
{
	return 1;
}
//-----< OnVehicleStreamOut >---------------------------------------------------
public vStreamOutHandler_(vehicleid,forplayerid)
{
	return 1;
}
//-----< OnDialogResponse >-----------------------------------------------------
public DialogResponseHandler_(playerid,dialogid,response,listitem,inputtext[])
{
	return 1;
}
//-----< OnPlayerClickPlayer >--------------------------------------------------
public pClickPlayerHandler_(playerid,clickedplayerid,source)
{
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
