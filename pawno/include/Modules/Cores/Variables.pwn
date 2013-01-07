/*
 *
 *
 *		PureunBa(¼­¼º¹ü)
 *
 *			Variables Core
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/02
 *		Update:		2013/01/04
 *
 *
 */
/*

  < Callbacks >
	GameModeInitHandler_Variables()
	ConnectHandler_Variables(playerid)
	
  < Functions >

*/



//-----< Variables
enum eServerInfo
{
	bool:sTogOOC,
	bool:sTogOOW,
	bool:sTogQA,
	bool:sTogNews
};
enum ePlayerInfo
{
	pPassword[128],
	pIP[15],
	pRegDate,
	pLevel,
	pRadio,
	pOrigin[64],
	pMoney,
	pSkin,
	pDeaths,
	pLastQuit,
	pLastPos[64],
	pTutorial,
	pAdmin,
	pWarns,
	pPraises,
	pToy1[256],
	pToy2[256],
	pToy3[256],
	pToy4[256],
	pToy5[256]
};
new ServerInfo[eServerInfo],
	PlayerInfo[MAX_PLAYERS][ePlayerInfo];



//-----< Defines



//-----< Callbacks
forward gInitHandler_Variables();
forward pConnectHandler_Variables(playerid);
forward pDisconnectHandler_Variables(playerid,reason);
forward InitializePlayerVariables(playerid);
//-----< GameModeInitHandler_Variables >----------------------------------------
public gInitHandler_Variables()
{
	ServerInfo[sTogOOC] = false;
	ServerInfo[sTogOOW] = true;
	ServerInfo[sTogQA] = true;
	ServerInfo[sTogNews] = true;
	return 1;
}
//-----< PlayerConnectHandler_Variables >---------------------------------------
public pConnectHandler_Variables(playerid)
{
	InitializePlayerVariables(playerid);
	return 1;
}
//-----< PlayerDisconnectHandler_Variables >------------------------------------
public pDisconnectHandler_Variables(playerid,reason)
{
	#pragma unused reason
    InitializePlayerVariables(playerid);
    return 1;
}
//-----< InitializePlayerVariables >--------------------------------------------
public InitializePlayerVariables(playerid)
{
	strcpy(PlayerInfo[playerid][pPassword],chEmpty);
	strcpy(PlayerInfo[playerid][pIP],chEmpty);
	PlayerInfo[playerid][pRegDate] = 0;
	PlayerInfo[playerid][pLevel] = 0;
	PlayerInfo[playerid][pRadio] = 0;
	strcpy(PlayerInfo[playerid][pOrigin],chEmpty);
	PlayerInfo[playerid][pMoney] = 0;
	PlayerInfo[playerid][pSkin] = 0;
	PlayerInfo[playerid][pDeaths] = 0;
	PlayerInfo[playerid][pLastQuit] = 0;
	strcpy(PlayerInfo[playerid][pLastPos],chEmpty);
	PlayerInfo[playerid][pTutorial] = 0;
	PlayerInfo[playerid][pAdmin] = 0;
	PlayerInfo[playerid][pWarns] = 0;
	PlayerInfo[playerid][pPraises] = 0;
	strcpy(PlayerInfo[playerid][pToy1],chEmpty);
	strcpy(PlayerInfo[playerid][pToy2],chEmpty);
	strcpy(PlayerInfo[playerid][pToy3],chEmpty);
	strcpy(PlayerInfo[playerid][pToy4],chEmpty);
	strcpy(PlayerInfo[playerid][pToy5],chEmpty);
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
