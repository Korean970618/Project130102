/*
	*       Controllable NPC Include created by Lorenc_
	*           		Version: 0.2a
	*
	*   - Credits:
	*       erorcun - Ideas	 		RyDeR` - Mapandreas Include
	*       Y_less - y_ini          Kalcor - SA-MP
	*
	*
*/

/* ** Stopping crap from duplicate ** */
#if defined using_cnpc
	#endinput
#endif
#define using_cnpc

/* ** Includes ** */
#include 							<a_samp>
#include 							<a_npc>
#include 							<YSI/y_ini>

/* ** Configuration ** */
#define MAX_CNPCS       			(100) // Don't modify if you don't know what you're doing!
#define USE_MAPANDREAS              //Un-comment if you wanna disable this. It's so NPC's don't noclip stuff.

#if defined USE_MAPANDREAS
	#include                     	<mapandreas>
#endif


/* ** Variables ** */
enum NPC_DATA
{
	E_ID, 				E_NAME[24], 			E_SKIN,
	Float: E_LOCX, 		Float: E_LOCY, 			Float: E_LOCZ,
	bool: E_CREATED, 	bool: E_CONNECTED,
};

new
	g_cnpcData               		[MAX_CNPCS][NPC_DATA],
	g_cnpcCount                     = -1,
	g_cnpcID                        [MAX_PLAYERS] = {INVALID_PLAYER_ID, ...},
    g_cnpcObject					[MAX_PLAYERS] = {INVALID_OBJECT_ID, ...},
    g_cnpcTimer						[MAX_PLAYERS],
	
	/* ** Hooking ** */
	bool: RL_OPRS,
	bool: RL_OPC,
	bool: RL_OPD
;


/* ** Macro Functions ** */
#define INVALID_CNPC                (Npc: 0xFFFF)
#define GetCNPCTotalCount()			(g_cnpcCount)
#define Convert.ToNPC(%1)			(Npc:%1)
#define GetNPCPlayerID(%1)			(g_cnpcData[%1][E_ID])
#define foreachcnpc(%1)             for(new Npc:%1; _:%1 <= g_cnpcCount; _:%1++) if(g_cnpcData[(_:%1)][E_CONNECTED])
#define strmatch(%1,%2)				!strcmp(%1,%2,false)

/* ** Forwards ** */
forward LoadNPC_data(playerid, name[], value[]);
forward cnpc_MoveNPC(Npc: nID, objectid);

forward OnNpcCreated(npcid);
forward OnNpcFinishedMoving(npcid);
forward OnNpcDestroyed(npcid);
forward OnNpcConnected(npcid);

/*
	native CreateCNPC(name[24], skin, Float: X, Float: Y, Float: Z)
	native SetNpcMoveTo(nID, Float: X, Float: Y, Float: Z, bool: run = false)
	native GetNPCPlayerID(nID)
	native GetDistanceBetweenPlayerAndNPC(playerid, nID)
	native GetClosestNPC(playerid)
	native GetNpcIDFromPlayerID(playerid)
	native StopCNPC(npcid)
	native GetCNPCTotalCount()
	native ReturnNpcName(npcid)
	native SetNPCPos(npcid, Float: X, Float: Y, Float: Z)
	native ApplyAnimationToNPC(npcid, animlib[], animname[], Float: fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
	native SetNPCFacingAngle(npcid, Float: Angle)
	native GiveNPCWeapon(npcid, weaponid, ammo)
	native ResetNPCWeapons(npcid)
	
	native SetPlayerFacePoint(playerid, Float: fX, Float: fY, Float: offset = 0.0)
	native strmatch(const str1[], const str2[])
	native strreplacechar(string[], oldchar, newchar)
	
*/

/* ** 0.2 ** */
#define SetNPCPos(%1,%2,%3,%4) \
	SetPlayerPos(g_cnpcData[_:%1][E_ID],%2,%3,%4)
	
#define SetNPCFacingAngle(%1,%2) \
	SetPlayerFacingAngle(g_cnpcData[_:%1][E_ID],%2)
	
#define ResetNPCWeapons(%1) \
	ResetPlayerWeapons(g_cnpcData[_:%1][E_ID])

#define GiveNPCWeapon(%1,%2,%3) \
	GivePlayerWeapon(g_cnpcData[_:%1][E_ID],%2,%3)

