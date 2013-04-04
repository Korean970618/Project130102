/*
 *
 *
 *			Nogov Cheat Module
 *		  	2013/03/29
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	pKeyStateChangeHandler_Cheat(playerid, newkeys, oldkeys)
	pSpawnHandler_Cheat(playerid)
	
  < Functions >

*/



//-----< Defines



//-----< Variables



//-----< Callbacks
forward pKeyStateChangeHandler_Cheat(playerid, newkeys, oldkeys);
forward pSpawnHandler_Cheat(playerid);
//-----< pKeyStateChangeHandler >-----------------------------------------------
public pKeyStateChangeHandler_Cheat(playerid, newkeys, oldkeys)
{
	new weaponid = GetPlayerWeapon(playerid),
		ammo = GetPlayerAmmo(playerid);
	if (weaponid == 0) return 1;
	else if (WeaponInfo[playerid][weaponid] < ammo)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Cheat Detected.");
	}
	WeaponInfo[playerid][weaponid] = ammo;
	
	new interiorid = GetPlayerInterior(playerid);
	if (GetPlayerInterior(playerid) == interiorid)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "Cheat Detected.");
	}
	InteriorInfo[playerid] = interiorid;
	
	return 1;
}
//-----< pSpawnHandler >--------------------------------------------------------
public pSpawnHandler_Cheat(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerCameraFrontVector(playerid, x, y, z);
	#pragma unused x
	#pragma unused y
	if (z < 0.8) SendClientMessage(playerid, COLOR_WHITE, "S0beit Detected.");
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
