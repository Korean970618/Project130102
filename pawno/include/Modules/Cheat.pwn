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
	pConnectHandler_Cheat(playerid)
	pUpdateHandler_Cheat(playerid)
	TimerPlayerVehicles(playerid)
	pKeyStateChangeHandler_Cheat(playerid, newkeys, oldkeys)
	pSpawnHandler_Cheat(playerid)
	CheckS0beit(playerid)
	
  < Functions >

*/



//-----< Defines



//-----< Variables
new	LastVehicle[MAX_PLAYERS],
	NumPlayerVehicles[MAX_PLAYERS],
	HandlePlayerVehicles[MAX_PLAYERS];



//-----< Callbacks
forward pConnectHandler_Cheat(playerid);
forward pUpdateHandler_Cheat(playerid);
forward TimerPlayerVehicles(playerid);
forward pKeyStateChangeHandler_Cheat(playerid, newkeys, oldkeys);
forward pSpawnHandler_Cheat(playerid);
forward CheckS0beit(playerid);
//-----< pConnectHandler >------------------------------------------------------
public pConnectHandler_Cheat(playerid)
{
	LastVehicle[playerid] = INVALID_VEHICLE_ID;
	NumPlayerVehicles[playerid]++;
	KillTimer(HandlePlayerVehicles[playerid]);
	HandlePlayerVehicles[playerid] = 0;
	return 1;
}
//-----< pUpdateHandler >-------------------------------------------------------
public pUpdateHandler_Cheat(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if (vehicleid != LastVehicle[playerid])
	{
		NumPlayerVehicles[playerid]++;
		LastVehicle[playerid] = vehicleid;
		KillTimer(HandlePlayerVehicles[playerid]);
		HandlePlayerVehicles[playerid] = SetTimerEx("PlayerVehiclesTimer", 1000, false, "d", playerid);
		if (NumPlayerVehicles[playerid] >= 5)
		{
			SendClientMessage(playerid, COLOR_WHITE, "Vehicle Cleo Detected.");
			TimerPlayerVehicles(playerid);
		}
	}
	return 1;
}
//-----< TimerPlayerVehicles >--------------------------------------------------
public TimerPlayerVehicles(playerid)
{
	NumPlayerVehicles[playerid]++;
	KillTimer(HandlePlayerVehicles[playerid]);
	HandlePlayerVehicles[playerid] = 0;
	return 1;
}
//-----< pKeyStateChangeHandler >-----------------------------------------------
public pKeyStateChangeHandler_Cheat(playerid, newkeys, oldkeys)
{
	new weaponid = GetPlayerWeapon(playerid),
		ammo = GetPlayerAmmo(playerid);
	if (weaponid == 0) return 1;
	else if (WeaponInfo[playerid][weaponid] < ammo)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Weapon Cheat Detected.");
		IpBan(playerid, "Weapon Cheat");
	}
	WeaponInfo[playerid][weaponid] = ammo;
	
	new interiorid = GetPlayerInterior(playerid);
	if (InteriorInfo[playerid] != interiorid)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Interior Cheat Detected.");
		IpBan(playerid, "Interior Cheat");
	}
	InteriorInfo[playerid] = interiorid;
	
	new Float:health = GetPlayerHealthA(playerid);
	if (HealthInfo[playerid] < health)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Health Cheat Detected.");
		IpBan(playerid, "Health Cheat");
	}
	HealthInfo[playerid] = health;
	
	new Float:armour = GetPlayerArmourA(playerid);
	if (ArmourInfo[playerid] < armour)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Armour Cheat Detected.");
		IpBan(playerid, "Armour Cheat");
	}
	ArmourInfo[playerid] = armour;
	
	return 1;
}
//-----< pSpawnHandler >--------------------------------------------------------
public pSpawnHandler_Cheat(playerid)
{
	if (!GetPVarInt(playerid, "FirstSpawn"))
	{
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, false);
		SetTimerEx("CheckS0beit", TimeFix(4000), false, "d", playerid);
	}
	return 1;
}
//-----< CheckS0beit >----------------------------------------------------------
public CheckS0beit(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerCameraFrontVector(playerid, x, y, z);
	#pragma unused x
	#pragma unused y
	if (z < -0.8) SendClientMessage(playerid, COLOR_WHITE, "S0beit Detected.");
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