stock ApplyAnimationToNPC( Npc: id, animlib[ ], animname[ ], Float: fDelta, loop, lockx, locky, freeze, time, forcesync = 0 )
{
	for( new i, playerid = g_cnpcData[ _: id ] [ E_ID ]; i < 3; i++ ) {
		if( i != 2 ) ApplyAnimation( playerid, animlib, "null", fDelta, loop, lockx, locky, freeze, time, forcesync ); // Preloading Animation - First/Second time never works...
		else ApplyAnimation( playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync );
	}
}


/* ** 0.1 ** */
stock IsNPCConnected(npcid)
{
	if(g_cnpcData[npcid][E_CONNECTED]) return true;
	return false;
}

stock ReturnNpcName(npcid) 
{
	static p_Name[24] = "Invalid NPC ID";
	format(p_Name, 24, "%s", g_cnpcData[npcid][E_NAME]);
	return p_Name;
}

stock Npc: CreateCNPC(name[24], skin, Float: X, Float: Y, Float: Z)
{
 	new
	    cID = GetFreeCNPCSlot()
	;
	if(cID != 0xFFFF)
	{
		strreplacechar(name, ' ', '_');
	    if(CNPC_NameExists(name)) format(g_cnpcData[cID][E_NAME], MAX_PLAYER_NAME, "%s%d", name, cID);
		else format(g_cnpcData[cID][E_NAME], MAX_PLAYER_NAME, "%s", name);
		g_cnpcData[cID][E_LOCX] = X;
		g_cnpcData[cID][E_LOCY] = Y;
		g_cnpcData[cID][E_LOCZ] = Z;
		g_cnpcData[cID][E_SKIN] = skin;
		g_cnpcData[cID][E_CREATED] = true;
		g_cnpcData[cID][E_CONNECTED] = false;
		g_cnpcCount++;
		ConnectCNPC(cID);
		CallLocalFunction("OnNpcCreated", "d", _:cID);
		return Npc: cID;
	}
	return INVALID_CNPC;
}

stock DestroyCNPC(Npc: nID)
{
	if(!g_cnpcData[_:nID][E_CREATED])
	    return 0;

	if(IsPlayerConnected(g_cnpcData[_:nID][E_ID]) && IsPlayerNPC(g_cnpcData[_:nID][E_ID])) Kick(g_cnpcData[_:nID][E_ID]);
	g_cnpcData[_:nID][E_ID] = INVALID_PLAYER_ID;
	g_cnpcData[_:nID][E_SKIN] = 0;
	g_cnpcData[_:nID][E_CREATED] = false;
	g_cnpcData[_:nID][E_CONNECTED] = false;
	g_cnpcCount--;
	CallLocalFunction("OnNpcDestroyed", "d", _:nID);
	return 1;
}

stock SetPlayerFacePoint(playerid, Float: fX, Float: fY, Float: offset = 0.0)
{
    static
        Float: X,
        Float: Y,
        Float: Z,
        Float: face
    ;
    if(GetPlayerPos(playerid, X, Y, Z))
    {
        face = atan2(fY - Y, fX - X) - 90.0;
        SetPlayerFacingAngle(playerid, face + offset);
    }
}

stock Npc: GetNpcIDFromPlayerID(playerid)
{
	foreachcnpc(i)
	{
	    if(g_cnpcData[_:i][E_ID] == playerid)
	        return Npc:i;
	}
	return INVALID_CNPC;
}

stock GetFreeCNPCSlot()
{
	for(new i; i < MAX_CNPCS; i++)
	{
	    if(!g_cnpcData[i][E_CREATED])
	        return i;
	}
	return 0xFFFF;
}

stock CNPC_NameExists(const name[24])
{
	for(new i; i < MAX_CNPCS; i++)
	{
		if(strmatch(g_cnpcData[i][E_NAME], name))
			return true;
	}
	return false;
}

stock ConnectCNPC(ID)
{
	if(!g_cnpcData[ID][E_CREATED])
	    return 0;

	new
	    szTmp[40],
		INI: iniFile
	;
	format(szTmp, 40, "CNPC/%s.ini", g_cnpcData[_:ID][E_NAME]);
	iniFile = INI_Open(szTmp);
	
	INI_SetTag(		iniFile, 	"data");
	INI_WriteInt(	iniFile, 	"NPCID", ID);
	INI_Close(		iniFile);

	ConnectNPC(g_cnpcData[_:ID][E_NAME], "npcidle");
	return 1;
}

