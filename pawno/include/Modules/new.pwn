/*
 *
 *
 *			Nogov _ Module
 *		  	2013/01/02
 *
 *
 *		Copyright (c) sBum. All rights reserved.
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
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_()
{
	return 1;
}
//-----< gExitHandler >---------------------------------------------------------
public gExitHandler_()
{
	return 1;
}
//-----< pRequestClassHandler >-------------------------------------------------
public pRequestClassHandler_(playerid,classid)
{
	return 1;
}
//-----< pConnectHandler >------------------------------------------------------
public pConnectHandler_(playerid)
{
	return 1;
}
//-----< pDisconnectHandler >---------------------------------------------------
public pDisconnectHandler_(playerid,reason)
{
	return 1;
}
//-----< pSpawnHandler >--------------------------------------------------------
public pSpawnHandler_(playerid)
{
	return 1;
}
//-----< pDeathHandler >--------------------------------------------------------
public pDeathHandler_(playerid,killerid,reason)
{
	return 1;
}
//-----< vSpawnHandler >--------------------------------------------------------
public vSpawnHandler_(vehicleid)
{
	return 1;
}
//-----< vDeathHandler >--------------------------------------------------------
public vDeathHandler_(vehicleid,killerid)
{
	return 1;
}
//-----< pTextHandler >---------------------------------------------------------
public pTextHandler_(playerid,text[])
{
	return 1;
}
//-----< pCommandTextHandler >--------------------------------------------------
public pCommandTextHandler_(playerid,cmdtext[])
{
	return 0;
}
//-----< pEnterVehicleHandler >-------------------------------------------------
public pEnterVehicleHandler_(playerid,vehicleid,ispassenger)
{
	return 1;
}
//-----< pExitVehicleHandler >--------------------------------------------------
public pExitVehicleHandler_(playerid,vehicleid)
{
	return 1;
}
//-----< pStateChangeHandler >--------------------------------------------------
public pStateChangeHandler_(playerid,newstate,oldstate)
{
	return 1;
}
//-----< pEnterCheckpointHandler >----------------------------------------------
public pEnterCheckpointHandler_(playerid)
{
	return 1;
}
//-----< pLeaveCheckpointHandler >----------------------------------------------
public pLeaveCheckpointHandler_(playerid)
{
	return 1;
}
//-----< pEnterRaceCheckpointHandler >------------------------------------------
public pEnterRaceCheckpointHandler_(playerid)
{
	return 1;
}
//-----< pLeaveRaceCheckpointHandler >------------------------------------------
public pLeaveRaceCheckpointHandler_(playerid)
{
	return 1;
}
//-----< RconCommandHandler >---------------------------------------------------
public RconCommandHandler_(cmd[])
{
	return 1;
}
//-----< pRequestSpawnHandler >-------------------------------------------------
public pRequestSpawnHandler_(playerid)
{
	return 1;
}
//-----< ObjectMovedHandler >---------------------------------------------------
public ObjectMovedHandler_(objectid)
{
	return 1;
}
//-----< pObjectMovedHandler >--------------------------------------------------
public pObjectMovedHandler_(playerid,objectid)
{
	return 1;
}
//-----< pPickUpPickupHandler >-------------------------------------------------
public pPickUpPickupHandler_(playerid,pickupid)
{
	return 1;
}
//-----< vModHandler >----------------------------------------------------------
public vModHandler_(playerid,vehicleid,componentid)
{
	return 1;
}
//-----< vPaintjobHandler >-----------------------------------------------------
public vPaintjobHandler_(playerid,vehicleid,paintjobid)
{
	return 1;
}
//-----< vResprayHandler >------------------------------------------------------
public vResprayHandler_(playerid,vehicleid,color1,color2)
{
	return 1;
}
//-----< pSelectedMenuRowHandler >----------------------------------------------
public pSelectedMenuRowHandler_(playerid,row)
{
	return 1;
}
//-----< pExitedMenuHandler >---------------------------------------------------
public pExitedMenuHandler_(playerid)
{
	return 1;
}
//-----< pInteriorChangeHandler >-----------------------------------------------
public pInteriorChangeHandler_(playerid,newinteriorid,oldinteriorid)
{
	return 1;
}
//-----< pKeyStateChangeHandler >-----------------------------------------------
public pKeyStateChangeHandler_(playerid,newkeys,oldkeys)
{
	return 1;
}
//-----< RconLoginAttemptHandler >----------------------------------------------
public RconLoginAttemptHandler_(ip[],password[],success)
{
	return 1;
}
//-----< pUpdateHandler >-------------------------------------------------------
public pUpdateHandler_(playerid)
{
	return 1;
}
//-----< pStreamInHandler >-----------------------------------------------------
public pStreamInHandler_(playerid,forplayerid)
{
	return 1;
}
//-----< pStreamOutHandler >----------------------------------------------------
public pStreamOutHandler_(playerid,forplayerid)
{
	return 1;
}
//-----< vStreamInHandler >-----------------------------------------------------
public vStreamInHandler_(vehicleid,forplayerid)
{
	return 1;
}
//-----< vStreamOutHandler >----------------------------------------------------
public vStreamOutHandler_(vehicleid,forplayerid)
{
	return 1;
}
//-----< DialogResponseHandler >------------------------------------------------
public DialogResponseHandler_(playerid,dialogid,response,listitem,inputtext[])
{
	return 1;
}
//-----< pClickPlayerHandler >--------------------------------------------------
public pClickPlayerHandler_(playerid,clickedplayerid,source)
{
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
