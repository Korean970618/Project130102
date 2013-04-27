/*
 *
 *
 *			Position Module
 *		  	2013/02/25
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_Position()
	pUpdateHandler_Position(playerid)
	pTimerTickHandler_Position(nsec, playerid)
	
  < Functions >

*/



//-----< Definess
#define VirtualWorld_Position(%0)		(50+%0)



//-----< Variables
new PositionObject[MAX_PLAYERS];



//-----< Callbacks
forward gInitHandler_Position();
forward pUpdateHandler_Position(playerid);
forward pTimerTickHandler_Position(nsec, playerid);
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_Position()
{
	for(new i = 0; i < sizeof(PositionObject); i++)
		PositionObject[i] = CreateDynamicObject(19133, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, VirtualWorld_Position(0));
	return 1;
}
//-----< pUpdateHandler >-------------------------------------------------------
public pUpdateHandler_Position(playerid)
{
	if(!GetPVarInt(playerid, "LoggedIn") || GetPlayerVirtualWorld(playerid) == VirtualWorld_Position(0)) return 1;
	new Float:ppos[3], Float:opos[3], Float:speed;
	GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
	GetDynamicObjectPos(PositionObject[playerid], opos[0], opos[1], opos[2]);
	speed = GetDistanceBetweenPoints(ppos[0], ppos[1], ppos[2], opos[0], opos[1], opos[2]);
	if(speed != 0.0)
		MoveDynamicObject(PositionObject[playerid], ppos[0], ppos[1], ppos[2], floatround(speed, floatround_ceil) * 10.0);
	return 1;
}
//-----< pTimerTickHandler >----------------------------------------------------
public pTimerTickHandler_Position(nsec, playerid)
{
	if(!GetPVarInt(playerid, "LoggedIn")) return 1;
	if(nsec != 100) return 1;
	new Float:orot[3];
	GetDynamicObjectRot(PositionObject[playerid], orot[0], orot[1], orot[2]);
	SetDynamicObjectRot(PositionObject[playerid], orot[0], orot[1], orot[2] + 36.0);
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