stock SetNpcMoveTo(Npc: nID, Float: X, Float: Y, Float: Z, bool: run = false)
{
	if(!g_cnpcData[_:nID][E_CREATED])
	    return 0;
	    
    new
        playerid = g_cnpcData[_:nID][E_ID],
        Float: pX,
	    Float: pY,
	    Float: pZ
	;
	StopCNPC(nID);
    SetPlayerFacePoint(playerid, X, Y);
	GetPlayerPos(playerid, pX, pY, pZ);

	g_cnpcObject[playerid] = CreateObject(1248, pX, pY, pZ - 1000, 0, 0, 0);
	g_cnpcTimer[playerid]  = SetTimerEx("cnpc_MoveNPC", 75, true, "dd", _:nID, g_cnpcObject[playerid]);

	if(run)
	{
		ApplyAnimation(playerid, "MUSCULAR", "MuscleSprint", 4.1, 1, 1, 1, 1, 0); // Looks much better.
		MoveObject(g_cnpcObject[playerid], X, Y, Z - 1000, 6.5);
	}
	else
	{
		ApplyAnimation(playerid, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 0);
		MoveObject(g_cnpcObject[playerid], X, Y, Z - 1000, 2.5);
	}
	return 1;
}

public cnpc_MoveNPC(Npc: nID, objectid)
{
	if(!g_cnpcData[_:nID][E_CREATED])
	    return 0;

	new
	    Float: X,   Float: oX,
	    Float: Y,   Float: oY,
	    Float: Z,   Float: oZ,
	    Float: fS,

	    playerid = g_cnpcData[_:nID][E_ID]
	;
	GetObjectPos(objectid, oX, oY, oZ);
	GetPlayerPos(playerid, X, Y, Z);
	#if defined USE_MAPANDREAS
	GetPointZPos(oX, oY, oZ);
	fS = 0.8;
	#else
    fS = 1000.0;
	#endif
	if(oX == X && oY == Y && oZ + fS == Z)
	{
		StopCNPC(nID);
		CallLocalFunction("OnNpcFinishedMoving", "d", _:nID);
	    return 1;
	}
	SetPlayerPos(playerid, oX, oY, oZ + fS);

	g_cnpcData[_:nID][E_LOCX] = oX;
	g_cnpcData[_:nID][E_LOCY] = oY;
	g_cnpcData[_:nID][E_LOCZ] = oZ + fS;
	return 1;
}

stock StopCNPC(Npc: nID)
{
	if(!g_cnpcData[_:nID][E_CREATED])
	    return 0;

	new playerid = g_cnpcData[_:nID][E_ID];
	DestroyObject(g_cnpcObject[playerid]);
	g_cnpcObject[playerid] = INVALID_OBJECT_ID;
	KillTimer(g_cnpcTimer[playerid]);
	ClearAnimations(playerid);
	return 1;
}

stock GetDistanceBetweenPlayerAndNPC(playerid, Npc: nID) // Useful for chasing. made it for that purpose actually XD.
{
    new
		Float: pX, Float: pY, Float: pZ
	;
    GetPlayerPos(playerid, pX, pY, pZ);
    return floatround(floatsqroot(floatpower(floatabs(floatsub(g_cnpcData[_:nID][E_LOCX], pX)), 2) + floatpower(floatabs(floatsub(g_cnpcData[_:nID][E_LOCY], pY)), 2) + floatpower(floatabs(floatsub(g_cnpcData[_:nID][E_LOCZ], pZ)), 2)));
}

stock Npc: GetClosestNPC(playerid) // This function contributes to the above, as said, to chase a player :D
{
	new
		Float: fDistance,
		Float: fHighest,
		Npc: iPlayer = INVALID_CNPC
	;
	foreachcnpc(npcid)
	{
	    fDistance = GetDistanceBetweenPlayerAndNPC(playerid, npcid);
    	if(fDistance > fHighest) fHighest = fDistance, iPlayer = Npc: npcid;
	}
	return iPlayer;
}

stock strreplacechar(string[], oldchar, newchar) // I assume it's by some [DRuG] member.
{
	new matches;
	if(ispacked(string)) {
		if(newchar == '\0') {
			for(new i; string{i} != '\0'; i++) {
				if(string{i} == oldchar) {
					strdel(string, i, i + 1);
					matches++;
				}
			}
		} else {
			for(new i; string{i} != '\0'; i++) {
				if(string{i} == oldchar) {
					string{i} = newchar;
					matches++;
				}
			}
		}
	} else {
		if(newchar == '\0') {
			for(new i; string[i] != '\0'; i++) {
				if(string[i] == oldchar) {
					strdel(string, i, i + 1);
					matches++;
				}
			}
		} else {
			for(new i; string[i] != '\0'; i++) {
				if(string[i] == oldchar) {
					string[i] = newchar;
					matches++;
				}
			}
		}
	}
	return matches;
}

