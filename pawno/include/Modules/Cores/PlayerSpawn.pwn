/*
 *
 *
 *		PureunBa(¼­¼º¹ü)
 *
 *			PlayerSpawn Core
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/30
 *		Update:		2013/01/30
 *
 *
 */
/*

  < Callbacks >
    pSpawnHandler_PlayerSpawn(playerid)
	
  < Functions >
	SpawnPlayer_(playerid)

*/



//-----< Variables



//-----< Defines



//-----< Callbacks
forward pSpawnHandler_PlayerSpawn(playerid);
//-----< pSpawnHandler >--------------------------------------------------------
public pSpawnHandler_PlayerSpawn(playerid)
{
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< SpawnPlayer_ >---------------------------------------------------------
stock SpawnPlayer_(playerid)
{
	SetSpawnInfo(playerid, 0, GetPVarInt_(playerid, "pSkin"), 1675.9365, -2258.1887, 13.3709, 108.9242, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}
//-----<  >---------------------------------------------------------------------
