/*
 *
 *
 *			Nogov Accel Module
 *		  	2013/04/16
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	pUpdateHandler_Accel(playerid)
	
  < Functions >

*/



//-----< Defines



//-----< Variables



//-----< Callbacks
forward pUpdateHandler_Accel(playerid);
//-----< pUpdatHandler >--------------------------------------------------------
public pUpdateHandler_Accel(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerVelocity(playerid, x, y, z);
	new Float:velocity = GetPVarFloat(playerid, "pAccel");
	SetPlayerVelocity(playerid, (x > 0.0) ? velocity : x, (y > 0.0) ? velocity : y, (z > 0.0) ? velocity : z);
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