public LoadNPC_data(playerid, name[], value[]) {
	if(strmatch(name, "NPCID"))             g_cnpcID[playerid] = strval(value);
}

public OnPlayerRequestSpawn(playerid)
{
	if(IsPlayerNPC(playerid))
	{
	    new
	        name[40]
		;
		GetPlayerName(playerid, name, 24);
		format(name, 40, "CNPC/%s.ini", name);
		if(fexist(name))
		{
		    INI_ParseFile(name, "LoadNPC_%s", .bExtra = true, .extra = playerid);
			new npcid = g_cnpcID[playerid];
		    g_cnpcData[npcid][E_ID] = playerid;
			g_cnpcData[npcid][E_CONNECTED] = true;
		    SetSpawnInfo(playerid, NO_TEAM, g_cnpcData[npcid][E_SKIN], g_cnpcData[npcid][E_LOCX], g_cnpcData[npcid][E_LOCY], g_cnpcData[npcid][E_LOCZ], 0, -1, -1, -1, -1, -1, -1);
			CallLocalFunction("OnNpcConnected", "d", _:npcid);
		}
		return 1;
	}
	return ( RL_OPRS ) ? CallLocalFunction("RL_OnPlayerRequestSpawn", "d", playerid) : 1;
}

#if defined _ALS_OnPlayerRequestSpawn
	#undef OnPlayerRequestSpawn
#else
	#define _ALS_OnPlayerRequestSpawn
#endif
#define OnPlayerRequestSpawn RL_OnPlayerRequestSpawn
forward RL_OnPlayerRequestSpawn( playerid );

public OnPlayerConnect(playerid)
{
    if(IsPlayerNPC(playerid)) 
		return 1;
		
	return ( RL_OPC ) ? CallLocalFunction( "RL_OnPlayerConnect", "d", playerid ) : 1;
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect RL_OnPlayerConnect
forward RL_OnPlayerConnect( playerid );

public OnPlayerDisconnect(playerid, reason)
{
    if(IsPlayerNPC(playerid))
		return DestroyCNPC(GetNpcIDFromPlayerID(playerid)), 1;
	
	return ( RL_OPD ) ? CallLocalFunction( "RL_OnPlayerDisconnect", "dd", playerid, reason ) : 1;
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect RL_OnPlayerDisconnect
forward RL_OnPlayerDisconnect( playerid, reason );

#if !defined FILTERSCRIPT
	public OnGameModeInit()
	{
		RL_OPRS = ( funcidx( "RL_OnPlayerRequestSpawn" ) != -1 );
		RL_OPC = ( funcidx( "RL_OnPlayerConnect" ) != -1 );
		RL_OPD = ( funcidx( "RL_OnPlayerDisconnect" ) != -1 );
		return ( funcidx( "RL_OnGameModeInit" ) != -1 ) ? CallLocalFunction( "RL_OnGameModeInit", "" ) : 1;
	}	
	#if defined _ALS_OnGameModeInit
		#undef OnGameModeInit
	#else
		#define _ALS_OnGameModeInit
	#endif
	#define OnGameModeInit RL_OnGameModeInit
	forward RL_OnGameModeInit();
#else
	public OnFilterScriptInit()
	{
		RL_OPRS = ( funcidx( "RL_OnPlayerRequestSpawn" ) != -1 );
		RL_OPC = ( funcidx( "RL_OnPlayerConnect" ) != -1 );
		RL_OPD = ( funcidx( "RL_OnPlayerDisconnect" ) != -1 );
		return ( funcidx( "RL_OnFilterScriptInit" ) != -1 ) ? CallLocalFunction( "RL_OnFilterScriptInit", "" ) : 1;
	}	
	#if defined _ALS_OnFilterScriptInit
		#undef OnFilterScriptInit
	#else
		#define _ALS_OnFilterScriptInit
	#endif
	#define OnFilterScriptInit RL_OnFilterScriptInit
	forward RL_OnFilterScriptInit();
#endif