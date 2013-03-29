/*
 *
 *
 *			Nogov Grant Module
 *		  	2013/03/29
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	
  < Functions >
	GrantCommand(playerid, cmdtext[])
	RevokeCommand(playerid, cmdtext[])
	IsGrantedCommand(playerid, cmdtext[])

*/



//-----< Defines



//-----< Variables



//-----< Callbacks
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< GrantCommand >---------------------------------------------------------
stock GrantCommand(playerid, cmdtext[])
{
	SetPVarInt(playerid, "pGrantedCommands", true, udb_hash(cmdtext));
	return 1;
}
//-----< RevokeCommand >---------------------------------------------------------
stock RevokeCommand(playerid, cmdtext[])
{
	DeletePVar(playerid, "pGrantedCommands", udb_hash(cmdtext));
	return 1;
}
//-----< IsGrantedCommand >-----------------------------------------------------
stock IsGrantedCommand(playerid, cmdtext[])
	return GetPVarInt(playerid, "pGrantedCommands", udb_hash(cmdtext));
//-----<  >---------------------------------------------------------------------
