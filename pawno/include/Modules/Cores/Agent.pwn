/*
 *
 *
 *		PureunBa(서성범)
 *
 *			Agent Core
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/02/25
 *		Update:		2013/02/26
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_Agent()
	pConnectHandler_Agent(playerid)
	pUpdateHandler_Agent(playerid)
	pCommandTextHandler_Agent(playerid, cmdtext[])
	dResponseHandler_Agent(playerid, dialogid, response, listitem, inputtext[])
	
  < Functions >

*/



//-----< Variables
new PositionObject[MAX_PLAYERS],
	bool:AgentMode[MAX_PLAYERS],
	Float:AgentMarkPos[MAX_PLAYERS][3],
	AgentMarkInterior[MAX_PLAYERS],
	AgentMarkVirtualWorld[MAX_PLAYERS];



//-----< Definess
#define DialogId_Agent(%0)  		(125+%0)
#define VirtualWorld_Agent(%0)  	(25+%0)



//-----< Callbacks
forward gInitHandler_Agent();
forward pConnectHandler_Agent(playerid);
forward pUpdateHandler_Agent(playerid);
forward pCommandTextHandler_Agent(playerid, cmdtext[]);
forward dResponseHandler_Agent(playerid, dialogid, response, listitem, inputtext[]);
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_Agent()
{
	for (new i = 0; i < sizeof(PositionObject); i++)
		PositionObject[i] = CreateDynamicObject(1239, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, VirtualWorld_Agent(0));
	return 1;
}
//-----< pConnectHandler >------------------------------------------------------
public pConnectHandler_Agent(playerid)
{
	AgentMode[playerid] = false;
	for (new i = 0; i < 3; i++)
		AgentMarkPos[playerid][i] = 0.0;
	AgentMarkInterior[playerid] = 0;
	AgentMarkVirtualWorld[playerid] = 0;
	return 1;
}
//-----< pUpdateHandler >-------------------------------------------------------
public pUpdateHandler_Agent(playerid)
{
	if (!GetPVarInt_(playerid, "LoggedIn") || !GetPVarInt_(playerid, "AgentMode")) return 1;
	new Float:ppos[3], Float:opos[3], Float:speed;
	GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
	GetDynamicObjectPos(PositionObject[playerid], opos[0], opos[1], opos[2]);
	speed = GetDistanceBetweenPoints(ppos[0], ppos[1], ppos[2], opos[0], opos[1], opos[2]);
	MoveDynamicObject(PositionObject[playerid], ppos[0], ppos[1], ppos[2], speed);
	return 1;
}
//-----< pCommandTextHandler >--------------------------------------------------
public pCommandTextHandler_Agent(playerid, cmdtext[])
{
	new cmd[256], idx;
	cmd = strtok(cmdtext, idx);
	
	if (!GetPVarInt_(playerid, "pAgent")) return 0;
	else if (!strcmp(cmd, "/에이전트도움말", true) || !strcmp(cmd, "/agenthelp", true))
	{
		new help[2048];
		strcat(help, ""C_PASTEL_YELLOW"/에이전트"C_WHITE": 에이전트 모드를 ON/OFF합니다.\n");
		strcat(help, ""C_PASTEL_YELLOW"/클로킹"C_WHITE": 자신의 모습을 숨깁니다.\n");
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "에이전트 도움말", help, "닫기", "");
		return 1;
	}
	else if (!strcmp(cmd, "/에이전트", true) || !strcmp(cmd, "/agent", true))
	{
		if (AgentMode[playerid])
		{
			AgentMode[playerid] = false;
			SendClientMessage(playerid, COLOR_YELLOW, "에이전트 모드를 종료했습니다.");
			return 1;
		}
		AgentMode[playerid] = true;
		SendClientMessage(playerid, COLOR_YELLOW, "에이전트 모드를 시작합니다.");
		return 1;
	}
	
	if (!AgentMode[playerid]) return 0;
	else if (!strcmp(cmd, "/클로킹", true) || !strcmp(cmd, "/cloaking", true))
	{
		if (GetPlayerVirtualWorld(playerid) != VirtualWorld_Agent(0))
		{
			AgentMarkInterior[playerid] = GetPlayerInterior(playerid);
			AgentMarkVirtualWorld[playerid] = GetPlayerVirtualWorld(playerid);
			GetPlayerPos(playerid, AgentMarkPos[playerid][0], AgentMarkPos[playerid][1], AgentMarkPos[playerid][2]);
			SetPlayerVirtualWorld(playerid, VirtualWorld_Agent(0));
			GameTextForPlayer(playerid, "Cloaked", 1, 2);
		}
		else
		{
		    SetPlayerInterior(playerid, AgentMarkInterior[playerid]);
			SetPlayerVirtualWorld(playerid, AgentMarkVirtualWorld[playerid]);
			SetPlayerPos(playerid, AgentMarkPos[playerid][0], AgentMarkPos[playerid][1], AgentMarkPos[playerid][2]);
			GameTextForPlayer(playerid, "Uncloaked", 1, 2);
		}
		return 1;
	}
	
	return 0;
}
//-----< dResponseHandler >-----------------------------------------------------
public dResponseHandler_Agent(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
