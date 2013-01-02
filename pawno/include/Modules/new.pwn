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
public GameModeInitHandler_()
{
	return 1;
}
//-----< OnGameModeExit >-------------------------------------------------------
public GameModeExitHandler_()
{
	return 1;
}
//-----< OnPlayerRequestClass >-------------------------------------------------
public PlayerRequestClassHandler_(playerid,classid)
{
	return 1;
}
//-----< OnPlayerConnect >------------------------------------------------------
public PlayerConnectHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerDisconnect >---------------------------------------------------
public PlayerDisconnectHandler_(playerid,reason)
{
	return 1;
}
//-----< OnPlayerSpawn >--------------------------------------------------------
public PlayerSpawnHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerDeath >--------------------------------------------------------
public PlayerDeathHandler_(playerid,killerid,reason)
{
	return 1;
}
//-----< OnVehicleSpawn >-------------------------------------------------------
public VehicleSpawnHandler_(vehicleid)
{
	return 1;
}
//-----< OnVehicleDeath >-------------------------------------------------------
public VehicleDeathHandler_(vehicleid,killerid)
{
	return 1;
}
//-----< OnPlayerText >---------------------------------------------------------
public PlayerTextHandler_(playerid,text[])
{
	return 1;
}
//-----< OnPlayerCommandText >--------------------------------------------------
public PlayerCommandTextHandler_(playerid,cmdtext[])
{
	return 0;
}
//-----< OnPlayerEnterVehicle >-------------------------------------------------
public PlayerEnterVehicleHandler_(playerid,vehicleid,ispassenger)
{
	return 1;
}
//-----< OnPlayerExitVehicle >--------------------------------------------------
public PlayerExitVehicleHandler_(playerid,vehicleid)
{
	return 1;
}
//-----< OnPlayerStateChange >--------------------------------------------------
public PlayerStateChangeHandler_(playerid,newstate,oldstate)
{
	return 1;
}
//-----< OnPlayerEnterCheckpoint >----------------------------------------------
public PlayerEnterCheckpointHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerLeaveCheckpoint >----------------------------------------------
public PlayerLeaveCheckpointHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerEnterRaceCheckpoint >------------------------------------------
public PlayerEnterRaceCheckpointHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerLeaveRaceCheckpoint >------------------------------------------
public PlayerLeaveRaceCheckpointHandler_(playerid)
{
	return 1;
}
//-----< OnRconCommand >--------------------------------------------------------
public RconCommandHandler_(cmd[])
{
	return 1;
}
//-----< OnPlayerRequestSpawn >-------------------------------------------------
public PlayerRequestSpawnHandler_(playerid)
{
	return 1;
}
//-----< OnObjectMoved >--------------------------------------------------------
public ObjectMovedHandler_(objectid)
{
	return 1;
}
//-----< OnPlayerObjectMoved >--------------------------------------------------
public PlayerObjectMovedHandler_(playerid,objectid)
{
	return 1;
}
//-----< OnPlayerPickUpPickup >-------------------------------------------------
public PlayerPickUpPickupHandler_(playerid,pickupid)
{
	return 1;
}
//-----< OnVehicleMod >---------------------------------------------------------
public VehicleModHandler_(playerid,vehicleid,componentid)
{
	return 1;
}
//-----< OnVehiclePaintjob >----------------------------------------------------
public VehiclePaintjobHandler_(playerid,vehicleid,paintjobid)
{
	return 1;
}
//-----< OnVehicleRespray >-----------------------------------------------------
public VehicleResprayHandler_(playerid,vehicleid,color1,color2)
{
	return 1;
}
//-----< OnPlayerSelectedMenuRow >----------------------------------------------
public PlayerSelectedMenuRowHandler_(playerid,row)
{
	return 1;
}
//-----< OnPlayerExitedMenu >---------------------------------------------------
public PlayerExitedMenuHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerInteriorChange >-----------------------------------------------
public PlayerInteriorChangeHandler_(playerid,newinteriorid,oldinteriorid)
{
	return 1;
}
//-----< OnPlayerKeyStateChange >-----------------------------------------------
public PlayerKeyStateChangeHandler_(playerid,newkeys,oldkeys)
{
	return 1;
}
//-----< OnRconLoginAttempt >---------------------------------------------------
public RconLoginAttemptHandler_(ip[],password[],success)
{
	return 1;
}
//-----< OnPlayerUpdate >-------------------------------------------------------
public PlayerUpdateHandler_(playerid)
{
	return 1;
}
//-----< OnPlayerStreamIn >-----------------------------------------------------
public PlayerStreamInHandler_(playerid,forplayerid)
{
	return 1;
}
//-----< OnPlayerStreamOut >----------------------------------------------------
public PlayerStreamOutHandler_(playerid,forplayerid)
{
	return 1;
}
//-----< OnVehicleStreamIn >----------------------------------------------------
public VehicleStreamInHandler_(vehicleid,forplayerid)
{
	return 1;
}
//-----< OnVehicleStreamOut >---------------------------------------------------
public VehicleStreamOutHandler_(vehicleid,forplayerid)
{
	return 1;
}
//-----< OnDialogResponse >-----------------------------------------------------
public DialogResponseHandler_(playerid,dialogid,response,listitem,inputtext[])
{
	return 1;
}
//-----< OnPlayerClickPlayer >--------------------------------------------------
public PlayerClickPlayerHandler_(playerid,clickedplayerid,source)
{
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
