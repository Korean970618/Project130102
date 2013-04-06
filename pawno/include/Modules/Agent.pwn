/*
 *
 *
 *			Agent Module
 *		  	2013/02/25
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_Agent()
	pUpdateHandler_Agent(playerid)
	pTimerTickHandler_Agent(nsec, playerid)
	pCommandTextHandler_Agent(playerid, cmdtext[])
	dResponseHandler_Agent(playerid, dialogid, response, listitem, inputtext[])
	
  < Functions >
	AgentLog(playerid, result[])

*/



//-----< Definess
#define DialogId_Agent(%0)  		(125+%0)
#define VirtualWorld_Agent(%0)  	(25+%0)



//-----< Variables
new PositionObject[MAX_PLAYERS];



//-----< Callbacks
forward gInitHandler_Agent();
forward pUpdateHandler_Agent(playerid);
forward pTimerTickHandler_Agent(nsec, playerid);
forward pCommandTextHandler_Agent(playerid, cmdtext[]);
forward dResponseHandler_Agent(playerid, dialogid, response, listitem, inputtext[]);
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_Agent()
{
	for (new i = 0; i < sizeof(PositionObject); i++)
		PositionObject[i] = CreateDynamicObject(19133, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, VirtualWorld_Agent(0));
	return 1;
}
//-----< pUpdateHandler >-------------------------------------------------------
public pUpdateHandler_Agent(playerid)
{
	if (!GetPVarInt(playerid, "LoggedIn") || GetPVarInt(playerid, "pAgentMode")) return 1;
	new Float:ppos[3], Float:opos[3], Float:speed;
	GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
	GetDynamicObjectPos(PositionObject[playerid], opos[0], opos[1], opos[2]);
	speed = GetDistanceBetweenPoints(ppos[0], ppos[1], ppos[2], opos[0], opos[1], opos[2]);
	if (speed != 0.0)
		MoveDynamicObject(PositionObject[playerid], ppos[0], ppos[1], ppos[2], floatround(speed, floatround_ceil) * 10.0);
	return 1;
}
//-----< pTimerTickHandler >----------------------------------------------------
public pTimerTickHandler_Agent(nsec, playerid)
{
	if (!GetPVarInt(playerid, "LoggedIn")) return 1;
	if (nsec != 100) return 1;
	new Float:orot[3];
	GetDynamicObjectRot(PositionObject[playerid], orot[0], orot[1], orot[2]);
	SetDynamicObjectRot(PositionObject[playerid], orot[0], orot[1], orot[2] + 36.0);
	return 1;
}
//-----< pCommandTextHandler >--------------------------------------------------
public pCommandTextHandler_Agent(playerid, cmdtext[])
{
	new cmd[256], idx;
	cmd = strtok(cmdtext, idx);
	
	if (!GetPVarInt(playerid, "pAgent")) return 0;
	else if (!strcmp(cmd, "/에이전트", true) || !strcmp(cmd, "/agent", true))
	{
		if (GetPVarInt(playerid, "pAgentMode"))
		{
			DeletePVar(playerid, "pAgentMode");
			UnloadPlayerItemData(playerid);
			LoadPlayerItemData(playerid);
			SendClientMessage(playerid, COLOR_YELLOW, "에이전트 모드를 종료했습니다.");
			AgentLog(playerid, "에이전트 모드를 종료했습니다.");
			return 1;
		}
		SetPVarInt(playerid, "pAgentMode", true);
		LoadPlayerItemData(playerid);
		for (new i = 0, t = GetMaxPlayerItems(); i < t; i++)
			if (IsValidPlayerItemID(playerid, i))
				DestroyPlayerItem(playerid, i);
		SendClientMessage(playerid, COLOR_YELLOW, "에이전트 모드를 시작합니다.");
		AgentLog(playerid, "에이전트 모드를 시작합니다.");
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
//-----< AgentLog >-------------------------------------------------------------
stock AgentLog(playerid, result[])
{
	new File:fHandle,
		str[256],
		year, month, day,
		hour, minute, second;
	getdate(year, month, day);
	format(str, sizeof(str), "AgentLog/%s_%d년%d월%d일.txt", GetPlayerNameA(playerid), year, month, day);
	fHandle = fopen(str, io_append);
	if (fHandle)
	{
		gettime(hour, minute, second);
		format(str, sizeof(str), "\r\n[%d:%d:%d] ", hour, minute, second);
		fwrite(fHandle, str);
		for (new i = 0, t = strlen(result); i < t; i++)
			fputchar(fHandle, result[i], false);
	}
	fclose(fHandle);
}
//-----<  >---------------------------------------------------------------------
